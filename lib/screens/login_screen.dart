import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'admin_dashboard.dart';
import 'manager_dashboard.dart';
import 'forgot_password_screen.dart' hide MeshGradientPainter;
import 'staff_dashboard.dart';
import 'client_dashboard.dart';
import '../services/auth_service.dart';
import '../services/session_tracking_service.dart';
import '../services/attendance_service.dart';
import '../services/logging_service.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
    _bgController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });
    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _rememberMe = prefs.getBool('remember_me') ?? false;
        if (_rememberMe) {
          _emailController.text = prefs.getString('saved_email') ?? '';
        }
      });
    } catch (_) {}
  }

  Future<void> _saveCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setBool('remember_me', true);
        await prefs.setString('saved_email', _emailController.text.trim());
      } else {
        await prefs.setBool('remember_me', false);
        await prefs.remove('saved_email');
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _bgController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _saveCredentials();
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim().toLowerCase();
      final password = _passwordController.text;

      // Authenticate via Supabase
      final userRecord = await AuthService.login(email, password);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (userRecord == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.errorRed,
            duration: const Duration(seconds: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.white),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Incorrect password, or account is UNVERIFIED. Check your email for a code.',
                    style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    _showVerificationDialog(email);
                  },
                  child: const Text('VERIFY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
        return;
      }

      final role = userRecord['role'] as String;

      // Ensure user details are set in SharedPreferences for subsequent Logging
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      await prefs.setString('user_role', role);

      // Log successful login to Central Audit
      await LoggingService().logAction(
        action: 'Login Successful',
        targetType: 'System Access',
        details: 'User authenticated with role: $role',
      );

      // Auto check-in: record exact login time for attendance
      final now = DateTime.now();
      final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? "PM" : "AM"}';
      await SessionTrackingService.checkIn(email);
      await AttendanceService.updateStatus(email, true, timeStr);

      if (!mounted) return;

      if (role == 'Admin') {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const AdminDashboard(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      } else if (role == 'Manager') {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ManagerDashboard(
              userEmail: email,
              userRole: role,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      } else if (role == 'Client') {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ClientDashboardScreen(
              clientEmail: email,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => StaffDashboard(
              userEmail: email,
              userRole: role,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    }
  }

  void _showVerificationDialog(String email) {
    final codeCtrl = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        title: const Text('Verify Email', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'A verification code was sent to your email when the account was created. Please enter it here.',
              style: TextStyle(color: Color(0xFF475569), fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: codeCtrl,
              style: const TextStyle(color: Color(0xFF0F172A), letterSpacing: 4, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: '000000',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1.5),
                ),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Amplify.Auth.resendSignUpCode(username: email);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification code resent!'), backgroundColor: Color(0xFF0F172A)));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to resend: $e'), backgroundColor: Colors.red));
                }
              }
            },
            child: const Text('Resend Code', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              if (codeCtrl.text.isEmpty) return;
              try {
                await Amplify.Auth.confirmSignUp(username: email, confirmationCode: codeCtrl.text.trim());
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verified! Please log in now.'), backgroundColor: Colors.green));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification Failed: $e'), backgroundColor: Colors.red));
                }
              }
            },
            child: const Text('Verify', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  bool _isHoveringButton = false;

  void _showSetupAdminDialog() {
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        title: const Text('Create Admin/Manager (Setup)', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Use a real email to get the verification code!', style: TextStyle(color: Color(0xFF475569))),
            const SizedBox(height: 16),
            TextField(
              controller: emailCtrl,
              style: const TextStyle(color: Color(0xFF0F172A)),
              decoration: const InputDecoration(
                hintText: 'Real Email',
                hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: Color(0xFFF8FAFC),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordCtrl,
              style: const TextStyle(color: Color(0xFF0F172A)),
              decoration: const InputDecoration(
                hintText: 'Password (e.g. Admin@123)',
                hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: Color(0xFFF8FAFC),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await Amplify.Auth.signUp(
                  username: emailCtrl.text.trim().toLowerCase(),
                  password: passwordCtrl.text,
                  options: SignUpOptions(userAttributes: {AuthUserAttributeKey.email: emailCtrl.text.trim().toLowerCase(), AuthUserAttributeKey.name: 'Setup Manager'}),
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created successfully! You can now log in.')));
                }
              } catch (_) {}
            },
            child: const Text('Create & Send Code', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;
    final isTablet = size.width >= 600 && size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Stack(
        children: [
          // 1. Executive Slate & Ambient Gold Canvas Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF9FAFC), // Ultra-clean Pristine Slate
                    Color(0xFFEEF2F6), // Soft Ambient Grey
                  ],
                ),
              ),
            ),
          ),

          // 2. Architectural Grid & Golden Corner Framing Canvas
          Positioned.fill(
            child: CustomPaint(
              painter: LegalBackgroundGridPainter(),
            ),
          ),

          // 3. Top-Left Soft Warm Gold Light Reflection
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              width: 450,
              height: 450,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFD4AF37).withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 4. Bottom-Right Ambient Obsidian Depth Glow
          Positioned(
            bottom: -140,
            right: -140,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF0F172A).withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 5. Soft Central Dual-Tone Ambient Aura Behind Card
          Center(
            child: Container(
              width: isDesktop ? 980 : 480,
              height: isDesktop ? 660 : 560,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFD4AF37).withValues(alpha: 0.07),
                    const Color(0xFF0F172A).withValues(alpha: 0.03),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),

          // 6. Dual-Tone Top Accent Bar (Obsidian & Gold Hairline)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 3.5,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0F172A),
                    Color(0xFFD4AF37),
                    Color(0xFF0F172A),
                  ],
                ),
              ),
            ),
          ),

          // 7. Main Centered Executive Luxury Card
          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 40 : (isTablet ? 32 : 20),
                vertical: isDesktop ? 48 : (isTablet ? 36 : 24),
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 960 : 440,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.12),
                      blurRadius: 55,
                      spreadRadius: 0,
                      offset: const Offset(0, 18),
                    ),
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.08),
                      blurRadius: 32,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                    ),
                    child: isDesktop
                        ? Row(
                            children: [
                              // Left Hero / Brand Panel
                              Expanded(
                                flex: 11,
                                child: _buildDesktopHeroPanel(),
                              ),
                              // Vertical Hairline Separator Line
                              Container(
                                width: 1,
                                height: 530,
                                color: const Color(0xFFE2E8F0),
                              ),
                              // Right Form Panel
                              Expanded(
                                flex: 12,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 44,
                                    vertical: 48,
                                  ),
                                  child: _buildFormContent(isDesktop: true),
                                ),
                              ),
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 36 : 28,
                              vertical: isTablet ? 40 : 32,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildMobileHeader(),
                                const SizedBox(height: 28),
                                _buildFormContent(isDesktop: false),
                              ],
                            ),
                          ),
                  ),
                ),
              ).animate().fadeIn(duration: 600.ms, curve: Curves.easeOutCubic).scale(
                    begin: const Offset(0.98, 0.98),
                    end: const Offset(1.0, 1.0),
                    curve: Curves.easeOutCubic,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  /// Desktop Left Hero Panel with gold-accented legal branding & badges
  Widget _buildDesktopHeroPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFD), // Off-White Tint
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo inside clean white container with gold double-ring border
          GestureDetector(
            onDoubleTap: _showSetupAdminDialog,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFD4AF37),
                  width: 1.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.16),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/logo.png',
                width: 68,
                height: 68,
                fit: BoxFit.contain,
              ),
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 500.ms),

          const SizedBox(height: 28),

          // Deep Black Cormorant Garamond Title
          Text(
            'COCHIN UNITED\nLEGAL LLP',
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: 5.0,
              height: 1.25,
              color: const Color(0xFF0F172A),
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

          const SizedBox(height: 12),

          // Subtitle
          const Text(
            'ADVOCATES & LEGAL CONSULTANTS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 3.8,
              color: Color(0xFF64748B),
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

          const SizedBox(height: 24),

          // Gold-Trimmed Diamond Separator Line
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 1,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Color(0xFFD4AF37)],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.diamond,
                  size: 9,
                  color: Color(0xFFD4AF37),
                ),
              ),
              Container(
                width: 50,
                height: 1,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFD4AF37), Colors.transparent],
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 350.ms, duration: 400.ms),

          const SizedBox(height: 24),

          // Firm Quote / Motto Statement
          Text(
            '"Distinction in Law.\nUnwavering Integrity."',
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 16.5,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
              letterSpacing: 0.8,
              height: 1.4,
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

          const SizedBox(height: 36),

          // Security Badges with subtle gold tint icon
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildFeatureBadge(Icons.shield_outlined, '256-Bit Encryption'),
              _buildFeatureBadge(Icons.gavel_outlined, 'Enterprise Access'),
            ],
          ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
        ],
      ),
    );
  }

  Widget _buildFeatureBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFFD4AF37)),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  /// Header for mobile & tablet layout
  Widget _buildMobileHeader() {
    return Column(
      children: [
        GestureDetector(
          onDoubleTap: _showSetupAdminDialog,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFD4AF37),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.12),
                  blurRadius: 14,
                )
              ],
            ),
            child: Image.asset(
              'assets/logo.png',
              width: 56,
              height: 56,
              fit: BoxFit.contain,
            ),
          ),
        ).animate().fadeIn(delay: 100.ms, duration: 500.ms),

        const SizedBox(height: 18),

        Text(
          'COCHIN UNITED LEGAL LLP',
          textAlign: TextAlign.center,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 3.5,
            color: const Color(0xFF0F172A),
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

        const SizedBox(height: 6),

        const Text(
          'ADVOCATES & LEGAL CONSULTANTS',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 8.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.8,
            color: Color(0xFF64748B),
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
      ],
    );
  }

  /// Form content shared between desktop and mobile layouts
  Widget _buildFormContent({required bool isDesktop}) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section Title Header Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                ),
                child: const Icon(
                  Icons.lock_person_outlined,
                  size: 15,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Sign In to Enterprise Portal',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ).animate().fadeIn(delay: isDesktop ? 150.ms : 350.ms, duration: 400.ms),

          const SizedBox(height: 24),

          // Email Input
          _buildInputLabel('EMAIL ADDRESS / USERNAME'),
          const SizedBox(height: 8),
          _buildMinimalInput(
            controller: _emailController,
            focusNode: _emailFocusNode,
            isFocused: _isEmailFocused,
            hint: 'name@cochinunited.com',
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email address or username';
              }
              if (value.contains('@') && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ).animate().fadeIn(delay: isDesktop ? 250.ms : 400.ms, duration: 400.ms),

          const SizedBox(height: 20),

          // Password Input
          _buildInputLabel('PASSWORD'),
          const SizedBox(height: 8),
          _buildMinimalInput(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            isFocused: _isPasswordFocused,
            hint: '••••••••••••',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFF64748B),
                size: 18,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ).animate().fadeIn(delay: isDesktop ? 300.ms : 450.ms, duration: 400.ms),

          const SizedBox(height: 18),

          // Remember Me & Forgot Password Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _rememberMe = !_rememberMe;
                  });
                },
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 18,
                        width: 18,
                        child: Checkbox(
                          value: _rememberMe,
                          activeColor: const Color(0xFF0F172A),
                          checkColor: Colors.white,
                          side: const BorderSide(
                            color: Color(0xFF94A3B8),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Remember me',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          color: Color(0xFF475569),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const ForgotPasswordScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 400),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0F172A),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: isDesktop ? 350.ms : 500.ms, duration: 400.ms),

          const SizedBox(height: 32),

          // Sign In Action Button (Jet Black Gradient with Gold Rim Accent)
          _buildLoginButton(isDesktop: isDesktop).animate().fadeIn(delay: isDesktop ? 400.ms : 550.ms, duration: 400.ms).slideY(begin: 0.06, end: 0),

          const SizedBox(height: 24),

          // Footer Security Assurance
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.verified_user_outlined,
                size: 12,
                color: Color(0xFF64748B),
              ),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Protected by Enterprise Access Security',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: isDesktop ? 450.ms : 600.ms, duration: 400.ms),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        color: Color(0xFF334155),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildMinimalInput({
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool isFocused,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    Widget? suffixIcon,
    void Function(String)? onFieldSubmitted,
    String? Function(String?)? validator,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.white, // Pure White Fill
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFocused
              ? const Color(0xFF0F172A) // Solid Black Focus Border
              : const Color(0xFFE2E8F0), // Light Grey Border
          width: isFocused ? 1.5 : 1.0,
        ),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.18),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        style: const TextStyle(
          color: Color(0xFF0F172A), // Dark Charcoal Text
          fontSize: 13.5,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        ),
        cursorColor: const Color(0xFF0F172A),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 14, right: 12),
            child: Icon(
              icon,
              color: isFocused
                  ? const Color(0xFFD4AF37) // Subtle Gold Focus Tint
                  : const Color(0xFF64748B),
              size: 18,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: suffixIcon,
                )
              : null,
          suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          filled: false,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 13,
            fontFamily: 'Montserrat',
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildLoginButton({required bool isDesktop}) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHoveringButton = true),
      onExit: (_) => setState(() => _isHoveringButton = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 52,
        transform: Matrix4.translationValues(0, _isHoveringButton && !_isLoading ? -2.5 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: _isLoading
              ? null
              : LinearGradient(
                  colors: _isHoveringButton
                      ? const [Color(0xFF1E293B), Color(0xFF0F172A)]
                      : const [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          border: Border.all(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
            width: 1.0,
          ),
          color: _isLoading ? const Color(0xFF64748B) : null,
          boxShadow: _isLoading
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withValues(
                      alpha: _isHoveringButton ? 0.25 : 0.12,
                    ),
                    blurRadius: _isHoveringButton ? 20 : 12,
                    spreadRadius: _isHoveringButton ? 1 : 0,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(
                      alpha: _isHoveringButton ? 0.35 : 0.22,
                    ),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: EdgeInsets.zero,
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'SIGN IN TO PORTAL',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.2,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xFFD4AF37), // Subtle Gold Arrow Accent
                      size: 17,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Custom painter that renders a delicate architectural grid and gold corner frames for the background
class LegalBackgroundGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF0F172A).withValues(alpha: 0.025)
      ..strokeWidth = 1.0;

    final goldPaint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.18)
      ..strokeWidth = 1.2;

    const double step = 64;

    // Draw vertical architectural grid lines
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Draw horizontal architectural grid lines
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw subtle golden corner framing accents
    const double frameMargin = 28;
    const double frameSize = 24;

    // Top-Left Frame Corner
    canvas.drawLine(const Offset(frameMargin, frameMargin), const Offset(frameMargin + frameSize, frameMargin), goldPaint);
    canvas.drawLine(const Offset(frameMargin, frameMargin), const Offset(frameMargin, frameMargin + frameSize), goldPaint);

    // Top-Right Frame Corner
    canvas.drawLine(Offset(size.width - frameMargin, frameMargin), Offset(size.width - frameMargin - frameSize, frameMargin), goldPaint);
    canvas.drawLine(Offset(size.width - frameMargin, frameMargin), Offset(size.width - frameMargin, frameMargin + frameSize), goldPaint);

    // Bottom-Left Frame Corner
    canvas.drawLine(Offset(frameMargin, size.height - frameMargin), Offset(frameMargin + frameSize, size.height - frameMargin), goldPaint);
    canvas.drawLine(Offset(frameMargin, size.height - frameMargin), Offset(frameMargin, size.height - frameMargin - frameSize), goldPaint);

    // Bottom-Right Frame Corner
    canvas.drawLine(Offset(size.width - frameMargin, size.height - frameMargin), Offset(size.width - frameMargin - frameSize, size.height - frameMargin), goldPaint);
    canvas.drawLine(Offset(size.width - frameMargin, size.height - frameMargin), Offset(size.width - frameMargin, size.height - frameMargin - frameSize), goldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}




