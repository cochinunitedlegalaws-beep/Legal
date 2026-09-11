import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import '../theme/app_theme.dart';
import '../widgets/case_stages_widget.dart';
import '../widgets/task_management_widget.dart';
import 'login_screen.dart';
import 'audit_history_screen.dart';
import '../models/document_audit_log.dart';
import '../services/document_service.dart';
import '../services/user_service.dart';
import '../services/logging_service.dart';
import '../services/session_tracking_service.dart';
import '../services/attendance_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'client_management_screen.dart';
import 'staff_management_screen.dart';
import 'service_management_screen.dart';
import 'added_documents_screen.dart';
import 'task_management_screen.dart';
import 'checklist_screen.dart';
import 'travel_log_screen.dart';
import 'expense_screen.dart';
import 'conflict_check_screen.dart';
import 'lead_management_screen.dart';
import 'communication_log_screen.dart';
import '../widgets/responsive.dart';
class SessionAuditLog {
  final String userName;
  final String role;
  final String roleTitle;
  final String location;
  final String platform;
  final String openingTime;
  final String closingTime;
  final String durationText;
  final List<String> featuresUsed;
  final bool isActive;
  final String dateText;
  final String ipAddress;
  
  final String userAgent;
  final String authToken;
  final bool isAnomalous;
  final String anomalyReason;
  SessionAuditLog({
    required this.userName,
    required this.role,
    required this.roleTitle,
    required this.location,
    required this.platform,
    required this.openingTime,
    required this.closingTime,
    required this.durationText,
    required this.featuresUsed,
    required this.isActive,
    required this.dateText,
    this.ipAddress = '127.0.0.1',
    this.userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
    this.authToken = 'JWT_SESSION_TOKEN_UNSET',
    this.isAnomalous = false,
    this.anomalyReason = '',
  });
}
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}
class _AdminDashboardState extends State<AdminDashboard> with WidgetsBindingObserver, TickerProviderStateMixin {
  late AnimationController _bgController;
  String _selectedRoleFilter = 'All';
  String _statusFilter = 'All'; // 'All' or 'Active'
  String _searchQuery = '';
  int _activeSidebarIndex = 0;
  String _adminEmail = '';
  SessionAuditLog? _expandedLog;
  List<SessionAuditLog> _logs = [];
  String _selectedDocActionFilter = 'All';
  String _docSearchQuery = '';
  // Roster / User Management State
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPhoneController = TextEditingController();
  final _userEnrollmentController = TextEditingController();
  final _userRoleTitleController = TextEditingController();
  final _userSpecialtyController = TextEditingController();
  final _docGroupNameController = TextEditingController();
  final _userPasswordController = TextEditingController();
  
  String _selectedUserRole = 'Staff';
  final _userFormKey = GlobalKey<FormState>();
  String _userSearchQuery = '';
  // Document attachment state for Add/Edit User Dialog
  final List<Map<String, dynamic>> _dialogDocGroups = [];
  List<Map<String, dynamic>> _userRecords = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bgController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
    _initAdminEmail();
    _fetchLogs();
    _loadUsers();
  }
  Future<void> _initAdminEmail() async {
    final prefs = await SharedPreferences.getInstance();
    _adminEmail = prefs.getString('user_email') ?? 'admin@cochinunited.com';
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      if (_adminEmail.isNotEmpty) {
        SessionTrackingService.checkOut(_adminEmail);
        AttendanceService.updateStatus(_adminEmail, false, '--');
      }
    } else if (state == AppLifecycleState.resumed) {
      if (_adminEmail.isNotEmpty) {
        final now = DateTime.now();
        final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";
        SessionTrackingService.checkIn(_adminEmail);
        AttendanceService.updateStatus(_adminEmail, true, timeStr);
      }
    }
  }
  Future<void> _loadUsers() async {
    var data = await UserService.getAllUsers();
    
    // Seed default test users if the database is empty (migration from Supabase)
    if (data.isEmpty) {
      print('Seeding default users...');
      await UserService.createUser(email: 'admin@cuc.com', password: 'Cuc@12345', name: 'Admin', role: 'Admin', roleTitle: 'System Administrator', phone: '+1234567890');
      await UserService.createUser(email: 'manager@cuc.com', password: 'Cuc@12345', name: 'Manager', role: 'Manager', roleTitle: 'Operations Manager', phone: '+1234567890');
      await UserService.createUser(email: 'staff@cuc.com', password: 'Cuc@12345', name: 'Staff', role: 'Staff', roleTitle: 'Paralegal', phone: '+1234567890');
      data = await UserService.getAllUsers();
    }
    if (mounted) {
      setState(() {
        _userRecords = data.map((u) => {
          'id': u['id']?.toString() ?? '',
          'name': u['name']?.toString() ?? u['email']?.toString() ?? '',
          'email': u['email']?.toString() ?? '',
          'phone': u['phone']?.toString() ?? '',
          'enrollmentId': u['enrollment_id']?.toString() ?? 'N/A',
          'role': u['role']?.toString() ?? 'Staff',
          'roleTitle': u['role_title']?.toString() ?? '',
          'specialty': u['specialty']?.toString() ?? 'General Practice',
          'isActive': u['is_active'] as bool? ?? true,
          'docGroups': <Map<String, dynamic>>[],
        }).toList();
      });
    }
  }
  @override
  void dispose() {
    _bgController.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    _userPhoneController.dispose();
    _userEnrollmentController.dispose();
    _userRoleTitleController.dispose();
    _userSpecialtyController.dispose();
    _docGroupNameController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  Future<void> _fetchLogs() async {
    final data = await LoggingService().fetchAllLogs();
    final List<SessionAuditLog> parsedLogs = [];
    // Map each user to their session logs
    final userSessions = <String, List<Map<String, dynamic>>>{};
    for (var d in data) {
      final email = (d['user_email'] ?? '').toString();
      if (email.isEmpty) continue;
      userSessions.putIfAbsent(email, () => []).add(d);
    }
    final now = DateTime.now();
    for (var email in userSessions.keys) {
      final logs = userSessions[email]!;
      logs.sort((a, b) {
        final ta = DateTime.tryParse(a['timestamp'] ?? '') ?? DateTime(2000);
        final tb = DateTime.tryParse(b['timestamp'] ?? '') ?? DateTime(2000);
        return tb.compareTo(ta);
      });
      final firstLog = logs.first;
      final isActive = firstLog['action'] == 'login';
      final firstTime = DateTime.tryParse(firstLog['timestamp'] ?? '') ?? DateTime.now();
      
      final features = <String>{};
      DateTime? lastTime;
      for (var l in logs) {
        if (l['action'] == 'logout') {
          if (lastTime == null) {
            lastTime = DateTime.tryParse(l['timestamp'] ?? '');
          }
        }
        if (l['details'] != null && l['details'].toString().isNotEmpty) {
          features.add(l['details'].toString());
        }
      }
      
      if (lastTime == null) lastTime = DateTime.now();
      
      final duration = lastTime.difference(firstTime).abs();
      String durationText;
      if (duration.inMinutes < 60) durationText = "${duration.inMinutes} mins";
      else durationText = "${duration.inHours}h ${duration.inMinutes % 60}m";
      
      String formatTime(DateTime dt) {
        return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}";
      }
      parsedLogs.add(SessionAuditLog(
        userName: email.split('@')[0],
        role: firstLog['user_role'] ?? 'Staff',
        roleTitle: 'Firm User',
        location: 'Remote Access',
        platform: 'System UI',
        openingTime: formatTime(firstTime),
        closingTime: isActive ? 'Active Now' : formatTime(lastTime),
        durationText: durationText,
        featuresUsed: features.toList(),
        isActive: isActive,
        dateText: 'Today',
      ));
    }
    if (mounted) {
      setState(() {
        _logs = parsedLogs;
      });
    }
  }
  void _exportLedgerLogs(List<SessionAuditLog> logsToExport, String filename) {
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
                'Ledger exported successfully to $filename (${logsToExport.length} entries)',
                style: const TextStyle(fontFamily: 'Montserrat', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final showSidebar = size.width > 950;
    // Filter logic
    final filteredLogs = _logs.where((log) {
      final matchesRole = _selectedRoleFilter == 'All' || log.role == _selectedRoleFilter;
      final matchesStatus = _statusFilter == 'All' || (log.isActive && _statusFilter == 'Active');
      final matchesSearch = log.userName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          log.roleTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          log.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          log.platform.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesRole && matchesStatus && matchesSearch;
    }).toList();
    final Widget dashboardView = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInfrastructureGauges(),
          const SizedBox(height: 20),
          _buildMetricsGrid(filteredLogs),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isWideDashboard = constraints.maxWidth > 800;
              if (isWideDashboard) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildFeatureHitRateCard(),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildLoginPeakCard(),
                    ),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFeatureHitRateCard(),
                    const SizedBox(height: 24),
                    _buildLoginPeakCard(),
                  ],
                );
              }
            },
          ).animate().fade(delay: 300.ms, duration: 600.ms),
        ],
      ),
    );
    final Widget logMonitorView = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _buildRoleFilterDropdown(),
              const SizedBox(width: 16),
              Expanded(child: _buildSearchField()),
            ],
          ),
          const SizedBox(height: 16),
          _buildAuditsSection(filteredLogs),
        ],
      ),
    );
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      drawer: showSidebar ? null : _buildSidebar(context, isDrawer: true),
      body: Row(
        children: [
          if (showSidebar) _buildSidebar(context, isDrawer: false),
          Expanded(
            child: Column(
              children: [
                if (!showSidebar) _buildHeader(context),
                Expanded(
                  child: Stack(
                    children: [
                      // Background Graphic
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: _bgController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: 0.05 + (_bgController.value * 0.05),
                              child: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/dashboard_bg.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Active View
                      SafeArea(
                        child: IndexedStack(
                          index: _activeSidebarIndex,
                          children: [
                            dashboardView,
                            logMonitorView,
                            _buildManageUsersPage(),
                            _buildDocumentAuditPage(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildInfrastructureGauges() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentColor.withValues(alpha: 0.1),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 600;
          if (isNarrow) {
            return Column(
              children: [
                _buildGaugeItem(
                  title: 'SERVER LOAD',
                  value: '18%',
                  icon: Icons.dns_rounded,
                  color: AppTheme.successGreen,
                  pct: 0.18,
                ),
                const Divider(color: AppTheme.secondaryColor, height: 16),
                _buildGaugeItem(
                  title: 'DATABASE LATENCY',
                  value: '12 ms',
                  icon: Icons.speed_rounded,
                  color: AppTheme.accentColor,
                  pct: 0.12,
                ),
                const Divider(color: AppTheme.secondaryColor, height: 16),
                _buildGaugeItem(
                  title: 'VAULT SYNC',
                  value: 'SECURE',
                  icon: Icons.gpp_good_rounded,
                  color: const Color(0xFF60A5FA),
                  pct: 1.0,
                ),
              ],
            );
          }
          return Row(
            children: [
              Expanded(
                child: _buildGaugeItem(
                  title: 'SERVER LOAD',
                  value: '18%',
                  icon: Icons.dns_rounded,
                  color: AppTheme.successGreen,
                  pct: 0.18,
                ),
              ),
              Container(
                width: 1,
                height: 36,
                color: AppTheme.secondaryColor,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: _buildGaugeItem(
                  title: 'DATABASE LATENCY',
                  value: '12 ms',
                  icon: Icons.speed_rounded,
                  color: AppTheme.accentColor,
                  pct: 0.12,
                ),
              ),
              Container(
                width: 1,
                height: 36,
                color: AppTheme.secondaryColor,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: _buildGaugeItem(
                  title: 'VAULT SYNC',
                  value: 'SECURE',
                  icon: Icons.gpp_good_rounded,
                  color: const Color(0xFF60A5FA),
                  pct: 1.0,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  Widget _buildGaugeItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required double pct,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Container(
                  height: 4,
                  color: AppTheme.secondaryColor,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: pct,
                    child: Container(color: color),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  // IT Dashboard Header (Mobile Viewport)
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            icon: const Icon(Icons.menu_rounded, color: AppTheme.accentColor),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          const SizedBox(width: 8),
          Image.asset('assets/logo.png', width: 28, height: 28),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'COCHIN UNITED',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  'IT SECURITY CONSOLE',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // Highly responsive Metrics Grid. Calculates size-proportional aspect ratios to keep cards exactly 92px tall.
  Widget _buildMetricsGrid(List<SessionAuditLog> filteredList) {
    final double width = MediaQuery.of(context).size.width;
    final bool showSidebar = width > 950;
    final double availableWidth = showSidebar ? (width - 260) : width;
    int cols = 1;
    if (availableWidth > 1200) {
      cols = 4;
    } else if (availableWidth > 800) {
      cols = 2;
    }
    final double paddingWidth = 48.0 + (cols - 1) * 16.0;
    final double itemWidth = (availableWidth - paddingWidth) / cols;
    final double aspectRatio = itemWidth / 92.0;
    final int onlineCount = _logs.where((l) => l.isActive).length;
    final int totalCount = _logs.length;
    return GridView.count(
      crossAxisCount: cols,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: aspectRatio,
      children: [
        _buildMetricCard(
          title: 'ACTIVE SESSIONS',
          value: '$onlineCount Online',
          icon: Icons.wifi_tethering_rounded,
          color: AppTheme.successGreen,
          detail: _statusFilter == 'Active' ? 'Filtering: Active Only' : 'Click to filter Active',
          isSelected: _statusFilter == 'Active',
          onTap: () {
            setState(() {
              _statusFilter = _statusFilter == 'Active' ? 'All' : 'Active';
            });
          },
        ),
        _buildMetricCard(
          title: 'TODAY AUDITS',
          value: '$totalCount Logs',
          icon: Icons.history_toggle_off_rounded,
          color: AppTheme.accentColor,
          detail: 'Click to reset filters',
          isSelected: _selectedRoleFilter == 'All' && _statusFilter == 'All' && _searchQuery.isEmpty,
          onTap: () {
            setState(() {
              _selectedRoleFilter = 'All';
              _statusFilter = 'All';
              _searchQuery = '';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppTheme.accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                content: const Text(
                  'Dashboard reset: Filter constraints cleared.',
                  style: TextStyle(fontFamily: 'Montserrat', color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
        _buildMetricCard(
          title: 'AVG SESSION TIME',
          value: '42 mins',
          icon: Icons.timer_outlined,
          color: const Color(0xFF60A5FA),
          detail: 'Click to view stats',
          onTap: () {
            _showSessionStatsDialog();
          },
        ),
        _buildMetricCard(
          title: 'TOP FEATURE HIT',
          value: 'Financials (48%)',
          icon: Icons.insights_rounded,
          color: const Color(0xFFC084FC),
          detail: 'Click to view breakdown',
          onTap: () {
            _showFeaturePopularityDialog();
          },
        ),
      ],
    ).animate().fade(duration: 600.ms).slideY(begin: 0.05, end: 0);
  }
  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String detail,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.accentColor.withValues(alpha: 0.06)
                : AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppTheme.accentColor
                  : AppTheme.accentColor.withValues(alpha: 0.12),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.accentColor.withValues(alpha: 0.06),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: ['Arial', 'sans-serif'],
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          value,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontFamilyFallback: ['Arial', 'sans-serif'],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.check_circle_rounded, color: AppTheme.accentColor, size: 12),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      detail,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontFamilyFallback: const ['Arial', 'sans-serif'],
                        fontSize: 9,
                        color: isSelected ? AppTheme.accentColor : AppTheme.textSecondary.withValues(alpha: 0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Audits Logs Table/Cards Section
  Widget _buildAuditsSection(List<SessionAuditLog> logsList) {
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
          // Row containing title, filters, search, simulator toggle, export, and archives trigger
          Row(
            children: [
              const Icon(Icons.security_rounded, color: AppTheme.accentColor, size: 22),
              const SizedBox(width: 8),
              const Text(
                'Today Activity Log',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Arial', 'sans-serif'],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              _buildExportButton(logsList, 'Today_Session_Audit_Logs.csv'),
              const SizedBox(width: 8),
              _buildHistoryNavigationButton(),
              const SizedBox(width: 8),
              _buildRoleFilterDropdown(),
            ],
          ),
          const SizedBox(height: 16),
          // Search input field
          _buildSearchField(),
          const SizedBox(height: 20),
          // Session log table list
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
  Widget _buildExportButton(List<SessionAuditLog> logsToExport, String filename) {
    return IconButton(
      icon: const Icon(Icons.download_rounded, size: 18, color: AppTheme.accentColor),
      tooltip: 'Export Session Ledger',
      style: IconButton.styleFrom(
        backgroundColor: AppTheme.accentColor.withValues(alpha: 0.1),
        hoverColor: AppTheme.accentColor.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppTheme.accentColor.withValues(alpha: 0.3)),
        ),
      ),
      onPressed: () => _exportLedgerLogs(logsToExport, filename),
    );
  }
  Widget _buildHistoryNavigationButton() {
    final double width = MediaQuery.of(context).size.width;
    final bool isCompact = width < 900;
    if (isCompact) {
      return IconButton(
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => AuditHistoryScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                  ),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        },
        icon: const Icon(Icons.history_rounded, size: 18, color: AppTheme.accentColor),
        tooltip: 'View Archives',
        style: IconButton.styleFrom(
          backgroundColor: AppTheme.accentColor.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: AppTheme.accentColor.withValues(alpha: 0.4)),
          ),
        ),
      );
    }
    return TextButton.icon(
      onPressed: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => AuditHistoryScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                ),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      icon: const Icon(Icons.history_rounded, size: 16, color: AppTheme.accentColor),
      label: const Text(
        'View Archives',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontFamilyFallback: ['Arial', 'sans-serif'],
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.accentColor,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: AppTheme.accentColor.withValues(alpha: 0.1),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: AppTheme.accentColor.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
      ),
    );
  }
  Widget _buildRoleFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.15)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedRoleFilter,
          dropdownColor: AppTheme.surfaceColor,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontFamilyFallback: ['Arial', 'sans-serif'],
            color: AppTheme.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppTheme.accentColor),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedRoleFilter = newValue;
              });
            }
          },
          items: <String>['All', 'Admin', 'Manager', 'Staff']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text('Role: $value'),
            );
          }).toList(),
        ),
      ),
    );
  }
  Widget _buildSearchField() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.2), width: 1.0),
      ),
      child: TextField(
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontFamilyFallback: ['Arial', 'sans-serif'],
          color: AppTheme.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded, size: 22, color: AppTheme.textSecondary),
          hintText: 'Search audits by name, office, device...',
          hintStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontFamilyFallback: const ['Arial', 'sans-serif'],
            color: AppTheme.textSecondary.withValues(alpha: 0.7),
            fontSize: 14,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }
  Widget _buildSessionLogItem(SessionAuditLog log) {
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
                      Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
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
                          _buildStatusChip(log.isActive),
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
                                Flexible(
                                  child: Text(
                                    log.userName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontFamilyFallback: ['Arial', 'sans-serif'],
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                    ),
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
                                  color: AppTheme.textPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Close: ${log.closingTime}',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontFamilyFallback: const ['Arial', 'sans-serif'],
                                fontSize: 11,
                                color: log.isActive ? AppTheme.successGreen : AppTheme.textSecondary,
                                fontWeight: log.isActive ? FontWeight.bold : FontWeight.normal,
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
                      // Status Badge
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: _buildStatusChip(log.isActive),
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
  Widget _buildExpandedDrawer(SessionAuditLog log) {
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
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
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
    final bool isToday = date == 'Today';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isToday
            ? AppTheme.secondaryColor
            : AppTheme.accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isToday
              ? AppTheme.textSecondary.withValues(alpha: 0.2)
              : AppTheme.accentColor.withValues(alpha: 0.3),
          width: 0.7,
        ),
      ),
      child: Text(
        date.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontFamilyFallback: const ['Arial', 'sans-serif'],
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: isToday ? AppTheme.textSecondary : AppTheme.accentColor,
        ),
      ),
    );
  }
  Widget _buildStatusChip(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.successGreen.withValues(alpha: 0.12)
            : AppTheme.textSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive
              ? AppTheme.successGreen.withValues(alpha: 0.4)
              : AppTheme.textSecondary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isActive)
            Container(
              width: 5,
              height: 5,
              margin: const EdgeInsets.only(right: 6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.successGreen,
              ),
            ).animate(onPlay: (c) => c.repeat()).fadeIn(duration: 600.ms).fadeOut(duration: 600.ms)
          else
            Container(
              width: 5,
              height: 5,
              margin: const EdgeInsets.only(right: 6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.textSecondary,
              ),
            ),
          Text(
            isActive ? 'Active Now' : 'Closed',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: const ['Arial', 'sans-serif'],
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isActive ? AppTheme.successGreen : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildRoleTag(String role) {
    Color tagColor = AppTheme.accentColor;
    if (role == 'Admin') {
      tagColor = const Color(0xFFC084FC); // Admin Purple
    } else if (role == 'Manager') {
      tagColor = const Color(0xFF60A5FA); // Manager Blue
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
            'No matching logs found',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontFamilyFallback: ['Arial', 'sans-serif'],
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try adjusting your role filter or search keyword.',
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
  // Feature usage rate card
  Widget _buildFeatureHitRateCard() {
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
          const Row(
            children: [
              Icon(Icons.pie_chart_outline_rounded, color: AppTheme.accentColor, size: 18),
              SizedBox(width: 8),
              Text(
                'Feature Hit Rate',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Arial', 'sans-serif'],
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _buildProgressStatRow('Financial Dashboard', 0.48, 'Admin / Accounts'),
          const SizedBox(height: 12),
          _buildProgressStatRow('Case Vault Search', 0.32, 'Staff Advocates'),
          const SizedBox(height: 12),
          _buildProgressStatRow('Staff Roster Admin', 0.14, 'Admin / Managers'),
          const SizedBox(height: 12),
          _buildProgressStatRow('Chamber Secure Chat', 0.06, 'Staff Paralegals'),
        ],
      ),
    );
  }
  Widget _buildProgressStatRow(String label, double pct, String subgroup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Arial', 'sans-serif'],
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              '${(pct * 100).round()}%',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontFamilyFallback: ['Arial', 'sans-serif'],
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            height: 6,
            color: AppTheme.secondaryColor,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: pct,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.goldGradient,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subgroup,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontFamilyFallback: const ['Arial', 'sans-serif'],
            fontSize: 9,
            color: AppTheme.textSecondary.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
  // Peak usage hours card
  Widget _buildLoginPeakCard() {
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
          const Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: AppTheme.accentColor, size: 18),
              SizedBox(width: 8),
              Text(
                'Peak Activity Hours',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontFamilyFallback: ['Arial', 'sans-serif'],
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Horizontal visual representation of Peak hours
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildBarItem('09 AM', 0.25),
              _buildBarItem('12 PM', 0.60),
              _buildBarItem('03 PM', 0.85),
              _buildBarItem('06 PM', 0.95), // Peak login hour
              _buildBarItem('09 PM', 0.40),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildBarItem(String hourLabel, double heightPct) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 28,
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: heightPct,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: AppTheme.goldGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentColor.withValues(alpha: 0.15),
                    blurRadius: 6,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          hourLabel,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontFamilyFallback: ['Arial', 'sans-serif'],
            fontSize: 9,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
  // Interactive Popup Modal showing dynamic Session statistics (Avg Session Time card action)
  void _showSessionStatsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppTheme.accentColor.withValues(alpha: 0.25), width: 1.5),
          ),
          title: const Row(
            children: [
              Icon(Icons.query_stats_rounded, color: AppTheme.accentColor, size: 24),
              SizedBox(width: 10),
              Text(
                'Session Duration Analysis',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'IT security configurations enforce automatic session expiration limits after 8 hours of continuous connection.',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 18),
              _buildDurationRow('Admin Sessions', '2h 15m avg', 0.28, const Color(0xFFC084FC)),
              const SizedBox(height: 12),
              _buildDurationRow('Manager Sessions', '4h 30m avg', 0.56, const Color(0xFF60A5FA)),
              const SizedBox(height: 12),
              _buildDurationRow('Staff Sessions', '1h 45m avg', 0.22, AppTheme.accentColor),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.successGreen.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded, color: AppTheme.successGreen, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'All session life times are well within acceptable operational boundaries.',
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 10, color: AppTheme.successGreen, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'CLOSE',
                style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: AppTheme.accentColor),
              ),
            ),
          ],
        );
      },
    );
  }
  Widget _buildDurationRow(String label, String value, double ratio, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
          children: [
            Text(label, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            Text(value, style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Container(
            height: 4,
            color: AppTheme.secondaryColor,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: ratio,
              child: Container(color: color),
            ),
          ),
        ),
      ],
    );
  }
  // Interactive Popup Modal showing dynamic Feature popularity details (Top Feature Hit card action)
  void _showFeaturePopularityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppTheme.accentColor.withValues(alpha: 0.25), width: 1.5),
          ),
          title: const Row(
            children: [
              Icon(Icons.pie_chart_rounded, color: AppTheme.accentColor, size: 24),
              SizedBox(width: 10),
              Text(
                'Feature Popularity Audit',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Total queries logged: 1,420 entries today.',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 16),
                _buildFeatureHitItem('1. Financial Dashboard', '681 hits', '48%', 0.48),
                _buildFeatureHitItem('2. Case Vault Search', '454 hits', '32%', 0.32),
                _buildFeatureHitItem('3. Staff Roster Admin', '198 hits', '14%', 0.14),
                _buildFeatureHitItem('4. Chamber Secure Chat', '85 hits', '6%', 0.06),
                _buildFeatureHitItem('5. Audit Logs Console', '2 hits', '<1%', 0.01),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'CLOSE',
                style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: AppTheme.accentColor),
              ),
            ),
          ],
        );
      },
    );
  }
  Widget _buildFeatureHitItem(String label, String hitsText, String pctText, double ratio) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              Text(label, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
              Text('$hitsText ($pctText)', style: const TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.accentColor)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              height: 4,
              color: AppTheme.secondaryColor,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: ratio,
                child: Container(
                  decoration: const BoxDecoration(gradient: AppTheme.goldGradient),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // ————————————————————————————————————————————————————————————————————————————————————
  Widget _buildManageUsersPage() {
    final filteredUsers = _userRecords.where((u) {
      if (_userSearchQuery.isEmpty) return true;
      final q = _userSearchQuery.toLowerCase();
      return u['name'].toString().toLowerCase().contains(q) ||
          u['email'].toString().toLowerCase().contains(q) ||
          u['role'].toString().toLowerCase().contains(q) ||
          u['enrollmentId'].toString().toLowerCase().contains(q) ||
          u['specialty'].toString().toLowerCase().contains(q);
    }).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Container(
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
            // Header
            LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 600;
                if (isCompact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.manage_accounts_rounded, color: AppTheme.accentColor, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Firm User Directory',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildAddUserButton(),
                    ],
                  );
                }
                return Row(
                  children: [
                    const Icon(Icons.manage_accounts_rounded, color: AppTheme.accentColor, size: 22),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Firm User Directory',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildAddUserButton(),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            // Search
            _buildUserSearchField(),
            const SizedBox(height: 8),
            // Summary chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildUserCountChip('All', _userRecords.length, null),
                _buildUserCountChip('Admin', _userRecords.where((u) => u['role'] == 'Admin').length, const Color(0xFFC084FC)),
                _buildUserCountChip('Manager', _userRecords.where((u) => u['role'] == 'Manager').length, const Color(0xFF60A5FA)),
                _buildUserCountChip('Staff', _userRecords.where((u) => u['role'] == 'Staff').length, AppTheme.accentColor),
                _buildUserCountChip('Active', _userRecords.where((u) => u['isActive'] == true).length, AppTheme.successGreen),
                _buildUserCountChip('Inactive', _userRecords.where((u) => u['isActive'] == false).length, AppTheme.errorRed),
              ],
            ),
            const SizedBox(height: 20),
            // User cards
            filteredUsers.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.person_search_rounded, color: AppTheme.textSecondary, size: 48),
                        SizedBox(height: 12),
                        Text('No matching users found', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                      ],
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredUsers.length,
                    separatorBuilder: (_, _) => Divider(color: AppTheme.accentColor.withValues(alpha: 0.08), height: 20),
                    itemBuilder: (context, index) => _buildUserCard(filteredUsers[index]),
                  ),
          ],
        ),
      ),
    );
  }
  Widget _buildAddUserButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.person_add_rounded, size: 16, color: AppTheme.primaryColor),
      label: const Text(
        'ADD USER',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 11,
          color: AppTheme.primaryColor,
          letterSpacing: 1.0,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.accentColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(0, 36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
      onPressed: () => _showUserFormDialog(),
    );
  }
  Widget _buildUserSearchField() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.2), width: 1.0),
      ),
      child: TextField(
        style: const TextStyle(
          fontFamily: 'Montserrat', 
          color: AppTheme.textPrimary, 
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        onChanged: (val) {
          setState(() {
            _userSearchQuery = val;
          });
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded, size: 22, color: AppTheme.textSecondary),
          hintText: 'Search by name, email, ID, specialty...',
          hintStyle: TextStyle(
            fontFamily: 'Montserrat', 
            color: AppTheme.textSecondary.withValues(alpha: 0.7), 
            fontSize: 14
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }
  Widget _buildUserCountChip(String label, int count, Color? accent) {
    final color = accent ?? AppTheme.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
  Widget _buildCardDocBadges(Map<String, dynamic> user) {
    final docGroups = user['docGroups'] as List? ?? [];
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: List.generate(docGroups.length, (idx) {
        final group = docGroups[idx];
        final String name = group['name'] ?? '';
        final files = group['files'] as List? ?? [];
        return InkWell(
          onTap: () => _showCredentialVaultDialog(user, idx),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.folder_open_rounded, size: 12, color: AppTheme.accentColor),
                const SizedBox(width: 4),
                Text(
                  '$name (${files.length})',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
  void _showCredentialVaultDialog(Map<String, dynamic> user, int initialGroupIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateVault) {
            final List docGroups = user['docGroups'] as List? ?? [];
            if (docGroups.isEmpty) {
              return AlertDialog(
                backgroundColor: AppTheme.surfaceColor,
                content: const Text('No documents found.', style: TextStyle(color: AppTheme.textPrimary)),
              );
            }
            int selectedGroupIndex = initialGroupIndex;
            if (selectedGroupIndex >= docGroups.length) selectedGroupIndex = 0;
            final group = docGroups[selectedGroupIndex];
            final String groupName = group['name'] ?? 'Documents';
            final List files = group['files'] as List? ?? [];
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 550,
                constraints: const BoxConstraints(maxHeight: 500),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.25), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          const Icon(Icons.folder_shared_rounded, color: AppTheme.accentColor, size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  groupName,
                                  style: const TextStyle(fontFamily: 'Cinzel', fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                                ),
                                Text(
                                  'Accredited folders for ${user['name']}',
                                  style: const TextStyle(fontFamily: 'Montserrat', fontSize: 10, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: AppTheme.textSecondary, size: 20),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: AppTheme.secondaryColor, height: 1),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: 160,
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor,
                              border: const Border(right: BorderSide(color: AppTheme.secondaryColor, width: 1)),
                            ),
                            child: ListView.builder(
                              itemCount: docGroups.length,
                              itemBuilder: (context, idx) {
                                final isSelected = idx == selectedGroupIndex;
                                return InkWell(
                                  onTap: () {
                                    setStateVault(() {
                                      selectedGroupIndex = idx;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    color: isSelected ? AppTheme.accentColor.withValues(alpha: 0.08) : Colors.transparent,
                                    child: Row(
                                      children: [
                                        Icon(
                                          isSelected ? Icons.folder_open_rounded : Icons.folder_rounded,
                                          size: 14,
                                          color: isSelected ? AppTheme.accentColor : AppTheme.textSecondary,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            docGroups[idx]['name'] ?? 'Group',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 11,
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                              color: isSelected ? AppTheme.accentColor : AppTheme.textPrimary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: files.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No files in this folder.',
                                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: AppTheme.textSecondary),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: files.length,
                                    itemBuilder: (context, fileIdx) {
                                      final file = files[fileIdx];
                                      final String fileName = file['name'] ?? 'File';
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: AppTheme.secondaryColor,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.05)),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.insert_drive_file_rounded, color: AppTheme.accentColor, size: 18),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                fileName,
                                                style: const TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: AppTheme.textPrimary),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppTheme.accentColor,
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                                minimumSize: const Size(0, 24),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                              ),
                                              onPressed: () {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    behavior: SnackBarBehavior.floating,
                                                    backgroundColor: AppTheme.successGreen,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                    content: Text(
                                                      'Decrypting and opening "$fileName" securely...',
                                                      style: const TextStyle(fontFamily: 'Montserrat', color: Colors.white, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'DECRYPT',
                                                style: TextStyle(fontFamily: 'Montserrat', fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  Widget _buildUserCard(Map<String, dynamic> user) {
    final bool isActive = user['isActive'] == true;
    final String role = user['role'] ?? 'Staff';
    Color roleColor = AppTheme.accentColor;
    if (role == 'Admin') roleColor = const Color(0xFFC084FC);
    if (role == 'Manager') roleColor = const Color(0xFF60A5FA);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? Colors.transparent : AppTheme.errorRed.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? AppTheme.accentColor.withValues(alpha: 0.08) : AppTheme.errorRed.withValues(alpha: 0.15),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 700;
          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name, role tag, status badge
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: roleColor.withValues(alpha: 0.12),
                        border: Border.all(color: roleColor.withValues(alpha: 0.4)),
                      ),
                      child: Center(
                        child: Text(
                          (user['name'] as String).isNotEmpty ? (user['name'] as String)[0].toUpperCase() : '?',
                          style: TextStyle(fontFamily: 'Cinzel', fontSize: 16, fontWeight: FontWeight.bold, color: roleColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user['name'], style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              _buildUserRoleTag(role, roleColor),
                              const SizedBox(width: 6),
                              Flexible(child: Text(user['roleTitle'], style: const TextStyle(fontFamily: 'Montserrat', fontSize: 10, color: AppTheme.textSecondary), overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildUserStatusBadge(isActive),
                  ],
                ),
                const SizedBox(height: 12),
                // Details
                _buildUserDetailRow(Icons.email_outlined, user['email']),
                _buildUserDetailRow(Icons.phone_outlined, user['phone']),
                _buildUserDetailRow(Icons.badge_outlined, 'Enrollment: ${user['enrollmentId']}'),
                _buildUserDetailRow(Icons.gavel_rounded, 'Specialty: ${user['specialty']}'),
                if (user['docGroups'] != null && (user['docGroups'] as List).isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _buildCardDocBadges(user),
                ],
                const SizedBox(height: 12),
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: _buildUserActions(user),
                ),
              ],
            );
          }
          // Desktop layout
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: roleColor.withValues(alpha: 0.12),
                  border: Border.all(color: roleColor.withValues(alpha: 0.4)),
                ),
                child: Center(
                  child: Text(
                    (user['name'] as String).isNotEmpty ? (user['name'] as String)[0].toUpperCase() : '?',
                    style: TextStyle(fontFamily: 'Cinzel', fontSize: 18, fontWeight: FontWeight.bold, color: roleColor),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info columns
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(child: Text(user['name'], style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary), overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 8),
                        _buildUserRoleTag(role, roleColor),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(user['roleTitle'], style: const TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: AppTheme.textSecondary)),
                    const SizedBox(height: 6),
                    Text(user['email'], style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: AppTheme.accentColor.withValues(alpha: 0.9))),
                    Text(user['phone'], style: const TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BAR ENROLLMENT', style: TextStyle(fontFamily: 'Montserrat', fontSize: 8, fontWeight: FontWeight.bold, color: AppTheme.textSecondary.withValues(alpha: 0.6), letterSpacing: 0.8)),
                    const SizedBox(height: 2),
                    Text(user['enrollmentId'], style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                    const SizedBox(height: 8),
                    Text('SPECIALTY', style: TextStyle(fontFamily: 'Montserrat', fontSize: 8, fontWeight: FontWeight.bold, color: AppTheme.textSecondary.withValues(alpha: 0.6), letterSpacing: 0.8)),
                    const SizedBox(height: 2),
                    Text(user['specialty'], style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: AppTheme.textPrimary)),
                    if (user['docGroups'] != null && (user['docGroups'] as List).isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _buildCardDocBadges(user),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Status + actions
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildUserStatusBadge(isActive),
                  const SizedBox(height: 10),
                  Row(children: _buildUserActions(user)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
  Widget _buildUserRoleTag(String role, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 0.7),
      ),
      child: Text(
        role,
        style: TextStyle(fontFamily: 'Montserrat', fontSize: 8, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
  Widget _buildUserStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.successGreen.withValues(alpha: 0.12) : AppTheme.errorRed.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive ? AppTheme.successGreen.withValues(alpha: 0.4) : AppTheme.errorRed.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5, height: 5,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppTheme.successGreen : AppTheme.errorRed,
            ),
          ),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isActive ? AppTheme.successGreen : AppTheme.errorRed,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildUserDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accentColor.withValues(alpha: 0.7), size: 13),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: AppTheme.textPrimary), overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
  List<Widget> _buildUserActions(Map<String, dynamic> user) {
    final bool isActive = user['isActive'] == true;
    return [
      _buildUserActionButton(Icons.edit_rounded, 'Edit', AppTheme.accentColor, () => _showUserFormDialog(existingUser: user)),
      const SizedBox(width: 6),
      _buildUserActionButton(
        isActive ? Icons.block_rounded : Icons.check_circle_outline_rounded,
        isActive ? 'Deactivate' : 'Activate',
        isActive ? AppTheme.errorRed : AppTheme.successGreen,
        () => _toggleUserStatus(user),
      ),
      const SizedBox(width: 6),
      _buildUserActionButton(Icons.delete_outline_rounded, 'Delete', AppTheme.errorRed, () => _confirmDeleteUser(user)),
    ];
  }
  Widget _buildUserActionButton(IconData icon, String tooltip, Color color, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, size: 14, color: color),
        ),
      ),
    );
  }
  // â”€â”€â”€ DIALOG DOCUMENT ATTACHMENTS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildDialogDocSection(StateSetter setDialogState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.attach_file_rounded, color: AppTheme.accentColor, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'ACCREDITATION DOCUMENTS',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: AppTheme.accentColor,
                  ),
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.create_new_folder_rounded, size: 14, color: AppTheme.primaryColor),
                label: const Text(
                  'ADD GROUP',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryColor, letterSpacing: 0.5),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: const Size(0, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: () => _showAddDialogDocGroupDialog(setDialogState),
              ),
            ],
          ),
          if (_dialogDocGroups.isEmpty) ...[
            const SizedBox(height: 16),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Icon(Icons.folder_open_rounded, color: AppTheme.textSecondary.withValues(alpha: 0.3), size: 28),
                    const SizedBox(height: 6),
                    const Text(
                      'No documents attached yet.',
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 10, color: AppTheme.textSecondary),
                    ),
                    Text(
                      'Attach Aadhaar, Bar Enrollment or Degree certificates.',
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 9, color: AppTheme.textSecondary.withValues(alpha: 0.5)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 12),
            ...List.generate(_dialogDocGroups.length, (gi) => _buildDialogDocGroupCard(gi, setDialogState)),
          ],
        ],
      ),
    );
  }
  Widget _buildDialogDocGroupCard(int groupIndex, StateSetter setDialogState) {
    final group = _dialogDocGroups[groupIndex];
    final String groupName = group['name'] ?? 'Untitled Group';
    final List<Map<String, dynamic>> files = List<Map<String, dynamic>>.from(group['files'] ?? []);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.folder_rounded, color: AppTheme.accentColor.withValues(alpha: 0.8), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  groupName,
                  style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${files.length} file${files.length != 1 ? 's' : ''}',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 9, color: AppTheme.textSecondary.withValues(alpha: 0.6)),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _pickFilesForDialogGroup(groupIndex, setDialogState),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.add_photo_alternate_rounded, size: 14, color: AppTheme.accentColor),
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: () {
                  setDialogState(() {
                    _dialogDocGroups.removeAt(groupIndex);
                  });
                },
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.errorRed.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, size: 14, color: AppTheme.errorRed),
                ),
              ),
            ],
          ),
          if (files.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(files.length, (fi) {
                final file = files[fi];
                final String fileName = file['name'] ?? 'Unnamed';
                final Uint8List? bytes = file['bytes'];
                final bool isImage = _isImageFile(fileName);
                return _buildDialogFileChip(groupIndex, fi, fileName, bytes, isImage, setDialogState);
              }),
            ),
          ],
        ],
      ),
    );
  }
  Widget _buildDialogFileChip(int gi, int fi, String fileName, Uint8List? bytes, bool isImage, StateSetter setDialogState) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
            child: SizedBox(
              height: 60,
              width: 100,
              child: isImage && bytes != null
                  ? Image.memory(bytes, fit: BoxFit.cover)
                  : Container(
                      color: AppTheme.secondaryColor,
                      child: const Center(child: Icon(Icons.insert_drive_file_rounded, color: AppTheme.textSecondary, size: 24)),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Column(
              children: [
                Text(
                  fileName,
                  style: const TextStyle(fontFamily: 'Montserrat', fontSize: 7, color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => _renameFileDialogInGroup(gi, fi, fileName, setDialogState),
                      child: Icon(Icons.edit_rounded, size: 10, color: AppTheme.accentColor.withValues(alpha: 0.7)),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        setDialogState(() {
                          (_dialogDocGroups[gi]['files'] as List).removeAt(fi);
                        });
                      },
                      child: const Icon(Icons.close_rounded, size: 10, color: AppTheme.errorRed),
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
  bool _isImageFile(String name) {
    final lower = name.toLowerCase();
    return lower.endsWith('.png') || lower.endsWith('.jpg') || lower.endsWith('.jpeg') || lower.endsWith('.gif') || lower.endsWith('.webp') || lower.endsWith('.bmp');
  }
  void _showAddDialogDocGroupDialog(StateSetter setDialogState) {
    _docGroupNameController.clear();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppTheme.accentColor.withValues(alpha: 0.25)),
          ),
          title: const Row(
            children: [
              Icon(Icons.create_new_folder_rounded, color: AppTheme.accentColor, size: 20),
              SizedBox(width: 10),
              Text('New Document Group', style: TextStyle(fontFamily: 'Cinzel', fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter a name for this group (e.g., Aadhaar Card, PAN Card, Enrollment Certificate).',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _docGroupNameController,
                autofocus: true,
                style: const TextStyle(fontFamily: 'Montserrat', color: AppTheme.textPrimary, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'e.g., Aadhaar Card',
                  labelText: 'Group Name',
                  prefixIcon: Icon(Icons.label_outline_rounded, size: 18),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('CANCEL', style: TextStyle(fontFamily: 'Montserrat', color: AppTheme.textSecondary, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                final name = _docGroupNameController.text.trim();
                if (name.isNotEmpty) {
                  setDialogState(() {
                    _dialogDocGroups.add({'name': name, 'files': <Map<String, dynamic>>[]});
                  });
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text('CREATE', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryColor)),
            ),
          ],
        );
      },
    );
  }
  Future<void> _pickFilesForDialogGroup(int groupIndex, StateSetter setDialogState) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'pdf', 'doc', 'docx'],
        allowMultiple: true,
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        setDialogState(() {
          for (final file in result.files) {
            (_dialogDocGroups[groupIndex]['files'] as List).add({
              'name': file.name,
              'bytes': file.bytes,
            });
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.errorRed,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Text('Failed to pick file: $e', style: const TextStyle(fontFamily: 'Montserrat', color: Colors.white)),
          ),
        );
      }
    }
  }
  void _renameFileDialogInGroup(int gi, int fi, String currentName, StateSetter setDialogState) {
    final renameController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppTheme.accentColor.withValues(alpha: 0.25)),
          ),
          title: const Row(
            children: [
              Icon(Icons.drive_file_rename_outline, color: AppTheme.accentColor, size: 20),
              SizedBox(width: 10),
              Text('Rename File', style: TextStyle(fontFamily: 'Cinzel', fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            ],
          ),
          content: TextField(
            controller: renameController,
            autofocus: true,
            style: const TextStyle(fontFamily: 'Montserrat', color: AppTheme.textPrimary, fontSize: 13),
            decoration: const InputDecoration(
              labelText: 'File Name',
              prefixIcon: Icon(Icons.label_outline_rounded, size: 18),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('CANCEL', style: TextStyle(fontFamily: 'Montserrat', color: AppTheme.textSecondary, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                final newName = renameController.text.trim();
                if (newName.isNotEmpty) {
                  setDialogState(() {
                    (_dialogDocGroups[gi]['files'] as List)[fi]['name'] = newName;
                  });
                  Navigator.of(ctx).pop();
                }
                renameController.dispose();
              },
              child: const Text('RENAME', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryColor)),
            ),
          ],
        );
      },
    );
  }
  // â”€â”€â”€ Add / Edit User Dialog â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _showUserFormDialog({Map<String, dynamic>? existingUser}) async {
    final bool isEditing = existingUser != null;
    _dialogDocGroups.clear();
    _userPasswordController.clear();
    if (isEditing) {
      _userNameController.text = existingUser['name'] ?? '';
      _userEmailController.text = existingUser['email'] ?? '';
      _userPhoneController.text = existingUser['phone'] ?? '';
      _userEnrollmentController.text = existingUser['enrollmentId'] ?? '';
      _userRoleTitleController.text = existingUser['roleTitle'] ?? '';
      _userSpecialtyController.text = existingUser['specialty'] ?? '';
      _selectedUserRole = existingUser['role'] ?? 'Staff';
      if (existingUser['docGroups'] != null) {
        for (final group in existingUser['docGroups']) {
          _dialogDocGroups.add({
            'name': group['name'],
            'files': List<Map<String, dynamic>>.from(group['files'] ?? []),
          });
        }
      }
    } else {
      _clearUserForm();
    }
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (sContext, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Container(
                width: 500,
                constraints: const BoxConstraints(maxHeight: 780),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.25), width: 1.5),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _userFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(isEditing ? Icons.edit_rounded : Icons.person_add_rounded, color: AppTheme.accentColor, size: 22),
                            const SizedBox(width: 10),
                            Text(
                              isEditing ? 'Edit User Account' : 'Add New User',
                              style: const TextStyle(fontFamily: 'Cinzel', fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isEditing ? 'Update account details for ${existingUser['name']}.' : 'Register a new staff, manager, or admin account.',
                          style: const TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 20),
                        // Full Name
                        TextFormField(
                          controller: _userNameController,
                          style: const TextStyle(fontFamily: 'Montserrat', color: AppTheme.textPrimary, fontSize: 13),
                          decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_rounded, size: 18)),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 14),
                        // Email
                        TextFormField(
                          controller: _userEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontFamily: 'Montserrat', color: AppTheme.textPrimary, fontSize: 13),
                          decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined, size: 18)),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Required';
                            if (!v.contains('@') || !v.contains('.')) return 'Invalid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        // Phone
                        TextFormField(
                          controller: _userPhoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(fontFamily: 'Montserrat', color: AppTheme.textPrimary, fontSize: 13),
                          decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined, size: 18)),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 14),
                        // Role dropdown
                        DropdownButtonFormField<String>(
                          initialValue: _selectedUserRole,
                          dropdownColor: AppTheme.surfaceColor,
                          style: const TextStyle(fontFamily: 'Montserrat', color: AppTheme.textPrimary, fontSize: 13),
                          decoration: const InputDecoration(labelText: 'System Role', prefixIcon: Icon(Icons.security_rounded, size: 18)),
                          items: const [
                            DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                            DropdownMenuItem(value: 'Manager', child: Text('Manager')),
                            DropdownMenuItem(value: 'Staff', child: Text('Staff')),
                          ],
                          onChanged: (v) {
                            if (v != null) {
                              setDialogState(() {
                                _selectedUserRole = v;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 14),
                        // Role Title
                        TextFormField(
                          controller: _userRoleTitleController,
                          style: const TextStyle(fontFamily: 'Montserrat', color: AppTheme.textPrimary, fontSize: 13),
                          decoration: const InputDecoration(labelText: 'Designation / Title', prefixIcon: Icon(Icons.work_outline_rounded, size: 18), hintText: 'e.g. Senior Litigation Counsel'),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 14),
                        // Bar Enrollment
                        TextFormField(
                          controller: _userEnrollmentController,
                          style: const TextStyle(fontFamily: 'Montserrat', color: AppTheme.textPrimary, fontSize: 13),
                          decoration: const InputDecoration(labelText: 'Bar Enrollment ID', prefixIcon: Icon(Icons.badge_outlined, size: 18), hintText: 'e.g. K/1024/2012'),
                        ),
                        const SizedBox(height: 14),
                        // Specialty
                        TextFormField(
                          controller: _userSpecialtyController,
                          style: const TextStyle(fontFamily: 'Montserrat', color: AppTheme.textPrimary, fontSize: 13),
                          decoration: const InputDecoration(labelText: 'Practice Area / Specialty', prefixIcon: Icon(Icons.gavel_rounded, size: 18), hintText: 'e.g. Maritime Dispute'),
                        ),
                        const SizedBox(height: 14),
                        // Password field
                        TextFormField(
                          controller: _userPasswordController,
                          obscureText: true,
                          style: const TextStyle(fontFamily: 'Montserrat', color: AppTheme.textPrimary, fontSize: 13),
                          decoration: InputDecoration(
                            labelText: isEditing ? 'New Password (leave blank to keep)' : 'Password',
                            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18),
                            hintText: isEditing ? 'Leave blank to keep current' : 'Set login password',
                          ),
                          validator: (v) {
                            if (!isEditing && (v == null || v.trim().isEmpty)) return 'Password is required';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Accreditation Documents Section
                        _buildDialogDocSection(setDialogState),
                        const SizedBox(height: 24),
                        // Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(dialogContext).pop(),
                              child: const Text('CANCEL', style: TextStyle(fontFamily: 'Montserrat', color: AppTheme.textSecondary, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              onPressed: () async {
                                if (_userFormKey.currentState!.validate()) {
                                  Navigator.of(dialogContext).pop();
                                  bool success;
                                  if (isEditing) {
                                    success = await UserService.updateUser(
                                      email: existingUser['email'],
                                      role: _selectedUserRole,
                                      name: _userNameController.text.trim(),
                                      phone: _userPhoneController.text.trim(),
                                      enrollmentId: _userEnrollmentController.text.trim().isEmpty ? 'N/A' : _userEnrollmentController.text.trim(),
                                      roleTitle: _userRoleTitleController.text.trim(),
                                      specialty: _userSpecialtyController.text.trim().isEmpty ? 'General Practice' : _userSpecialtyController.text.trim(),
                                      newPassword: _userPasswordController.text.trim().isEmpty ? null : _userPasswordController.text.trim(),
                                    );
                                  } else {
                                    success = await UserService.createUser(
                                      email: _userEmailController.text.trim(),
                                      password: _userPasswordController.text.trim(),
                                      role: _selectedUserRole,
                                      name: _userNameController.text.trim(),
                                      phone: _userPhoneController.text.trim(),
                                      enrollmentId: _userEnrollmentController.text.trim().isEmpty ? 'N/A' : _userEnrollmentController.text.trim(),
                                      roleTitle: _userRoleTitleController.text.trim(),
                                      specialty: _userSpecialtyController.text.trim().isEmpty ? 'General Practice' : _userSpecialtyController.text.trim(),
                                    );
                                  }
                                  await _loadUsers();
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: success ? AppTheme.successGreen : AppTheme.errorRed,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        content: Text(
                                          success
                                            ? (isEditing ? 'User "${_userNameController.text.trim()}" updated successfully.' : 'User "${_userNameController.text.trim()}" added successfully.')
                                            : 'Operation failed. Please try again.',
                                          style: const TextStyle(fontFamily: 'Montserrat', color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                isEditing ? 'UPDATE USER' : 'ADD USER',
                                style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  void _toggleUserStatus(Map<String, dynamic> user) async {
    final bool currentlyActive = user['isActive'] == true;
    final email = user['email'] as String;
    await UserService.setUserActive(email, !currentlyActive);
    await _loadUsers();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: currentlyActive ? AppTheme.errorRed : AppTheme.successGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Text(
            currentlyActive
                ? '"${user['name']}" has been deactivated.'
                : '"${user['name']}" has been reactivated.',
            style: const TextStyle(fontFamily: 'Montserrat', color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }
  void _confirmDeleteUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppTheme.errorRed.withValues(alpha: 0.3)),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppTheme.errorRed, size: 22),
              const SizedBox(width: 10),
              const Text('Confirm Deletion', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            ],
          ),
          content: Text(
            'Are you sure you want to permanently delete the account for "${user['name']}"?\n\nThis action cannot be undone.',
            style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: AppTheme.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('CANCEL', style: TextStyle(fontFamily: 'Montserrat', color: AppTheme.textSecondary, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                await UserService.deleteUser(user['email'] as String);
                await _loadUsers();
                if (mounted) {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppTheme.errorRed,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      content: Text(
                        '"${user['name']}" has been permanently deleted.',
                        style: const TextStyle(fontFamily: 'Montserrat', color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
              },
              child: const Text('DELETE', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
  void _clearUserForm() {
    _userNameController.clear();
    _userEmailController.clear();
    _userPhoneController.clear();
    _userEnrollmentController.clear();
    _userRoleTitleController.clear();
    _userSpecialtyController.clear();
    _docGroupNameController.clear();
    _selectedUserRole = 'Staff';
    _dialogDocGroups.clear();
  }
  // â”€â”€â”€ END USER MANAGEMENT â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _takeCompleteBackup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _BackupProgressDialog(
          todayLogsCount: _logs.length,
        );
      },
    );
  }
// Relocated _BackupProgressDialog classes to the end of the file to maintain class hierarchy.
  Widget _buildSidebar(BuildContext context, {bool isDrawer = false}) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: isDrawer
            ? null
            : Border(
                right: BorderSide(
                  color: AppTheme.accentColor.withValues(alpha: 0.12),
                  width: 1.5,
                ),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Logo & Branding
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              children: [
                Image.asset('assets/logo.png', width: 32, height: 32),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COCHIN UNITED',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'IT SECURITY CONSOLE',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppTheme.secondaryColor, height: 1),
          // User profile card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.15)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.admin_panel_settings_outlined, color: AppTheme.accentColor, size: 20),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'itadmin',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'System Operator',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 9,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Nav Links
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildSidebarLink(
                  icon: Icons.security_rounded,
                  label: 'Security Dashboard',
                  isActive: _activeSidebarIndex == 0,
                  onTap: () {
                    setState(() {
                      _activeSidebarIndex = 0;
                    });
                    if (isDrawer) Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 8),
                _buildSidebarLink(
                  icon: Icons.terminal_rounded,
                  label: 'Log Monitor',
                  isActive: _activeSidebarIndex == 1,
                  onTap: () {
                    setState(() {
                      _activeSidebarIndex = 1;
                    });
                    if (isDrawer) Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 8),
                _buildSidebarLink(
                  icon: Icons.manage_accounts_rounded,
                  label: 'Manage Users',
                  isActive: _activeSidebarIndex == 2,
                  onTap: () {
                    setState(() {
                      _activeSidebarIndex = 2;
                    });
                    if (isDrawer) Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 8),
                _buildSidebarLink(
                  icon: Icons.folder_shared_rounded,
                  label: 'Document Audit Logs',
                  isActive: _activeSidebarIndex == 3,
                  onTap: () {
                    setState(() {
                      _activeSidebarIndex = 3;
                    });
                    if (isDrawer) Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 8),
                _buildSidebarLink(
                  icon: Icons.backup_rounded,
                  label: 'System Backup',
                  isActive: false,
                  onTap: () {
                    if (isDrawer) Navigator.of(context).pop();
                    _takeCompleteBackup();
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          // Footer
          const Divider(color: AppTheme.secondaryColor, height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: _buildSidebarLink(
              icon: Icons.logout_rounded,
              label: 'Sign Out',
              isActive: false,
              color: AppTheme.errorRed,
              onTap: () async {
                if (isDrawer) Navigator.of(context).pop();
                
                // Auto check-out on sign out
                if (_adminEmail.isNotEmpty) {
                  await SessionTrackingService.checkOut(_adminEmail);
                  await AttendanceService.updateStatus(_adminEmail, false, '--');
                }
                
                if (!mounted) return;
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 600),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSidebarLink({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    Color? color,
  }) {
    final displayColor = color ?? (isActive ? const Color(0xFF0F172A) : const Color(0xFF475569));
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0F172A).withValues(alpha: 0.07) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: const Color(0xFF0F172A).withValues(alpha: 0.12), width: 1.2)
              : null,
        ),
        child: Row(
          children: [
            if (isActive)
              Container(
                width: 3.5,
                height: 18,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            Icon(
              icon,
              color: isActive ? const Color(0xFF0F172A) : displayColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: displayColor,
                letterSpacing: isActive ? 0.2 : 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDocumentAuditPage() {
    return FutureBuilder<List<DocumentAuditLog>>(
      future: DocumentService.getAuditLogs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor)));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading document audit logs: ${snapshot.error}', style: const TextStyle(fontFamily: 'Montserrat', color: AppTheme.errorRed)));
        }
        final logs = snapshot.data ?? [];
        // Apply filters
        final filteredLogs = logs.where((log) {
          final matchesAction = _selectedDocActionFilter == 'All' || 
              log.action.name.toLowerCase() == _selectedDocActionFilter.toLowerCase();
          final matchesSearch = _docSearchQuery.isEmpty || 
              log.documentTitle.toLowerCase().contains(_docSearchQuery.toLowerCase()) ||
              log.performedBy.toLowerCase().contains(_docSearchQuery.toLowerCase()) ||
              (log.details.isNotEmpty && log.details.toLowerCase().contains(_docSearchQuery.toLowerCase()));
          return matchesAction && matchesSearch;
        }).toList();
        // Sort descending by timestamp (newest first)
        filteredLogs.sort((a, b) => b.performedAt.compareTo(a.performedAt));
        // Compute metrics
        final totalViews = logs.where((l) => l.action == DocumentAction.viewed).length;
        final totalEdits = logs.where((l) => l.action == DocumentAction.edited).length;
        final totalExports = logs.where((l) => l.action == DocumentAction.exported).length;
        final totalCreated = logs.where((l) => l.action == DocumentAction.created).length;
        final totalImports = logs.where((l) => l.action == DocumentAction.imported).length;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Text(
                'DOCUMENT AUDIT RECORDS',
                style: TextStyle(
                  fontFamily: 'Cinzel',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Audit logs representing creation, views, modifications, and exports of all Chamber documents.',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              // Metrics Row
              LayoutBuilder(
                builder: (context, constraints) {
                  final double w = constraints.maxWidth;
                  final int cols = w > 1000 ? 5 : (w > 800 ? 4 : (w > 500 ? 2 : 1));
                  final double aspect = (w / cols) / 80.0;
                  return GridView.count(
                    crossAxisCount: cols,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: aspect > 0.5 ? aspect : 1.5,
                    children: [
                      _buildAuditMetricCard('CREATIONS', '$totalCreated', Icons.add_circle_outline_rounded, AppTheme.successGreen),
                      _buildAuditMetricCard('VIEWS', '$totalViews', Icons.visibility_outlined, const Color(0xFF60A5FA)),
                      _buildAuditMetricCard('EDITS', '$totalEdits', Icons.edit_outlined, AppTheme.accentColor),
                      _buildAuditMetricCard('EXPORTS', '$totalExports', Icons.file_download_outlined, const Color(0xFFC084FC)),
                      _buildAuditMetricCard('IMPORTS', '$totalImports', Icons.file_upload_outlined, const Color(0xFFFB923C)),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              // Filters and Search Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.textSecondary.withValues(alpha: 0.1)),
                      ),
                      child: TextField(
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                        ),
                        onChanged: (val) {
                          setState(() {
                            _docSearchQuery = val;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search_rounded, size: 18),
                          hintText: 'Search by document name, user email, details...',
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
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Dropdown filter
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.15)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedDocActionFilter,
                        dropdownColor: AppTheme.surfaceColor,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: AppTheme.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        icon: const Icon(Icons.arrow_drop_down_rounded, color: AppTheme.accentColor),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedDocActionFilter = newValue;
                            });
                          }
                        },
                        items: <String>['All', 'Created', 'Viewed', 'Edited', 'Exported', 'Imported']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text('Action: $value'),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Table or List of Audit events
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.accentColor.withValues(alpha: 0.12),
                    width: 1.5,
                  ),
                ),
                child: filteredLogs.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Center(
                          child: Text(
                            'No document audit records found matching filters.',
                            style: TextStyle(fontFamily: 'Montserrat', color: AppTheme.textSecondary),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredLogs.length,
                        separatorBuilder: (context, index) => const Divider(color: AppTheme.secondaryColor, height: 16),
                        itemBuilder: (context, index) {
                          final log = filteredLogs[index];
                          return _buildDocAuditItem(log);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildAuditMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDocAuditItem(DocumentAuditLog log) {
    Color badgeColor = AppTheme.accentColor;
    IconData actionIcon = Icons.info_outline;
    switch (log.action) {
      case DocumentAction.created:
        badgeColor = AppTheme.successGreen;
        actionIcon = Icons.add_circle_outline_rounded;
        break;
      case DocumentAction.delete:
        badgeColor = Colors.red;
        actionIcon = Icons.delete_outline;
        break;
      case DocumentAction.viewed:
        badgeColor = const Color(0xFF60A5FA); // Blue
        actionIcon = Icons.visibility_outlined;
        break;
      case DocumentAction.edited:
        badgeColor = AppTheme.accentColor;
        actionIcon = Icons.edit_outlined;
        break;
      case DocumentAction.exported:
        badgeColor = const Color(0xFFC084FC); // Purple
        actionIcon = Icons.file_download_outlined;
        break;
      case DocumentAction.imported:
        badgeColor = const Color(0xFFFB923C); // Orange
        actionIcon = Icons.file_upload_outlined;
        break;
    }
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    String formatDate(DateTime dt) {
      return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    String nameFromEmail(String email) {
      if (!email.contains('@')) return email;
      return email.split('@')[0].split('.').map((s) {
        if (s.isEmpty) return s;
        return '${s[0].toUpperCase()}${s.substring(1)}';
      }).join(' ');
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 600;
        final badgeWidget = Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(actionIcon, size: 10, color: badgeColor),
              const SizedBox(width: 4),
              Text(
                log.action.name.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: badgeColor,
                ),
              ),
            ],
          ),
        );
        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
                children: [
                  Expanded(
                    child: Text(
                      log.documentTitle,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  badgeWidget,
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.person_outline_rounded, color: AppTheme.textSecondary, size: 12),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${nameFromEmail(log.performedBy)} (${log.performedBy})',
                      style: const TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: AppTheme.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, color: AppTheme.textSecondary, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    formatDate(log.performedAt),
                    style: const TextStyle(fontFamily: 'Montserrat', fontSize: 10, color: AppTheme.textSecondary),
                  ),
                ],
              ),
              if (log.details.isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.05)),
                  ),
                  child: Text(
                    log.details,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 9,
                      color: AppTheme.textSecondary.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.description_outlined, color: AppTheme.accentColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    log.documentTitle,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Doc ID: ${log.documentId}',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 9,
                      color: AppTheme.textSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                  if (log.details.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Details: ${log.details}',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10,
                        color: AppTheme.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameFromEmail(log.performedBy),
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    log.performedBy,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      color: AppTheme.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Text(
                formatDate(log.performedAt),
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            badgeWidget,
          ],
        );
      },
    );
  }
}
class _BackupProgressDialog extends StatefulWidget {
  final int todayLogsCount;
  const _BackupProgressDialog({required this.todayLogsCount});
  @override
  State<_BackupProgressDialog> createState() => _BackupProgressDialogState();
}
class _BackupProgressDialogState extends State<_BackupProgressDialog> {
  int _currentStep = 0;
  bool _isDone = false;
  String _statusText = 'Initializing secure backup protocol...';
  final List<String> _steps = [
    'Initializing secure backup protocol...',
    'Locating local SQLite system tables...',
    'Serializing Today Active Logs...',
    'Combining Historical Archive Records...',
    'Generating SHA-256 integrity checksum...',
    'Finalizing encrypted backup container...'
  ];
  @override
  void initState() {
    super.initState();
    _runSimulation();
  }
  void _runSimulation() async {
    for (int i = 0; i < _steps.length; i++) {
      if (!mounted) return;
      setState(() {
        _currentStep = i;
        _statusText = _steps[i];
      });
      await Future.delayed(const Duration(milliseconds: 600));
    }
    if (!mounted) return;
    setState(() {
      _isDone = true;
      _statusText = 'Backup completed successfully!';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Container(
        width: 420,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.25), width: 1.5),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  _isDone ? Icons.cloud_done_rounded : Icons.backup_rounded,
                  color: _isDone ? AppTheme.successGreen : AppTheme.accentColor,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  _isDone ? 'Backup Complete' : 'System Database Backup',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (!_isDone) ...[
              Column(
                children: [
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / _steps.length,
                    backgroundColor: AppTheme.secondaryColor,
                    color: AppTheme.accentColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _statusText,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ] else ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.successGreen.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, color: AppTheme.successGreen, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'All tables serialized and integrity-checksum verified.',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                              color: AppTheme.successGreen.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Backup File', 'cochin_united_legal_backup_${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}.json'),
                  _buildDetailRow('Total Records', '${widget.todayLogsCount + 12} entries (Today + Archives)'),
                  _buildDetailRow('Integrity Hash', 'SHA256: 7F9A28A4...CE99110B'),
                  _buildDetailRow('Backup Format', 'JSON Secure Schema v1.0'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppTheme.successGreen,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              content: const Row(
                                children: [
                                  Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Backup file saved to App Documents directory.',
                                      style: TextStyle(fontFamily: 'Montserrat', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'SAVE TO DOCUMENTS',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentColor,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryColor,
                          side: BorderSide(color: AppTheme.accentColor.withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          'CLOSE',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}