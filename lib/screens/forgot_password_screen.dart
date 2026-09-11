import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../services/auth_service.dart';

import '../theme/app_theme.dart';
import '../widgets/starfield.dart';
import '../config/smtp_config.dart';
import '../widgets/responsive.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  
  // Stages: 
  // 0 = Request OTP (Enter Email)
  // 1 = Verify OTP (Enter 6-digit Code)
  // 2 = Reset Password (Enter New Password)
  // 3 = Success Screen
  int _currentStage = 0;

  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isConfirmPasswordFocused = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // OTP Fields State
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  final List<bool> _otpFocused = List.generate(6, (_) => false);

  String _generatedOtp = '';
  String _targetEmail = '';
  bool _isLoading = false;

  // Resend OTP Code Cooldown Timer
  Timer? _cooldownTimer;
  int _cooldownSecondsRemaining = 0;

  // Developer mode bypass variables
  bool _smtpFailed = false;
  String _smtpErrorMessage = '';

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _emailFocus.addListener(() {
      setState(() => _isEmailFocused = _emailFocus.hasFocus);
    });
    _passwordFocus.addListener(() {
      setState(() => _isPasswordFocused = _passwordFocus.hasFocus);
    });
    _confirmPasswordFocus.addListener(() {
      setState(() => _isConfirmPasswordFocused = _confirmPasswordFocus.hasFocus);
    });

    for (int i = 0; i < 6; i++) {
      _otpFocusNodes[i].addListener(() {
        setState(() => _otpFocused[i] = _otpFocusNodes[i].hasFocus);
      });
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _cooldownTimer?.cancel();

    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    setState(() {
      _cooldownSecondsRemaining = 60; // 1-minute cooldown
    });
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_cooldownSecondsRemaining > 0) {
          _cooldownSecondsRemaining--;
        } else {
          _cooldownTimer?.cancel();
        }
      });
    });
  }

  // Generate a random 6-digit OTP
  String _generateOtpCode() {
    final rand = math.Random();
    final otpVal = 100000 + rand.nextInt(900000);
    return otpVal.toString();
  }

  // Send email function using mailer package
  Future<bool> _sendOtpEmail(String email, String otp) async {
    if (!SmtpConfig.isConfigured) {
      setState(() {
        _smtpFailed = true;
        _smtpErrorMessage = 'SMTP Sender or App Password not configured in smtp_config.dart.';
      });
      return false;
    }

    final smtpServer = gmail(SmtpConfig.gmailSenderEmail, SmtpConfig.gmailAppPassword);

    final message = Message()
      ..from = Address(SmtpConfig.gmailSenderEmail, 'Cochin United Legal LLP')
      ..recipients.add(email)
      ..subject = 'Cochin United Legal LLP - Password Reset Verification Code'
      ..html = """
      <div style="background-color: #09090a; color: #f1f5f9; padding: 40px; font-family: 'Montserrat', 'Arial', sans-serif; border: 1.5px solid #dfba73; border-radius: 12px; max-width: 600px; margin: auto;">
        <h2 style="font-family: 'Cinzel', 'Garamond', serif; color: #dfba73; border-bottom: 1.5px solid #dfba73; padding-bottom: 15px; text-align: center; letter-spacing: 3px; font-weight: bold; margin-bottom: 25px;">COCHIN UNITED LEGAL LLP</h2>
        <p style="font-size: 16px; line-height: 1.6; color: #f1f5f9;">Dear Client / Advocate,</p>
        <p style="font-size: 15px; line-height: 1.6; color: #94a3b8;">We received a request to reset your password for the Cochin United Legal LLP Secure Chamber Portal. Please use the following One-Time Password (OTP) to complete the verification process:</p>
        
        <div style="background-color: #161618; border: 1px solid rgba(223, 186, 115, 0.3); border-radius: 8px; padding: 25px; text-align: center; margin: 30px 0; box-shadow: 0 4px 12px rgba(0,0,0,0.5);">
          <span style="font-size: 36px; font-weight: bold; letter-spacing: 8px; color: #dfba73; font-family: monospace;">$otp</span>
        </div>
        
        <p style="font-size: 13px; color: #94a3b8; line-height: 1.6;">This verification code is active for <strong>10 minutes</strong>. For security purposes, do not share this OTP with anyone.</p>
        <p style="font-size: 13px; color: #ef4444; line-height: 1.6; font-weight: 500;">If you did not request this change, please ignore this email or contact the administrator immediately.</p>
        
        <hr style="border: 0; border-top: 1px solid rgba(223, 186, 115, 0.15); margin: 35px 0;">
        <p style="font-size: 11px; text-align: center; color: #94a3b8; letter-spacing: 1px;">COCHIN UNITED LEGAL LLP &copy; 2026</p>
      </div>
      """;

    try {
      await send(message, smtpServer);
      setState(() {
        _smtpFailed = false;
        _smtpErrorMessage = '';
      });
      return true;
    } catch (e) {
      setState(() {
        _smtpFailed = true;
        _smtpErrorMessage = e.toString();
      });
      return false;
    }
  }

  // Action: Trigger sending OTP
  Future<void> _handleSendOtp() async {
    if (_emailFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _smtpFailed = false;
        _smtpErrorMessage = '';
      });

      _targetEmail = _emailController.text.trim();
      _generatedOtp = _generateOtpCode();

      // Clear previous OTP entries
      for (var controller in _otpControllers) {
        controller.clear();
      }

      final success = await _sendOtpEmail(_targetEmail, _generatedOtp);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.successGreen,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Verification code sent successfully to $_targetEmail',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        _startCooldownTimer();
        setState(() {
          _currentStage = 1; // Advance to OTP verification
        });
      } else {
        // SMTP Send Failed - Trigger bypass modal/dialog
        _showDeveloperBypassDialog();
      }
    }
  }

  // Developer Bypass Dialog containing the OTP
  void _showDeveloperBypassDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: AppTheme.surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: AppTheme.accentColor.withAlpha(80), width: 1.5),
            ),
            title: Row(
              children: [
                const Icon(Icons.bug_report_rounded, color: AppTheme.accentColor),
                const SizedBox(width: 12),
                const Text(
                  'SMTP Test Portal',
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SMTP mail dispatch was unsuccessful or is unconfigured. This is normal for local-only builds or when credentials are not yet updated in lib/config/smtp_config.dart.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(60),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.errorRed.withAlpha(60)),
                  ),
                  child: Text(
                    'Error: $_smtpErrorMessage',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: AppTheme.errorRed,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'DEVELOPER BYPASS CODE (OTP)',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppTheme.accentColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.accentColor, width: 1),
                    ),
                    child: Text(
                      _generatedOtp,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 6,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startCooldownTimer();
                  setState(() {
                    _currentStage = 1; // Proceed to verification stage using bypass OTP
                  });
                },
                child: const Text(
                  'COPY & CONTINUE',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Action: Verify entered OTP digits
  void _handleVerifyOtp() {
    String enteredOtp = _otpControllers.map((c) => c.text).join();
    if (enteredOtp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.errorRed,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Text(
            'Please enter the full 6-digit verification code.',
            style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
          ),
        ),
      );
      return;
    }

    if (enteredOtp == _generatedOtp) {
      setState(() {
        _currentStage = 2; // Proceed to reset password stage
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.errorRed,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Text(
            'Invalid verification code. Please check and try again.',
            style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
          ),
        ),
      );
    }
  }

  // Action: Update password via Supabase
  Future<void> _handleResetPassword() async {
    if (_passwordFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Update password via Supabase
      final success = await AuthService.updatePassword(
        _targetEmail.toLowerCase(), 
        _passwordController.text
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (success) {
            _currentStage = 3; // Advance to success stage
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppTheme.errorRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                content: const Text(
                  'Failed to update password. Ensure email exists.',
                  style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
                ),
              ),
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      body: Stack(
        children: [
          // Elegant Animated Mesh Gradient Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _hoverController,
              builder: (context, child) {
                return CustomPaint(
                  painter: MeshGradientPainter(_hoverController.value),
                );
              },
            ),
          ),
          Positioned.fill(
            child: Starfield(animation: _hoverController),
          ),
          
          // Back Button top left
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () {
                if (_currentStage == 1) {
                  setState(() => _currentStage = 0);
                } else if (_currentStage == 2) {
                  setState(() => _currentStage = 1);
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ).animate().fade(duration: 400.ms),

          // Centered Unified Glass Card
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: isMobile ? 24 : 40,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? 380 : 460,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 24 : 40,
                        vertical: isMobile ? 32 : 48,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: AppTheme.textSecondary.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withAlpha((0.08 * 255).round()),
                            blurRadius: 40,
                            spreadRadius: 5,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildPremiumBranding(isMobile),
                          const SizedBox(height: 32),
                          _buildActiveStageView(isDesktop: !isMobile),
                        ],
                      ),
                    ),
                  ),
                ),
              ).animate().fade(duration: 800.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), curve: Curves.easeOutCubic),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBranding(bool isMobile) {
    return Column(
      children: [
        // Premium Glow Logo
        Container(
          width: isMobile ? 80 : 100,
          height: isMobile ? 80 : 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentColor.withAlpha((0.15 * 255).round()),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
          ),
        ).animate().fade(delay: 200.ms, duration: 600.ms).scale(curve: Curves.easeOutBack),
        
        const SizedBox(height: 24),
        
        // Brand Title
        Text(
          'COCHIN UNITED\nLEGAL LLP',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cinzel',
            fontFamilyFallback: const ['Garamond', 'Times New Roman', 'serif'],
            fontSize: isMobile ? 22 : 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            height: 1.2,
            color: AppTheme.textPrimary,
          ),
        ).animate().fade(delay: 300.ms, duration: 600.ms).slideY(begin: 0.1, end: 0),
        
        const SizedBox(height: 8),
        
        // Subtitle
        Text(
          'ADVOCATES & LEGAL CONSULTANTS',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontFamilyFallback: const ['Arial', 'sans-serif'],
            fontSize: isMobile ? 9 : 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.5,
            color: AppTheme.textSecondary,
          ),
        ).animate().fade(delay: 400.ms, duration: 600.ms).slideY(begin: 0.1, end: 0),
      ],
    );
  }

  Widget _buildActiveStageView({required bool isDesktop}) {
    switch (_currentStage) {
      case 0:
        return _buildRequestOtpStage(isDesktop);
      case 1:
        return _buildVerifyOtpStage(isDesktop);
      case 2:
        return _buildResetPasswordStage(isDesktop);
      case 3:
        return _buildSuccessStage(isDesktop);
      default:
        return _buildRequestOtpStage(isDesktop);
    }
  }

  // --- STAGE 0: REQUEST OTP ---
  Widget _buildRequestOtpStage(bool isDesktop) {
    return Form(
      key: _emailFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Forgot Password',
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
              letterSpacing: 0.5,
            ),
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          ).animate().fade().slideY(begin: 0.1, end: 0),
          const SizedBox(height: 8),
          Text(
            'Enter your registered email below to receive a secure OTP code.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          ).animate().fade(delay: 100.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 36),

          // Email Input field with premium glowing borders
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isEmailFocused
                  ? [
                      BoxShadow(
                        color: AppTheme.accentColor.withAlpha((0.15 * 255).round()),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: TextFormField(
              controller: _emailController,
              focusNode: _emailFocus,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleSendOtp(),
              decoration: const InputDecoration(
                labelText: 'Registered Email Address',
                prefixIcon: Icon(Icons.alternate_email_rounded),
                hintText: 'advocate@cochinunited.com',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
          ).animate().fade(delay: 200.ms).slideX(begin: 0.05, end: 0),
          const SizedBox(height: 36),

          // Send OTP Button
          _buildButton(
            text: 'SEND VERIFICATION CODE',
            onPressed: _handleSendOtp,
            loading: _isLoading,
          ).animate().fade(delay: 300.ms).scale(begin: const Offset(0.97, 0.97), end: const Offset(1, 1)),
          
          const SizedBox(height: 20),
          
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Back to Sign In',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ).animate().fade(delay: 400.ms),
        ],
      ),
    );
  }

  // --- STAGE 1: VERIFY OTP ---
  Widget _buildVerifyOtpStage(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Enter OTP',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
            letterSpacing: 0.5,
          ),
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
        ).animate().fade().slideY(begin: 0.1, end: 0),
        const SizedBox(height: 8),
        RichText(
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              const TextSpan(text: 'We sent a verification code to '),
              TextSpan(
                text: _targetEmail,
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accentColor),
              ),
              const TextSpan(text: '. Enter the code below.'),
            ],
          ),
        ).animate().fade(delay: 100.ms).slideY(begin: 0.1, end: 0),
        
        // Show indicator if developer mode was activated
        if (_smtpFailed) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentColor.withAlpha(60), width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: AppTheme.accentColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Demo Environment Bypass Active',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: _showDeveloperBypassDialog,
                        child: const Text(
                          'Click here to retrieve your mock OTP verification code.',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().shake(duration: 800.ms),
        ],

        const SizedBox(height: 36),

        // OTP 6 digit inputs row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: isDesktop ? 52 : 44,
              height: isDesktop ? 60 : 52,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _otpFocused[index]
                      ? [
                          BoxShadow(
                            color: AppTheme.accentColor.withAlpha((0.15 * 255).round()),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: TextFormField(
                  controller: _otpControllers[index],
                  focusNode: _otpFocusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: _otpControllers[index].text.isNotEmpty
                            ? AppTheme.accentColor.withAlpha(150)
                            : AppTheme.textSecondary.withAlpha(30),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppTheme.accentColor, width: 1.5),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      if (index < 5) {
                        _otpFocusNodes[index + 1].requestFocus();
                      } else {
                        _otpFocusNodes[index].unfocus();
                        _handleVerifyOtp();
                      }
                    } else {
                      if (index > 0) {
                        _otpFocusNodes[index - 1].requestFocus();
                      }
                    }
                    setState(() {}); // refresh border highlight state
                  },
                ),
              ),
            );
          }),
        ).animate().fade(delay: 200.ms).slideY(begin: 0.05, end: 0),
        const SizedBox(height: 36),

        // Verify OTP Button
        _buildButton(
          text: 'VERIFY CODE',
          onPressed: _handleVerifyOtp,
          loading: false,
        ).animate().fade(delay: 300.ms),

        const SizedBox(height: 24),

        // Resend section
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Didn't receive the email?",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            TextButton(
              onPressed: _cooldownSecondsRemaining > 0
                  ? null
                  : () {
                      _handleSendOtp();
                    },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.accentColor,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                _cooldownSecondsRemaining > 0
                    ? 'Resend in ${_cooldownSecondsRemaining}s'
                    : 'Resend OTP',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: _cooldownSecondsRemaining > 0
                      ? AppTheme.textSecondary.withAlpha(120)
                      : AppTheme.accentColor,
                ),
              ),
            ),
          ],
        ).animate().fade(delay: 400.ms),
      ],
    );
  }

  // --- STAGE 2: RESET PASSWORD ---
  Widget _buildResetPasswordStage(bool isDesktop) {
    return Form(
      key: _passwordFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'New Password',
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
              letterSpacing: 0.5,
            ),
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          ).animate().fade().slideY(begin: 0.1, end: 0),
          const SizedBox(height: 8),
          Text(
            'Create a new strong password for securing your access.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          ).animate().fade(delay: 100.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 36),

          // Password Field
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isPasswordFocused
                  ? [
                      BoxShadow(
                        color: AppTheme.accentColor.withAlpha((0.15 * 255).round()),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: TextFormField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a new password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
          ).animate().fade(delay: 200.ms).slideX(begin: 0.05, end: 0),
          const SizedBox(height: 20),

          // Confirm Password Field
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isConfirmPasswordFocused
                  ? [
                      BoxShadow(
                        color: AppTheme.accentColor.withAlpha((0.15 * 255).round()),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: TextFormField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocus,
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleResetPassword(),
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_reset_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  ),
                  onPressed: () {
                    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ).animate().fade(delay: 300.ms).slideX(begin: 0.05, end: 0),
          const SizedBox(height: 36),

          // Reset Button
          _buildButton(
            text: 'UPDATE PASSWORD',
            onPressed: _handleResetPassword,
            loading: _isLoading,
          ).animate().fade(delay: 400.ms),
        ],
      ),
    );
  }

  // --- STAGE 3: SUCCESS SCREEN ---
  Widget _buildSuccessStage(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.successGreen, width: 2),
              color: AppTheme.successGreen.withAlpha(25),
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: AppTheme.successGreen,
              size: 48,
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        ),
        const SizedBox(height: 28),
        Text(
          'Success!',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ).animate().fade(delay: 200.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 12),
        Text(
          'Your password has been successfully reset. You can now use your new password to sign in.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ).animate().fade(delay: 300.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 40),

        // Back to Login Button
        _buildButton(
          text: 'BACK TO SIGN IN',
          onPressed: () {
            Navigator.of(context).pop();
          },
          loading: false,
        ).animate().fade(delay: 450.ms),
      ],
    );
  }

  // Golden Gradient Shimmer Button
  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required bool loading,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: loading ? null : AppTheme.goldGradient,
        color: loading ? AppTheme.secondaryColor : null,
        borderRadius: BorderRadius.circular(12),
        boxShadow: loading
            ? null
            : [
                BoxShadow(
                  color: AppTheme.accentColor.withAlpha((0.3 * 255).round()),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                  spreadRadius: 1,
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppTheme.primaryColor,
                    size: 18,
                  ),
                ],
              ),
      ),
    );
  }
}
// Elegant Animated Mesh Gradient Background Painter
class MeshGradientPainter extends CustomPainter {
  final double animationValue;

  MeshGradientPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final rect = Offset.zero & size;

    // Base background color
    paint.color = AppTheme.backgroundColor;
    canvas.drawRect(rect, paint);

    // Create moving glowing orbs using radial gradients (increased movement range)
    _drawOrb(canvas, size, 
      offset: Offset(size.width * (0.3 + 0.3 * math.sin(animationValue * math.pi * 2)), size.height * (0.3 + 0.3 * math.cos(animationValue * math.pi * 2))), 
      color: AppTheme.accentColor.withValues(alpha: 0.12),
      radius: size.width * 0.8,
    );

    _drawOrb(canvas, size, 
      offset: Offset(size.width * (0.7 + 0.3 * math.cos(animationValue * math.pi * 2)), size.height * (0.7 + 0.3 * math.sin(animationValue * math.pi * 2))), 
      color: AppTheme.accentColor.withValues(alpha: 0.10),
      radius: size.width * 0.9,
    );
    
    _drawOrb(canvas, size, 
      offset: Offset(size.width * (0.5 + 0.4 * math.sin(animationValue * math.pi)), size.height * (0.5 + 0.4 * math.cos(animationValue * math.pi))), 
      color: AppTheme.highlightColor.withValues(alpha: 0.08),
      radius: size.width * 0.7,
    );
  }

  void _drawOrb(Canvas canvas, Size size, {required Offset offset, required Color color, required double radius}) {
    final paint = Paint()
      ..shader = ui.Gradient.radial(
        offset,
        radius,
        [color, color.withAlpha(0)],
        [0.0, 1.0],
      );
    canvas.drawCircle(offset, radius, paint);
  }

  @override
  bool shouldRepaint(covariant MeshGradientPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
