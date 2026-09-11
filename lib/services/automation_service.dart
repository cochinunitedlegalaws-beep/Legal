import 'dart:async';

class AutomationService {
  /// Simulates sending a WhatsApp message via an API like Twilio or Meta Graph API.
  static Future<bool> sendWhatsAppMessage(String phone, String message) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    print('✅ [WhatsApp Mock] Sent to $phone: $message');
    return true;
  }

  /// Simulates sending an automated email digest via an API like SendGrid or AWS SES.
  static Future<bool> sendEmailDigest(String email, String subject, String body) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    print('✅ [Email Mock] Sent to $email\nSubject: $subject\nBody: $body');
    return true;
  }
}
