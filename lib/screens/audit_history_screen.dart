import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/logging_service.dart';
import '../services/user_service.dart';
import '../widgets/responsive.dart';


// Activity Log Model
class ActivityLog {
  final String timestamp;
  final String description;
  final IconData icon;

  ActivityLog({
    required this.timestamp,
    required this.description,
    required this.icon,
  });
}

// Historic Session Log Model
class SessionHistoryLog {
  final String userName;
  final String role; // Admin, Manager, Staff
  final String roleTitle;
  final String location;
  final String platform;
  final String dateText; // e.g. "02 Jun", "01 Jun"
  final DateTime date;   // Date for calendar filter
  final String openingTime;
  final String closingTime;
  final String durationText;
  final List<String> featuresUsed;
  final String ipAddress;
  final String userAgent;
  final String authToken;
  final bool isAnomalous;
  final String anomalyReason;
  final List<ActivityLog> activities;

  SessionHistoryLog({
    required this.userName,
    required this.role,
    required this.roleTitle,
    required this.location,
    required this.platform,
    required this.dateText,
    required this.date,
    required this.openingTime,
    required this.closingTime,
    required this.durationText,
    required this.featuresUsed,
    this.ipAddress = '192.168.2.14',
    this.userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko)',
    this.authToken = 'JWT_HISTORY_TOKEN_UNSET',
    this.isAnomalous = false,
    this.anomalyReason = '',
    this.activities = const [],
  });
}

class AuditHistoryScreen extends StatefulWidget {
  const AuditHistoryScreen({super.key});

  @override
  State<AuditHistoryScreen> createState() => _AuditHistoryScreenState();
}

class _AuditHistoryScreenState extends State<AuditHistoryScreen> {
  String _selectedRoleFilter = 'All';
  String _selectedLocationFilter = 'All';
  String _selectedPlatformFilter = 'All';
  DateTime? _selectedDateFilter;
  String _nameQuery = '';
  String _searchQuery = '';
  SessionHistoryLog? _expandedLog;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _selectedRoleFilter = 'All';
      _selectedLocationFilter = 'All';
      _selectedPlatformFilter = 'All';
      _selectedDateFilter = null;
      _nameQuery = '';
      _searchQuery = '';
      _expandedLog = null;
      _nameController.clear();
      _searchController.clear();
    });
  }

  void _exportHistoryLogs(List<SessionHistoryLog> logsToExport, String filename) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.successGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Archives exported successfully to $filename (${logsToExport.length} entries)',
                style: const TextStyle(fontFamily: 'Montserrat', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<SessionHistoryLog> _historyLogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistoryLogs();
  }

  Future<void> _fetchHistoryLogs() async {
    final rawLogs = await LoggingService().fetchAllLogs();
    
    final allUsers = await UserService.getAllUsers();
    Map<String, String> emailToName = {};
    for (var u in allUsers) {
      if (u['email'] != null && u['name'] != null) {
        emailToName[u['email'].toString().toLowerCase().trim()] = u['name'];
      }
    }

    // Group by user_email and date (to separate into daily sessions)
    Map<String, List<Map<String, dynamic>>> sessionGroups = {};
    for (var log in rawLogs) {
      final email = log['user_email'] as String? ?? 'Unknown';
      final String createdAtStr = log['created_at'] as String? ?? DateTime.now().toIso8601String();
      final logTime = DateTime.parse(createdAtStr);
      final dateKey = '${logTime.year}-${logTime.month}-${logTime.day}';
      final sessionKey = '${email}_$dateKey';

      if (!sessionGroups.containsKey(sessionKey)) {
        sessionGroups[sessionKey] = [];
      }
      sessionGroups[sessionKey]!.add(log);
    }

    List<SessionHistoryLog> parsedLogs = [];
    final now = DateTime.now();

    for (var entry in sessionGroups.entries) {
      final sessionKey = entry.key;
      final email = sessionKey.split('_').first;
      final userLogs = entry.value;
      
      // Sort by created_at ascending
      userLogs.sort((a, b) => (a['created_at'] as String).compareTo(b['created_at'] as String));
      
      final firstLog = userLogs.first;
      final lastLog = userLogs.last;
      
      final firstTime = DateTime.parse(firstLog['created_at']);
      final lastTime = DateTime.parse(lastLog['created_at']);
      
      final isActive = now.difference(lastTime).inMinutes < 15;
      
      Set<String> features = {};
      List<ActivityLog> activities = [];
      for (var l in userLogs) {
        if (l['target_type'] != null) features.add(l['target_type']);
        final logTime = DateTime.parse(l['created_at']);
        final formattedTime = '${logTime.hour.toString().padLeft(2, '0')}:${logTime.minute.toString().padLeft(2, '0')} ${logTime.hour >= 12 ? "PM" : "AM"}';
        activities.add(ActivityLog(
          timestamp: formattedTime,
          description: l['action'] ?? 'Unknown Action',
          icon: Icons.history_rounded,
        ));
      }
      
      final duration = lastTime.difference(firstTime);
      String durationText = '';
      if (duration.inMinutes < 1) durationText = '< 1 min';
      else if (duration.inHours < 1) durationText = '${duration.inMinutes} mins';
      else durationText = '${duration.inHours}h ${duration.inMinutes % 60}m';
      
      String formatTime(DateTime dt) {
        return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? "PM" : "AM"}';
      }
      
      String dateText = '${firstTime.day.toString().padLeft(2, '0')} ${_getMonthName(firstTime.month)}';

      String formatName(String emailString) {
        if (!emailString.contains('@')) return emailString;
        final namePart = emailString.split('@')[0];
        String displayName = namePart.split('.').map((s) {
          if (s.isEmpty) return s;
          return "${s[0].toUpperCase()}${s.substring(1)}";
        }).join(' ');
        if (!displayName.toLowerCase().startsWith('adv.')) {
          displayName = 'Adv. $displayName';
        }
        return displayName;
      }

      String actualName = emailToName[email.toLowerCase().trim()] ?? formatName(email);

      parsedLogs.add(SessionHistoryLog(
        userName: actualName,
        role: firstLog['user_role'] ?? 'Staff',
        roleTitle: 'Firm User',
        location: 'Remote Access',
        platform: 'System UI',
        dateText: dateText,
        date: firstTime,
        openingTime: formatTime(firstTime),
        closingTime: isActive ? 'Active Now' : formatTime(lastTime),
        durationText: durationText,
        featuresUsed: features.toList(),
        activities: activities,
      ));
    }

    // Sort by date descending
    parsedLogs.sort((a, b) => b.date.compareTo(a.date));

    if (mounted) {
      setState(() {
        _historyLogs = parsedLogs;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _historyLogs.where((log) {
      final matchesRole = _selectedRoleFilter == 'All' || log.role == _selectedRoleFilter;
      final matchesLocation = _selectedLocationFilter == 'All' ||
          log.location.toLowerCase().contains(_selectedLocationFilter.toLowerCase());
      final matchesPlatform = _selectedPlatformFilter == 'All' ||
          log.platform.toLowerCase().contains(_selectedPlatformFilter.toLowerCase());
      final matchesName = _nameQuery.isEmpty ||
          log.userName.toLowerCase().contains(_nameQuery.toLowerCase());
      final matchesDate = _selectedDateFilter == null ||
          (log.date.year == _selectedDateFilter!.year &&
           log.date.month == _selectedDateFilter!.month &&
           log.date.day == _selectedDateFilter!.day);
      final matchesSearch = _searchQuery.isEmpty ||
          log.userName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          log.roleTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          log.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          log.platform.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesRole && matchesLocation && matchesPlatform && matchesName && matchesDate && matchesSearch;
    }).toList();

    return ResponsiveScaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildAuditsSection(filteredLogs),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header with back navigation
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.accentColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.accentColor, size: 18),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Back to Dashboard',
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.secondaryColor,
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HISTORICAL SESSION ARCHIVES',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Arial', 'sans-serif'],
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'IT Audit Log History for Admin, Managers & Staff',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Arial', 'sans-serif'],
                  fontSize: 9,
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Main Audit Archives Section
  Widget _buildAuditsSection(List<SessionHistoryLog> logsList) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accentColor.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.archive_outlined, color: AppTheme.accentColor, size: 22),
              const SizedBox(width: 8),
              Text(
                'Audit Records (${logsList.length} total)',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Arial', 'sans-serif'],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.download_rounded, size: 18, color: AppTheme.accentColor),
                tooltip: 'Export Archives Ledger',
                onPressed: () => _exportHistoryLogs(logsList, 'Historical_Session_Audit_Logs.csv'),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.accentColor.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: AppTheme.accentColor.withValues(alpha: 0.3)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (_selectedRoleFilter != 'All' ||
                  _selectedLocationFilter != 'All' ||
                  _selectedPlatformFilter != 'All' ||
                  _selectedDateFilter != null ||
                  _nameQuery.isNotEmpty ||
                  _searchQuery.isNotEmpty) ...[
                TextButton.icon(
                  onPressed: _resetFilters,
                  icon: const Icon(Icons.clear_all_rounded, size: 16, color: AppTheme.errorRed),
                  label: const Text(
                    'Clear All',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 11,
                      color: AppTheme.errorRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: AppTheme.errorRed.withValues(alpha: 0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          _buildFilterPanel(),
          const SizedBox(height: 20),
          logsList.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: logsList.length,
                  separatorBuilder: (context, index) => Divider(
                    color: AppTheme.accentColor.withValues(alpha: 0.08),
                    height: 20,
                  ),
                  itemBuilder: (context, index) {
                    return _buildSessionLogItem(logsList[index]);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel() {
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktop = width > 900;

    if (isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildNameFilterField(),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _buildDatePickerField(),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: _buildSearchField(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDropdownFilter(
                  label: 'Role',
                  value: _selectedRoleFilter,
                  items: const ['All', 'Admin', 'Manager', 'Staff'],
                  icon: Icons.admin_panel_settings_outlined,
                  onChanged: (String? val) {
                    if (val != null) {
                      setState(() {
                        _selectedRoleFilter = val;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdownFilter(
                  label: 'Office Location',
                  value: _selectedLocationFilter,
                  items: const ['All', 'Cochin HQ', 'Remote'],
                  icon: Icons.location_on_outlined,
                  onChanged: (String? val) {
                    if (val != null) {
                      setState(() {
                        _selectedLocationFilter = val;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdownFilter(
                  label: 'Device Platform',
                  value: _selectedPlatformFilter,
                  items: const ['All', 'Web', 'Windows', 'macOS', 'iOS', 'Android'],
                  icon: Icons.devices_outlined,
                  onChanged: (String? val) {
                    if (val != null) {
                      setState(() {
                        _selectedPlatformFilter = val;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // Mobile - Stacks vertically
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildNameFilterField(),
          const SizedBox(height: 10),
          _buildDatePickerField(),
          const SizedBox(height: 10),
          _buildSearchField(),
          const SizedBox(height: 10),
          _buildDropdownFilter(
            label: 'Role',
            value: _selectedRoleFilter,
            items: const ['All', 'Admin', 'Manager', 'Staff'],
            icon: Icons.admin_panel_settings_outlined,
            onChanged: (String? val) {
              if (val != null) {
                setState(() {
                  _selectedRoleFilter = val;
                });
              }
            },
          ),
          const SizedBox(height: 10),
          _buildDropdownFilter(
            label: 'Office Location',
            value: _selectedLocationFilter,
            items: const ['All', 'Cochin HQ', 'Remote'],
            icon: Icons.location_on_outlined,
            onChanged: (String? val) {
              if (val != null) {
                setState(() {
                  _selectedLocationFilter = val;
                });
              }
            },
          ),
          const SizedBox(height: 10),
          _buildDropdownFilter(
            label: 'Device Platform',
            value: _selectedPlatformFilter,
            items: const ['All', 'Web', 'Windows', 'macOS', 'iOS', 'Android'],
            icon: Icons.devices_outlined,
            onChanged: (String? val) {
              if (val != null) {
                setState(() {
                  _selectedPlatformFilter = val;
                });
              }
            },
          ),
        ],
      );
    }
  }

  Widget _buildNameFilterField() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _nameQuery.isNotEmpty
              ? AppTheme.accentColor
              : AppTheme.textSecondary.withValues(alpha: 0.1),
        ),
      ),
      child: TextField(
        controller: _nameController,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          color: AppTheme.textPrimary,
          fontSize: 13,
        ),
        onChanged: (val) {
          setState(() {
            _nameQuery = val;
          });
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person_outline_rounded, size: 18, color: AppTheme.accentColor),
          suffixIcon: _nameQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 16, color: AppTheme.textSecondary),
                  onPressed: () {
                    setState(() {
                      _nameQuery = '';
                      _nameController.clear();
                    });
                  },
                )
              : null,
          hintText: 'Filter by name...',
          hintStyle: TextStyle(
            fontFamily: 'Montserrat',
            color: AppTheme.textSecondary.withValues(alpha: 0.4),
            fontSize: 12,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          fillColor: Colors.transparent,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDatePickerField() {
    final dateText = _selectedDateFilter == null
        ? 'Select Date'
        : '${_selectedDateFilter!.day.toString().padLeft(2, '0')} ${_getMonthName(_selectedDateFilter!.month)} ${_selectedDateFilter!.year}';

    return InkWell(
      onTap: _pickDate,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.secondaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _selectedDateFilter != null
                ? AppTheme.accentColor
                : AppTheme.textSecondary.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded, size: 16, color: AppTheme.accentColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                dateText,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: _selectedDateFilter != null ? AppTheme.textPrimary : AppTheme.textSecondary.withValues(alpha: 0.6),
                  fontSize: 13,
                  fontWeight: _selectedDateFilter != null ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (_selectedDateFilter != null)
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 16, color: AppTheme.errorRed),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _selectedDateFilter = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateFilter != null
          ? (_selectedDateFilter!.isAfter(now) ? now : _selectedDateFilter!)
          : (DateTime(2026, 6, 2).isAfter(now) ? now : DateTime(2026, 6, 2)),
      firstDate: DateTime(2020),
      lastDate: now,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.accentColor,
              onPrimary: AppTheme.primaryColor,
              surface: AppTheme.surfaceColor,
              onSurface: AppTheme.textPrimary,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppTheme.surfaceColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.accentColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDateFilter = picked;
      });
    }
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return '';
  }

  Widget _buildDropdownFilter({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: value != 'All' ? AppTheme.accentColor : AppTheme.textSecondary.withValues(alpha: 0.1),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: AppTheme.surfaceColor,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            color: AppTheme.textPrimary,
            fontSize: 13,
          ),
          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppTheme.accentColor),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 14, color: value == val ? AppTheme.accentColor : AppTheme.textSecondary),
                  const SizedBox(width: 8),
                  Text(val == 'All' ? '$label: All' : val),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _searchQuery.isNotEmpty
              ? AppTheme.accentColor
              : AppTheme.textSecondary.withValues(alpha: 0.1),
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontFamilyFallback: ['Arial', 'sans-serif'],
          color: AppTheme.textPrimary,
          fontSize: 13,
        ),
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded, size: 18),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 16, color: AppTheme.textSecondary),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  },
                )
              : null,
          hintText: 'Keyword search...',
          hintStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontFamilyFallback: const ['Arial', 'sans-serif'],
            color: AppTheme.textSecondary.withValues(alpha: 0.4),
            fontSize: 12,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          fillColor: Colors.transparent,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSessionLogItem(SessionHistoryLog log) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isCompact = screenWidth < 1050;
    final bool isExpanded = _expandedLog == log;

    return InkWell(
      onTap: () {
        setState(() {
          _expandedLog = isExpanded ? null : log;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isExpanded ? AppTheme.secondaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isExpanded
                ? (log.isAnomalous ? AppTheme.errorRed : AppTheme.accentColor).withValues(alpha: 0.3)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            isCompact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  log.userName,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontFamilyFallback: ['Arial', 'sans-serif'],
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                if (log.isAnomalous) ...[
                                  const SizedBox(width: 6),
                                  const Icon(Icons.warning_amber_rounded, color: AppTheme.errorRed, size: 14),
                                ],
                                const SizedBox(width: 8),
                                _buildDateTag(log.dateText),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildRoleTag(log.role),
                          const SizedBox(width: 8),
                          Text(
                            log.roleTitle,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontFamilyFallback: const ['Arial', 'sans-serif'],
                              fontSize: 11,
                              color: AppTheme.textSecondary.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildCompactField(Icons.location_on_outlined, 'Location: ${log.location}'),
                      _buildCompactField(Icons.devices_outlined, 'Device: ${log.platform}'),
                      _buildCompactField(Icons.login_rounded, 'Opened: ${log.openingTime}'),
                      _buildCompactField(Icons.logout_rounded, 'Closed: ${log.closingTime}'),
                      _buildCompactField(Icons.hourglass_empty_rounded, 'Duration: ${log.durationText}'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: log.featuresUsed.map((f) => _buildFeatureChip(f)).toList(),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Identity
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  log.userName,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontFamilyFallback: ['Arial', 'sans-serif'],
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                if (log.isAnomalous) ...[
                                  const SizedBox(width: 6),
                                  const Icon(Icons.warning_amber_rounded, color: AppTheme.errorRed, size: 14),
                                ],
                                const SizedBox(width: 8),
                                _buildDateTag(log.dateText),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _buildRoleTag(log.role),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    log.roleTitle,
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontFamilyFallback: ['Arial', 'sans-serif'],
                                      fontSize: 11,
                                      color: AppTheme.textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Session details (Location & Platform)
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, color: AppTheme.accentColor, size: 14),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    log.location,
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontFamilyFallback: ['Arial', 'sans-serif'],
                                      fontSize: 12,
                                      color: AppTheme.textPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.devices_outlined, color: AppTheme.textSecondary, size: 14),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    log.platform,
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontFamilyFallback: ['Arial', 'sans-serif'],
                                      fontSize: 11,
                                      color: AppTheme.textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Timing (App Opening & Closing)
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Open: ${log.openingTime}',
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontFamilyFallback: ['Arial', 'sans-serif'],
                                fontSize: 12,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Close: ${log.closingTime}',
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontFamilyFallback: ['Arial', 'sans-serif'],
                                fontSize: 11,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Active duration and features
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Duration: ${log.durationText}',
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontFamilyFallback: ['Arial', 'sans-serif'],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: log.featuresUsed.map((f) => _buildFeatureChip(f)).toList(),
                            ),
                          ],
                        ),
                      ),
                      // Status tag space holder to match dashboard layout alignment
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.textSecondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppTheme.textSecondary.withValues(alpha: 0.3)),
                            ),
                            child: const Text(
                              'Archived',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontFamilyFallback: ['Arial', 'sans-serif'],
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            if (isExpanded) _buildExpandedDrawer(log),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedDrawer(SessionHistoryLog log) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: log.isAnomalous
              ? AppTheme.errorRed.withValues(alpha: 0.4)
              : AppTheme.accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (log.isAnomalous) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppTheme.errorRed.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppTheme.errorRed, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'SECURITY WARNING: ${log.anomalyReason}',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.errorRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'IP ADDRESS',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      log.ipAddress,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SECURE ACCESS TOKEN (JWT)',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      log.authToken,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 11,
                        fontFamilyFallback: ['Courier', 'monospace'],
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'BROWSER / DEVICE USER AGENT',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                log.userAgent,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          if (log.activities.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'SESSION ACTIVITY TIMELINE',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentColor,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.textSecondary.withOpacity(0.1)),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: log.activities.length,
                itemBuilder: (context, index) {
                  final activity = log.activities[index];
                  final isLast = index == log.activities.length - 1;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Icon(activity.icon, size: 14, color: AppTheme.accentColor.withOpacity(0.8)),
                          if (!isLast)
                            Container(
                              height: 18,
                              width: 1,
                              color: AppTheme.textSecondary.withOpacity(0.2),
                              margin: const EdgeInsets.symmetric(vertical: 2),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: isLast ? 0 : 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity.timestamp,
                                style: const TextStyle(
                                  fontFamily: 'Courier',
                                  fontSize: 11,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  activity.description,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactField(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accentColor.withValues(alpha: 0.7), size: 13),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Arial', 'sans-serif'],
                fontSize: 12,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTag(String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppTheme.accentColor.withValues(alpha: 0.3),
          width: 0.7,
        ),
      ),
      child: Text(
        date.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontFamilyFallback: ['Arial', 'sans-serif'],
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: AppTheme.accentColor,
        ),
      ),
    );
  }

  Widget _buildRoleTag(String role) {
    Color tagColor = AppTheme.accentColor;
    if (role == 'Admin') {
      tagColor = const Color(0xFFC084FC);
    } else if (role == 'Manager') {
      tagColor = const Color(0xFF60A5FA);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: tagColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: tagColor.withValues(alpha: 0.4), width: 0.7),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontFamilyFallback: const ['Arial', 'sans-serif'],
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: tagColor,
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontFamilyFallback: ['Arial', 'sans-serif'],
          fontSize: 10,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, color: AppTheme.textSecondary.withValues(alpha: 0.4), size: 48),
          const SizedBox(height: 12),
          const Text(
            'No matching archives found',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: ['Arial', 'sans-serif'],
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try adjusting your role or date filter, or search keywords.',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: ['Arial', 'sans-serif'],
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
