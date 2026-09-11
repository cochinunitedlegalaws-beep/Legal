import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/daily_case_payment.dart';
import '../models/DailyCasePayments.dart' as AmplifyPayments;

class DailyCasePaymentService {
  
  /// Load all daily case payments
  static Future<List<DailyCasePayment>> loadPayments() async {
    try {
      final request = ModelQueries.list(AmplifyPayments.DailyCasePayments.classType);
      final response = await Amplify.API.query(request: request).response;
      final items = response.data?.items ?? [];
      
      final payments = items.where((e) => e != null).map((e) {
        if (e!.data != null) {
          final json = jsonDecode(e.data!);
          json['id'] = e.id;
          return DailyCasePayment.fromJson(json);
        } else {
          return DailyCasePayment(
            id: e.id,
            eventId: '',
            caseId: e.case_id?.toString() ?? '',
            clientName: '',
            caseType: '',
            amount: (double.tryParse(e.amount ?? '0') ?? 0.0).toString(),
            status: 'Pending',
            counsel: '',
            dateRecorded: e.payment_date != null ? DateTime.parse(e.payment_date!) : DateTime.now(),
            lastUpdated: DateTime.now(),
            notes: e.remarks ?? '',
            paymentMethod: e.payment_mode ?? 'Cheque',
            advanceAmount: '0.0',
            balanceAmount: '0.0',
          );
        }
      }).toList();
      
      payments.sort((a, b) => b.dateRecorded.compareTo(a.dateRecorded));
      return payments;
    } catch (e) {
      print('Error loading payments: $e');
      return [];
    }
  }

  /// Save all payments (bulk upsert)
  static Future<void> savePayments(List<DailyCasePayment> payments) async {
    for (final p in payments) {
      // In amplify, upsert is usually done via get then update/create or directly create
      // For simplicity, we just do a create or update if it exists.
      final existing = await getPaymentById(p.id);
      if (existing != null) {
        await updatePayment(p);
      } else {
        await addPayment(p);
      }
    }
  }

  /// Add a new payment
  static Future<void> addPayment(DailyCasePayment payment) async {
    try {
      final amplifyPayment = AmplifyPayments.DailyCasePayments(
        case_id: int.tryParse(payment.caseId) ?? 0,
        amount: payment.amount.toString(),
        payment_date: payment.dateRecorded.toIso8601String(),
        payment_mode: payment.paymentMethod,
        remarks: payment.notes,
        data: jsonEncode(payment.toJson()),
      );
      final request = ModelMutations.create(amplifyPayment);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Error adding payment: $e');
    }
  }

  /// Update an existing payment
  static Future<void> updatePayment(DailyCasePayment payment) async {
    try {
      final amplifyPayment = AmplifyPayments.DailyCasePayments(
        id: payment.id,
        case_id: int.tryParse(payment.caseId) ?? 0,
        amount: payment.amount.toString(),
        payment_date: payment.dateRecorded.toIso8601String(),
        payment_mode: payment.paymentMethod,
        remarks: payment.notes,
        data: jsonEncode(payment.toJson()),
      );
      final request = ModelMutations.update(amplifyPayment);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Error updating payment: $e');
    }
  }

  /// Delete a payment
  static Future<void> deletePayment(String paymentId) async {
    try {
      final amplifyPayment = AmplifyPayments.DailyCasePayments(id: paymentId);
      final request = ModelMutations.delete(amplifyPayment);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Error deleting payment: $e');
    }
  }

  /// Get payments by event ID
  static Future<List<DailyCasePayment>> getPaymentsByEventId(String eventId) async {
    final payments = await loadPayments();
    return payments.where((p) => p.eventId == eventId).toList();
  }

  /// Get payments by case ID
  static Future<List<DailyCasePayment>> getPaymentsByCaseId(String caseId) async {
    final payments = await loadPayments();
    return payments.where((p) => p.caseId == caseId).toList();
  }

  /// Get payment by ID
  static Future<DailyCasePayment?> getPaymentById(String paymentId) async {
    try {
      final request = ModelQueries.get(AmplifyPayments.DailyCasePayments.classType, AmplifyPayments.DailyCasePaymentsModelIdentifier(id: paymentId));
      final response = await Amplify.API.query(request: request).response;
      final e = response.data;
      if (e == null) return null;
      
      if (e.data != null) {
        final json = jsonDecode(e.data!);
        json['id'] = e.id;
        return DailyCasePayment.fromJson(json);
      } else {
        return DailyCasePayment(
          id: e.id,
          eventId: '',
          caseId: e.case_id?.toString() ?? '',
          clientName: '',
          caseType: '',
          amount: (double.tryParse(e.amount ?? '0') ?? 0.0).toString(),
          status: 'Pending',
          counsel: '',
          dateRecorded: e.payment_date != null ? DateTime.parse(e.payment_date!) : DateTime.now(),
          lastUpdated: DateTime.now(),
          notes: e.remarks ?? '',
          paymentMethod: e.payment_mode ?? 'Cheque',
          advanceAmount: '0.0',
          balanceAmount: '0.0',
        );
      }
    } catch (e) {
      print('Error getting payment by id: $e');
      return null;
    }
  }

  /// Get summary statistics
  static Future<Map<String, dynamic>> getPaymentsSummary() async {
    final payments = await loadPayments();
    
    int totalPending = 0;
    int totalPartial = 0;
    int totalPaid = 0;
    int totalOverdue = 0;

    for (var payment in payments) {
      switch (payment.status) {
        case 'Pending':
          totalPending++;
          break;
        case 'Partial':
          totalPartial++;
          break;
        case 'Paid':
          totalPaid++;
          break;
        case 'Overdue':
          totalOverdue++;
          break;
      }
    }

    return {
      'totalPayments': payments.length,
      'pending': totalPending,
      'partial': totalPartial,
      'paid': totalPaid,
      'overdue': totalOverdue,
    };
  }
}

