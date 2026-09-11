/// Configuration class for Gmail SMTP credentials.
/// 
/// To set up Gmail SMTP:
/// 1. Log in to your Gmail account.
/// 2. Enable 2-Step Verification in Google Account Settings.
/// 3. Go to Security -> 2-Step Verification -> App passwords (at the bottom).
/// 4. Generate a new app password for 'Mail' and copy the 16-character code.
/// 5. Paste the 16-character code into [gmailAppPassword] below.
class SmtpConfig {
  /// The Gmail email address to send OTP emails from.
  /// Example: "sender@gmail.com"
  static const String gmailSenderEmail = '';

  /// The 16-character Gmail App Password.
  /// Example: "abcd efgh ijkl mnop" (spaces are optional)
  static const String gmailAppPassword = '';

  /// Returns true if SMTP credentials have been set up.
  static bool get isConfigured =>
      gmailSenderEmail.trim().isNotEmpty && gmailAppPassword.trim().isNotEmpty;
}
