import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/daily_case_payment.dart';
import '../models/DailyCasePayments.dart' as AmplifyModels;

class PaymentReminderService {
  
  static Future<List<DailyCasePayment>> _fetchAllPayments() async {
    try {
      final request = ModelQueries.list(AmplifyModels.DailyCasePayments.classType);
      final response = await Amplify.API.query(request: request).response;
      final items = response.data?.items ?? [];
      
      return items.whereType<AmplifyModels.DailyCasePayments>().map((e) {
        final dataMap = e.data != null ? jsonDecode(e.data!) as Map<String, dynamic> : <String, dynamic>{};
        // Merge the top-level Amplify fields into the dataMap for the local model parser
        dataMap['id'] = e.id;
        if (e.case_id != null) dataMap['caseId'] = e.case_id.toString();
        if (e.amount != null) dataMap['amount'] = e.amount;
        if (e.payment_date != null) dataMap['paymentDate'] = e.payment_date;
        if (e.payment_mode != null) dataMap['paymentMode'] = e.payment_mode;
        if (e.received_by != null) dataMap['receivedBy'] = e.received_by.toString();
        if (e.remarks != null) dataMap['remarks'] = e.remarks;
        
        return DailyCasePayment.fromJson(dataMap);
      }).toList();
    } catch (e) {
      print('Error fetching payments from Amplify: $e');
      return [];
    }
  }

  /// Get all active payment reminders (within reminder window)
  static Future<List<DailyCasePayment>> getActiveReminders() async {
    try {
      final payments = await _fetchAllPayments();

      return payments.where((p) {
        if (p.status == 'Paid') return false;
        if (p.expectedPaymentDate == null) return false;
        return p.shouldShowReminder();
      }).toList()..sort((a, b) => (a.id ?? '').compareTo(b.id ?? ''));
    } catch (e) {
      print('Error fetching active reminders: $e');
      return [];
    }
  }

  /// Get payment reminders for a specific case
  static Future<List<DailyCasePayment>> getRemindersByCase(String caseId) async {
    try {
      final payments = await _fetchAllPayments();

      return payments.where((p) {
        if (p.caseId != caseId) return false;
        if (p.status == 'Paid') return false;
        if (p.expectedPaymentDate == null) return false;
        return p.shouldShowReminder();
      }).toList()..sort((a, b) => (a.id ?? '').compareTo(b.id ?? ''));
    } catch (e) {
      print('Error fetching case reminders: $e');
      return [];
    }
  }

  /// Get overdue payments
  static Future<List<DailyCasePayment>> getOverduePayments() async {
    try {
      final now = DateTime.now();
      final payments = await _fetchAllPayments();

      return payments.where((p) {
        if (p.status == 'Paid') return false;
        if (p.expectedPaymentDate == null) return false;
        return p.expectedPaymentDate!.isBefore(now);
      }).toList();
    } catch (e) {
      print('Error fetching overdue payments: $e');
      return [];
    }
  }

  /// Get payments due soon (within 3 days)
  static Future<List<DailyCasePayment>> getPaymentsDueSoon() async {
    try {
      final now = DateTime.now();
      final threeDaysFromNow = now.add(const Duration(days: 3));
      final payments = await _fetchAllPayments();

      return payments.where((p) {
        if (p.status == 'Paid') return false;
        if (p.expectedPaymentDate == null) return false;
        return p.expectedPaymentDate!.isAfter(now.subtract(const Duration(days: 1))) && 
               p.expectedPaymentDate!.isBefore(threeDaysFromNow);
      }).toList();
    } catch (e) {
      print('Error fetching payments due soon: $e');
      return [];
    }
  }

  static Future<void> _updatePaymentData(String paymentId, Map<String, dynamic> updates) async {
    try {
      final getReq = ModelQueries.get(
        AmplifyModels.DailyCasePayments.classType, 
        AmplifyModels.DailyCasePaymentsModelIdentifier(id: paymentId)
      );
      final getRes = await Amplify.API.query(request: getReq).response;
      final existing = getRes.data;
      if (existing != null) {
        Map<String, dynamic> currentData = {};
        if (existing.data != null) {
          try {
            currentData = jsonDecode(existing.data!) as Map<String, dynamic>;
          } catch (_) {}
        }
        currentData.addAll(updates);
        
        // Ensure status isn't incorrectly overridden if passed in updates
        if (updates.containsKey('status')) {
           // Wait, status isn't a top level field in the Amplify schema, it's inside data JSON
        }
        
        final updatedPayment = existing.copyWith(
          data: jsonEncode(currentData),
        );
        
        final request = ModelMutations.update(updatedPayment);
        await Amplify.API.mutate(request: request).response;
      }
    } catch (e) {
      print('Error updating payment data: $e');
    }
  }

  /// Mark reminder as sent for a payment
  static Future<void> markReminderSent(String paymentId) async {
    await _updatePaymentData(paymentId, {
      'reminderSent': true,
      'reminderSentDate': DateTime.now().toIso8601String(),
      'lastUpdated': DateTime.now().toIso8601String(),
    });
  }

  /// Update customer contact date for a payment
  static Future<void> updateCustomerContactDate(String paymentId, DateTime contactDate) async {
    await _updatePaymentData(paymentId, {
      'customerContactedDate': contactDate.toIso8601String(),
      'lastUpdated': DateTime.now().toIso8601String(),
    });
  }

  /// Get reminder statistics
  static Future<Map<String, int>> getReminderStats() async {
    try {
      final overdue = await getOverduePayments();
      final dueSoon = await getPaymentsDueSoon();
      final active = await getActiveReminders();

      return {
        'overdue': overdue.length,
        'dueSoon': dueSoon.length,
        'active': active.length,
        'total': overdue.length + dueSoon.length,
      };
    } catch (e) {
      print('Error getting reminder stats: $e');
      return {'overdue': 0, 'dueSoon': 0, 'active': 0, 'total': 0};
    }
  }
}
