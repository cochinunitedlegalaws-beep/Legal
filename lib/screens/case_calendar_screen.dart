import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'event_detail_screen.dart';
import '../widgets/add_case_event_dialog.dart';
import '../services/case_service.dart';
import '../services/meeting_service.dart';
import '../services/client_service.dart';
import '../services/task_service.dart';
import '../models/task_model.dart';
import '../utils/display_name_helper.dart';
import '../services/user_service.dart';
import '../widgets/responsive.dart';

DateTime? _parseHearingDate(dynamic raw) {
  if (raw == null) return null;
  final str = raw.toString().trim();
  if (str.isEmpty || str == 'N/A' || str == 'null') return null;

  final isoParsed = DateTime.tryParse(str);
  if (isoParsed != null) return isoParsed;

  final cleanStr = str.replaceAll('/', '-');
  final parts = cleanStr.split('-');
  if (parts.length == 3) {
    try {
      int year, month, day;
      if (parts[0].length == 4) {
        year = int.parse(parts[0]);
        month = int.parse(parts[1]);
        day = int.parse(parts[2]);
      } else {
        day = int.parse(parts[0]);
        month = int.parse(parts[1]);
        year = int.parse(parts[2]);
      }
      return DateTime(year, month, day);
    } catch (_) {}
  }
  return null;
}

class CaseEvent {
  final DateTime date;
  final String time;
  final String title;
  final String type; // 'Hearing', 'Deadline', 'Consultation'
  final String? location;
  final String? attendees;
  final String? caseId; // Reference to linked case
  final String eventId; // Unique event identifier
  final String? clientName; // Client name
  final String? caseType; // Case type
  final String? counsel; // Assigned counsel

  CaseEvent({
    required this.date,
    required this.time,
    required this.title,
    required this.type,
    this.location,
    this.attendees,
    this.caseId,
    String? eventId,
    this.clientName,
    this.caseType,
    this.counsel,
  }) : eventId = eventId ?? 'EVENT-${DateTime.now().millisecondsSinceEpoch}';
}

class CaseCalendarScreen extends StatefulWidget {
  const CaseCalendarScreen({super.key});

  @override
  State<CaseCalendarScreen> createState() => _CaseCalendarScreenState();
}

class _CaseCalendarScreenState extends State<CaseCalendarScreen> {
  late DateTime _selectedMonth;
  late DateTime _selectedDay;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedCounsel = 'All Counsel';
  String _selectedVenue = 'All Venues';

  late List<CaseEvent> _allEvents;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
    _selectedDay = DateTime(now.year, now.month, now.day);
    _allEvents = [];
    _loadData();
  }

  String _formatHandlerName(dynamic raw, Map<String, String> staffMap) {
    if (raw == null) return 'Unassigned';
    
    List<String> items = [];
    if (raw is List) {
      items = raw.map((e) => e.toString()).toList();
    } else {
      String str = raw.toString().trim();
      if (str.isEmpty || str == 'Unassigned' || str == 'null') return 'Unassigned';
      
      if (str.startsWith('[') && str.endsWith(']')) {
        try {
          final decoded = jsonDecode(str);
          if (decoded is List) {
            items = decoded.map((e) => e.toString()).toList();
          } else {
            str = str.substring(1, str.length - 1).replaceAll('"', '').replaceAll("'", '');
            items = str.split(',').map((e) => e.trim()).toList();
          }
        } catch (_) {
          str = str.substring(1, str.length - 1).replaceAll('"', '').replaceAll("'", '');
          items = str.split(',').map((e) => e.trim()).toList();
        }
      } else {
        items = [str];
      }
    }

    List<String> formattedNames = [];
    for (var item in items) {
      String clean = item.trim().replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').replaceAll("'", '');
      if (clean.isEmpty) continue;
      
      final cleanLower = clean.toLowerCase();
      
      if (staffMap.containsKey(cleanLower)) {
        formattedNames.add(staffMap[cleanLower]!);
        continue;
      }
      
      if (cleanLower.contains('@')) {
        final prefix = cleanLower.split('@')[0];
        if (staffMap.containsKey(prefix)) {
          formattedNames.add(staffMap[prefix]!);
          continue;
        }
        final parts = prefix.split(RegExp(r'[._\-]'));
        clean = parts
            .where((p) => p.isNotEmpty)
            .map((p) => p[0].toUpperCase() + p.substring(1))
            .join(' ');
      } else {
        final parts = clean.split(RegExp(r'[._\-]'));
        clean = parts
            .where((p) => p.isNotEmpty)
            .map((p) => p[0].toUpperCase() + p.substring(1))
            .join(' ');
      }
      formattedNames.add(clean);
    }

    return DisplayNameHelper.overrideName(formattedNames.isNotEmpty ? formattedNames.join(', ') : 'Unassigned');
  }

  Future<void> _loadData() async {
    try {
      final cases = await CaseService.getCases();
      final clients = await ClientService().getAllClients();
      final meetings = await MeetingService.getMeetings();
      final tasks = await TaskService.getTasks();

      final Map<String, String> staffMap = {};
      try {
        final users = await UserService.getAllUsers();
        for (var u in users) {
          final email = (u['email'] ?? '').toString().toLowerCase().trim();
          final name = (u['name'] ?? u['username'] ?? '').toString().trim();
          final username = (u['username'] ?? '').toString().toLowerCase().trim();
          if (email.isNotEmpty && name.isNotEmpty) staffMap[email] = name;
          if (username.isNotEmpty && name.isNotEmpty) staffMap[username] = name;
        }
      } catch (e) {
        debugPrint("Error fetching users for calendar: $e");
      }

      final List<CaseEvent> events = [];

      // 1. Connect Case Upcoming Hearing Dates
      for (var c in cases) {
        final rawHearing = c['next_hearing_date'] ??
            c['next_hearing'] ??
            c['nextHearingDate'] ??
            c['hearingDate'] ??
            c['hearing_date'];

        final date = _parseHearingDate(rawHearing);
        if (date != null) {
          final caseTitle = c['case_title'] ?? c['title'] ?? c['case_number'] ?? 'Court Hearing';
          final clientName = c['client_name'] ?? c['clientName'] ?? '';
          final rawStaff = c['responsible_staff'] ?? c['assignee'] ?? c['assigned_staff'] ?? c['assigned_counsel'];
          final formattedStaff = _formatHandlerName(rawStaff, staffMap);
          events.add(CaseEvent(
            date: date,
            time: c['hearing_time']?.toString() ?? c['time']?.toString() ?? '10:30 AM',
            title: clientName.toString().isNotEmpty ? '$caseTitle ($clientName)' : caseTitle.toString(),
            type: 'Hearing',
            location: c['court_details']?.toString() ?? c['court']?.toString() ?? c['forum']?.toString() ?? 'Court',
            attendees: formattedStaff,
            caseId: c['id']?.toString() ?? c['case_id']?.toString(),
            clientName: clientName.toString().isNotEmpty ? clientName.toString() : null,
            caseType: (c['case_type'] ?? c['caseType'])?.toString(),
            counsel: formattedStaff,
          ));
        }
      }

      // 2. Connect Client Upcoming Hearing Dates
      for (var cl in clients) {
        final rawHearing = cl['nextHearingDate'] ?? cl['next_hearing_date'] ?? cl['next_hearing'];
        final date = _parseHearingDate(rawHearing);
        if (date != null) {
          final clientName = cl['name']?.toString() ?? 'Client';
          final alreadyAdded = events.any((e) =>
              e.date.year == date.year &&
              e.date.month == date.month &&
              e.date.day == date.day &&
              (e.clientName == clientName || e.title.contains(clientName)));

          if (!alreadyAdded) {
            final rawStaff = cl['assigned_staff'] ?? cl['counsel'] ?? cl['responsible_staff'];
            final formattedStaff = _formatHandlerName(rawStaff, staffMap);
            events.add(CaseEvent(
              date: date,
              time: cl['next_hearing_time']?.toString() ?? '10:30 AM',
              title: '$clientName — Hearing',
              type: 'Hearing',
              location: cl['court']?.toString() ?? cl['court_name']?.toString() ?? 'Court',
              attendees: formattedStaff,
              clientName: clientName,
              caseType: (cl['case_type'] ?? cl['type_of_work'])?.toString(),
              counsel: formattedStaff,
            ));
          }
        }
      }

      // 3. Connect Meetings to Calendar
      for (var m in meetings) {
        final date = _parseHearingDate(m['meeting_date']);
        if (date != null) {
          final formattedStaff = _formatHandlerName(m['participants'], staffMap);
          events.add(CaseEvent(
            date: date,
            time: m['meeting_time']?.toString() ?? '10:00 AM',
            title: m['title']?.toString() ?? 'Consultation',
            type: 'Consultation',
            location: m['type']?.toString() ?? 'Office',
            attendees: formattedStaff,
          ));
        }
      }

      // 4. Connect Task Deadlines to Calendar
      for (var t in tasks) {
        if (t.deadline != null) {
          final formattedStaff = _formatHandlerName(t.assignedTo, staffMap);
          events.add(CaseEvent(
            date: t.deadline!,
            time: '05:00 PM',
            title: 'Task Due: ${t.title}',
            type: 'Deadline',
            location: 'Office Task',
            attendees: formattedStaff,
          ));
        }
      }

      // Sort chronologically
      events.sort((a, b) {
        final dateCompare = a.date.compareTo(b.date);
        if (dateCompare != 0) return dateCompare;
        return a.time.compareTo(b.time);
      });

      if (mounted) {
        setState(() {
          _allEvents = events;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading reminder calendar data: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildGlassContainer({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(24),
        child: child,
      ),
    );
  }

  void _addEventToCalendar(CaseEvent newEvent) {
    setState(() {
      _allEvents.add(newEvent);
      // Sort events by date and time
      _allEvents.sort((a, b) {
        final dateCompare = a.date.compareTo(b.date);
        if (dateCompare != 0) return dateCompare;
        return a.time.compareTo(b.time);
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Event "${newEvent.title}" added to calendar'),
        backgroundColor: AppTheme.successGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openAddEventDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AddCaseEventDialog(
        existingEvents: _allEvents,
        onEventAdded: _addEventToCalendar,
      ),
    );
  }


  int _getDaysInMonth(DateTime month) {
    return DateTime(month.year, month.month + 1, 0).day;
  }

  int _getFirstWeekdayOffset(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    return firstDay.weekday % 7;
  }

  void _prevMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  Color _getEventColor(String type) {
    switch (type) {
      case 'Hearing':
        return AppTheme.accentColor;
      case 'Deadline':
        return AppTheme.errorRed;
      case 'Consultation':
      default:
        return AppTheme.successGreen;
    }
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'Hearing':
        return Icons.gavel_rounded;
      case 'Deadline':
        return Icons.alarm_rounded;
      case 'Consultation':
      default:
        return Icons.people_alt_rounded;
    }
  }

  List<CaseEvent> _getFilteredEvents() {
    return _allEvents.where((e) {
      final matchesCategory = _selectedCategory == 'All' || e.type == _selectedCategory;
      
      final matchesSearch = _searchQuery.isEmpty ||
          e.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (e.location != null && e.location!.toLowerCase().contains(_searchQuery.toLowerCase())) ||
          (e.attendees != null && e.attendees!.toLowerCase().contains(_searchQuery.toLowerCase()));

      final matchesCounsel = _selectedCounsel == 'All Counsel' ||
          (e.attendees != null && e.attendees!.toLowerCase().contains(_selectedCounsel.toLowerCase()));

      bool matchesVenue = true;
      if (_selectedVenue != 'All Venues') {
        final loc = e.location?.toLowerCase() ?? '';
        if (_selectedVenue == 'Cochin HQ') {
          matchesVenue = loc.contains('cochin hq');
        } else if (_selectedVenue == 'High Court') {
          matchesVenue = loc.contains('high court');
        } else if (_selectedVenue == 'District Court') {
          matchesVenue = loc.contains('district court');
        } else if (_selectedVenue == 'IT Tribunal') {
          matchesVenue = loc.contains('income tax') || loc.contains('tribunal');
        }
      }

      return matchesCategory && matchesSearch && matchesCounsel && matchesVenue;
    }).toList();
  }

  CaseEvent? _findNextEvent() {
    final query = _searchQuery.trim().toLowerCase();
    
    // Sort all events chronologically
    final sortedEvents = List<CaseEvent>.from(_allEvents)
      ..sort((a, b) {
        final dateCompare = a.date.compareTo(b.date);
        if (dateCompare != 0) return dateCompare;
        return a.time.compareTo(b.time);
      });

    // Find the next upcoming event from _selectedDay or today onwards
    final upcomingEvents = sortedEvents.where((e) {
      final isSameOrAfter = e.date.isAfter(_selectedDay) || 
          (e.date.year == _selectedDay.year && e.date.month == _selectedDay.month && e.date.day == _selectedDay.day);
      
      if (!isSameOrAfter) return false;

      final matchesCategory = _selectedCategory == 'All' || e.type == _selectedCategory;
      if (!matchesCategory) return false;

      final matchesCounsel = _selectedCounsel == 'All Counsel' ||
          (e.attendees != null && e.attendees!.toLowerCase().contains(_selectedCounsel.toLowerCase()));

      bool matchesVenue = true;
      if (_selectedVenue != 'All Venues') {
        final loc = e.location?.toLowerCase() ?? '';
        if (_selectedVenue == 'Cochin HQ') {
          matchesVenue = loc.contains('cochin hq');
        } else if (_selectedVenue == 'High Court') {
          matchesVenue = loc.contains('high court');
        } else if (_selectedVenue == 'District Court') {
          matchesVenue = loc.contains('district court');
        } else if (_selectedVenue == 'IT Tribunal') {
          matchesVenue = loc.contains('income tax') || loc.contains('tribunal');
        }
      }
      if (!matchesVenue || !matchesCounsel) return false;

      if (query.isNotEmpty) {
        final titleMatch = e.title.toLowerCase().contains(query);
        final locationMatch = e.location?.toLowerCase().contains(query) ?? false;
        final attendeesMatch = e.attendees?.toLowerCase().contains(query) ?? false;
        final typeMatch = e.type.toLowerCase().contains(query);
        return titleMatch || locationMatch || attendeesMatch || typeMatch;
      }
      return true;
    }).toList();

    if (upcomingEvents.isEmpty) return null;
    
    // Prioritize Hearings
    final nextHearing = upcomingEvents.firstWhere(
      (e) => e.type == 'Hearing',
      orElse: () => upcomingEvents.first,
    );

    return nextHearing;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF0F172A)),
        ),
      );
    }

    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 950;

    final daysCount = _getDaysInMonth(_selectedMonth);
    final offset = _getFirstWeekdayOffset(_selectedMonth);
    final totalGridItems = daysCount + offset;

    final filteredEvents = _getFilteredEvents();

    final eventsForSelectedDay = filteredEvents.where((e) {
      return e.date.year == _selectedDay.year &&
          e.date.month == _selectedDay.month &&
          e.date.day == _selectedDay.day;
    }).toList();

    final nextEvent = _findNextEvent();
    final List<String> weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

    Widget categoryFilterRow = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ['All', 'Hearing', 'Deadline', 'Consultation'].map((cat) {
        final isSelected = _selectedCategory == cat;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = cat;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFFE2E8F0),
                  width: isSelected ? 1.2 : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.15),
                          blurRadius: 8,
                        )
                      ]
                    : null,
              ),
              child: Text(
                cat == 'All' ? 'ALL EVENTS' : cat.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  letterSpacing: 0.8,
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );

    Widget calendarGrid = LayoutBuilder(
      builder: (context, constraints) {
        final double gridMaxHeight = constraints.maxHeight;
        final double gridMaxWidth = constraints.maxWidth;

        // Calculate aspect ratio dynamically to fit available height
        // Header height estimation:
        // Month header row: ~36px
        // Weekdays GridView: childAspectRatio is 2.5, width is gridMaxWidth.
        // Weekdays height = (gridMaxWidth / 7) / 2.5 = gridMaxWidth / 17.5.
        // Sized boxes: 20 + 10 = 30px
        final weekdaysHeight = (gridMaxWidth / 17.5);
        final nonGridHeight = 36.0 + weekdaysHeight + 30.0 + 16.0; // 16px safety margin
        
        final availableHeight = gridMaxHeight - nonGridHeight;
        final rowsCount = (totalGridItems / 7).ceil();
        
        final cellWidth = (gridMaxWidth - 48) / 7;
        final verticalGaps = (rowsCount - 1) * 8;
        final cellHeight = ((availableHeight - verticalGaps) / rowsCount) - 2.0;
        
        double dynamicAspectRatio = 1.05;
        if (isDesktop && gridMaxHeight.isFinite && cellHeight > 0 && cellWidth > 0) {
          dynamicAspectRatio = cellWidth / cellHeight;
        }

        // Cap to keep look-and-feel within premium range
        if (dynamicAspectRatio < 0.6) dynamicAspectRatio = 0.6;
        if (dynamicAspectRatio > 2.5) dynamicAspectRatio = 2.5;

        Widget buildGridCell(int index) {
          if (index < offset) {
            return const SizedBox.shrink();
          }

          final dayNum = index - offset + 1;
          final currentDay = DateTime(_selectedMonth.year, _selectedMonth.month, dayNum);
          final isSelected = currentDay.year == _selectedDay.year &&
              currentDay.month == _selectedDay.month &&
              currentDay.day == _selectedDay.day;

          final dayEvents = filteredEvents.where((e) {
            return e.date.year == currentDay.year &&
                e.date.month == currentDay.month &&
                e.date.day == currentDay.day;
          }).toList();

          final isToday = currentDay.year == 2026 &&
              currentDay.month == 6 &&
              currentDay.day == 3;

          final hasHearing = dayEvents.any((e) => e.type == 'Hearing');
          final hasDeadline = dayEvents.any((e) => e.type == 'Deadline');

          Color badgeBgColor;
          Color badgeTextColor;
          Border? badgeBorder;

          if (isSelected) {
            badgeBgColor = const Color(0xFFD4AF37);
            badgeTextColor = const Color(0xFF0F172A);
            badgeBorder = Border.all(color: const Color(0xFFD4AF37), width: 1);
          } else {
            if (hasHearing) {
              badgeBgColor = const Color(0xFFD4AF37).withValues(alpha: 0.2);
              badgeTextColor = const Color(0xFF0F172A);
              badgeBorder = Border.all(color: const Color(0xFFD4AF37), width: 1);
            } else if (hasDeadline) {
              badgeBgColor = const Color(0xFFFEE2E2);
              badgeTextColor = const Color(0xFF991B1B);
              badgeBorder = Border.all(color: const Color(0xFFEF4444), width: 1);
            } else {
              badgeBgColor = const Color(0xFFDCFCE7);
              badgeTextColor = const Color(0xFF166534);
              badgeBorder = Border.all(color: const Color(0xFF22C55E), width: 1);
            }
          }

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = currentDay;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF0F172A)
                    : (hasHearing
                        ? const Color(0xFFFFFBEB)
                        : (hasDeadline
                            ? const Color(0xFFFEF2F2)
                            : (dayEvents.isNotEmpty
                                ? const Color(0xFFF0FDF4)
                                : Colors.white))),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFD4AF37)
                      : (hasHearing
                          ? const Color(0xFFD4AF37)
                          : (hasDeadline
                              ? const Color(0xFFEF4444)
                              : (isToday
                                  ? const Color(0xFF0F172A)
                                  : const Color(0xFFE2E8F0)))),
                  width: isSelected || hasHearing || hasDeadline || isToday ? 1.5 : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.25),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
              child: dynamicAspectRatio > 1.3
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dayNum',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : (hasHearing
                                    ? const Color(0xFF0F172A)
                                    : (hasDeadline
                                        ? const Color(0xFF991B1B)
                                        : const Color(0xFF0F172A))),
                          ),
                        ),
                        if (dayEvents.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: badgeBgColor,
                              border: badgeBorder,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${dayEvents.length} ${dayEvents.length == 1 ? 'Case' : 'Cases'}',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 7.5,
                                fontWeight: FontWeight.bold,
                                color: badgeTextColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dayNum',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : (hasHearing
                                    ? const Color(0xFF0F172A)
                                    : (hasDeadline
                                        ? const Color(0xFF991B1B)
                                        : const Color(0xFF0F172A))),
                          ),
                        ),
                        if (dayEvents.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: badgeBgColor,
                              border: badgeBorder,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${dayEvents.length} ${dayEvents.length == 1 ? 'Case' : 'Cases'}',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 7.5,
                                fontWeight: FontWeight.bold,
                                color: badgeTextColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          );
        }

        final gridWidget = ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: dynamicAspectRatio,
            ),
            itemCount: totalGridItems,
            itemBuilder: (context, index) => buildGridCell(index),
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Month navigation header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_getMonthName(_selectedMonth.month)} ${_selectedMonth.year}',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded, color: AppTheme.accentColor),
                      onPressed: _prevMonth,
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        hoverColor: AppTheme.accentColor.withValues(alpha: 0.1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded, color: AppTheme.accentColor),
                      onPressed: _nextMonth,
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        hoverColor: AppTheme.accentColor.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Weekday labels header
            GridView.count(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.5,
              children: weekdays.map((day) {
                return Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: AppTheme.accentColor,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Divider(color: AppTheme.accentColor.withValues(alpha: 0.1), height: 1),
            const SizedBox(height: 16),
            // Month days grid
            isDesktop ? Expanded(child: gridWidget) : gridWidget,
          ],
        );
      },
    );

    Widget calendarCard = _buildGlassContainer(
      padding: const EdgeInsets.all(24),
      child: calendarGrid,
    );

    Widget searchField = Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.textSecondary.withValues(alpha: 0.15)),
      ),
      child: TextField(
        style: const TextStyle(
          fontFamily: 'Montserrat',
          color: AppTheme.textPrimary,
          fontSize: 12,
        ),
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded, size: 16, color: AppTheme.accentColor),
          suffixIcon: _searchQuery.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  child: const Icon(Icons.clear_rounded, size: 16, color: AppTheme.textSecondary),
                )
              : null,
          hintText: 'Search cases, counsel, venue...',
          hintStyle: TextStyle(
            fontFamily: 'Montserrat',
            color: AppTheme.textSecondary.withValues(alpha: 0.4),
            fontSize: 11,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          fillColor: Colors.transparent,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );

    Widget nextEventBanner = nextEvent != null
        ? Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    width: 4,
                    decoration: const BoxDecoration(
                      color: AppTheme.accentColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.upcoming_rounded,
                                    color: AppTheme.accentColor,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _searchQuery.isNotEmpty
                                        ? 'NEXT MATCHING HEARING'
                                        : 'NEXT UPCOMING HEARING',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.1,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: _getEventColor(nextEvent.type).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  nextEvent.type.toUpperCase(),
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                    color: _getEventColor(nextEvent.type),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            nextEvent.title,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded, color: AppTheme.textSecondary, size: 12),
                              const SizedBox(width: 6),
                              Text(
                                '${_getMonthName(nextEvent.date.month).substring(0, 3)} ${nextEvent.date.day}, ${nextEvent.date.year} at ${nextEvent.time}',
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          if (nextEvent.location != null && nextEvent.location!.trim().isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, color: AppTheme.textSecondary, size: 12),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    nextEvent.location!,
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 10.5,
                                      color: AppTheme.textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (nextEvent.attendees != null && nextEvent.attendees!.trim().isNotEmpty && nextEvent.attendees != 'Unassigned') ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.person_outline_rounded, color: AppTheme.textSecondary, size: 12),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    nextEvent.attendees!,
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.textSecondary.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.search_off_rounded, color: AppTheme.textSecondary.withValues(alpha: 0.4), size: 16),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'No upcoming hearings found matching query.',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          );

    Widget filtersPanel = _buildGlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isDesktop)
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: searchField,
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildDropdown(
                    value: _selectedCounsel,
                    items: ['All Counsel', 'Rajesh Pillai', 'Hari Prasad', 'Anjali Menon'],
                    icon: Icons.person_search_rounded,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedCounsel = val;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildDropdown(
                    value: _selectedVenue,
                    items: ['All Venues', 'Cochin HQ', 'High Court', 'District Court', 'IT Tribunal'],
                    icon: Icons.pin_drop_rounded,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedVenue = val;
                        });
                      }
                    },
                  ),
                ),
              ],
            )
          else ...[
            searchField,
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    value: _selectedCounsel,
                    items: ['All Counsel', 'Rajesh Pillai', 'Hari Prasad', 'Anjali Menon'],
                    icon: Icons.person_search_rounded,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedCounsel = val;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    value: _selectedVenue,
                    items: ['All Venues', 'Cochin HQ', 'High Court', 'District Court', 'IT Tribunal'],
                    icon: Icons.pin_drop_rounded,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedVenue = val;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          categoryFilterRow,
        ],
      ),
    );

    Widget detailsPanel = _buildGlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          nextEventBanner,
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.event_note_rounded, color: AppTheme.accentColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Schedule: ${_getMonthName(_selectedDay.month).substring(0, 3)} ${_selectedDay.day}, ${_selectedDay.year}',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          isDesktop
              ? Expanded(
                  child: SingleChildScrollView(
                    child: eventsForSelectedDay.isEmpty
                        ? _buildEmptyEventsState()
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(eventsForSelectedDay.length, (index) {
                              final event = eventsForSelectedDay[index];
                              final isLast = index == eventsForSelectedDay.length - 1;
                              return _buildEventItem(context, event, isLast);
                            }),
                          ),
                  ),
                )
              : eventsForSelectedDay.isEmpty
                  ? _buildEmptyEventsState()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(eventsForSelectedDay.length, (index) {
                        final event = eventsForSelectedDay[index];
                        final isLast = index == eventsForSelectedDay.length - 1;
                        return _buildEventItem(context, event, isLast);
                      }),
                    ),
        ],
      ),
    );

    return ResponsiveScaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              filtersPanel,
              const SizedBox(height: 20),
              Expanded(
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Flexible(
                            flex: 6,
                            child: calendarCard,
                          ),
                          const SizedBox(width: 24),
                          Flexible(
                            flex: 5,
                            child: detailsPanel,
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            calendarCard,
                            const SizedBox(height: 20),
                            detailsPanel,
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _openAddEventDialog,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.4), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, color: Color(0xFFD4AF37), size: 20),
                SizedBox(width: 8),
                Text(
                  'ADD EVENT',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    const weekdayLabels = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 18),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Chamber Calendar',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'View hearings, court deadlines and consultations at a glance.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.4), width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.15),
                  blurRadius: 10,
                )
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_rounded, color: Color(0xFFD4AF37), size: 18),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'SELECTED DATE',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                    Text(
                      '${weekdayLabels[_selectedDay.weekday % 7]}, ${_selectedDay.day} ${_getMonthName(_selectedDay.month).substring(0, 3)}',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyEventsState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            color: AppTheme.textSecondary.withValues(alpha: 0.3),
            size: 40,
          ),
          const SizedBox(height: 12),
          const Text(
            'No events scheduled',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'for this date.',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(BuildContext context, CaseEvent event, bool isLast) {
    final typeColor = _getEventColor(event.type);

    List<String> initialsList = [];
    if (event.attendees != null) {
      final names = event.attendees!.split(',');
      for (var name in names) {
        final cleanName = name.trim().replaceFirst('Adv.', '').trim();
        if (cleanName.isNotEmpty) {
          final parts = cleanName.split(' ');
          if (parts.length >= 2) {
            initialsList.add((parts[0][0] + parts[1][0]).toUpperCase());
          } else if (parts[0].isNotEmpty) {
            initialsList.add(parts[0][0].toUpperCase());
          }
        }
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        splashColor: AppTheme.accentColor.withValues(alpha: 0.15),
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => EventDetailScreen(
                title: event.title,
                type: event.type,
                time: event.time,
                date: event.date,
                location: event.location,
                attendees: event.attendees,
                eventId: event.eventId,
                caseId: event.caseId,
                clientName: event.clientName,
                caseType: event.caseType,
                counsel: event.counsel,
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                  ),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 350),
            ),
          );
        },
        child: Stack(
          children: [
            if (!isLast)
              Positioned(
                left: 5,
                top: 12,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: typeColor.withValues(alpha: 0.2),
                ),
              ),
            Positioned(
              left: 0,
              top: 4,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: typeColor,
                  border: Border.all(color: AppTheme.backgroundColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: typeColor.withValues(alpha: 0.4),
                      blurRadius: 4,
                      spreadRadius: 1,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 26, bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.08), width: 1),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_getEventIcon(event.type), color: typeColor, size: 10),
                              const SizedBox(width: 4),
                              Text(
                                event.type.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                  color: typeColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          event.time,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    if (event.location != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: AppTheme.textSecondary, size: 12),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location!,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 9.5,
                                color: AppTheme.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (event.attendees != null && initialsList.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Divider(color: Colors.white10, height: 1),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          SizedBox(
                            width: 20.0 + (initialsList.length - 1) * 14.0,
                            height: 20,
                            child: Stack(
                              children: List.generate(initialsList.length, (idx) {
                                return Positioned(
                                  left: idx * 14.0,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.secondaryColor,
                                      border: Border.all(color: AppTheme.backgroundColor, width: 1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        initialsList[idx],
                                        style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 7.5,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.accentColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              event.attendees!,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 9,
                                color: AppTheme.textSecondary.withValues(alpha: 0.8),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            ],
          ),
        ),
      );
    }

    String _getMonthName(int month) {
    const months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER'
    ];
    return months[month - 1];
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: const Icon(Icons.arrow_drop_down_rounded, color: Color(0xFF0F172A), size: 20),
          style: const TextStyle(
            fontFamily: 'Montserrat',
            color: Color(0xFF0F172A),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(icon, color: const Color(0xFF0F172A), size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFF0F172A),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
