import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/Approvals.dart' as AmplifyModels;

class ApprovalService {
  /// Fallback sample approvals
  static List<Map<String, dynamic>> _sampleApprovals = [
    {
      'id': 'apr-1',
      'title': 'Adv. Rajesh Pillai Timesheet',
      'description': '18.5 hrs logged • Arbitration',
      'amount': null,
      'type': 'draft',
      'status': 'pending',
    },
    {
      'id': 'apr-2',
      'title': 'Adv. Hari Prasad Filing Expenses',
      'description': '₹4,500 • High Court Filing Fees',
      'amount': 4500,
      'type': 'bill',
      'status': 'pending',
    },
    {
      'id': 'apr-3',
      'title': 'Adv. Anjali Menon Travel Slip',
      'description': '₹850 • Ernakulam Court Transit',
      'amount': 850,
      'type': 'work',
      'status': 'pending',
    },
  ];

  static Future<List<Map<String, dynamic>>> getPendingApprovals() async {
    try {
      final request = ModelQueries.list(AmplifyModels.Approvals.classType);
      final response = await Amplify.API.query(request: request).response;
      
      final items = response.data?.items ?? [];
      
      final pendingApprovals = items.whereType<AmplifyModels.Approvals>().where((a) => a.status == 'pending').map((e) {
        final dataMap = e.data != null ? jsonDecode(e.data!) : <String, dynamic>{};
        return {
          'id': e.id,
          'title': dataMap['title'] ?? '',
          'description': dataMap['description'] ?? '',
          'amount': dataMap['amount'] != null ? double.tryParse(dataMap['amount'].toString()) : null,
          'type': dataMap['type'] ?? '',
          'status': e.status ?? '',
          'created_at': dataMap['created_at'],
        };
      }).toList();
      
      if (pendingApprovals.isNotEmpty) {
        pendingApprovals.sort((a, b) => (b['created_at']?.toString() ?? '').compareTo(a['created_at']?.toString() ?? ''));
        return pendingApprovals;
      }
      return List<Map<String, dynamic>>.from(_sampleApprovals);
    } catch (e) {
      // If table doesn't exist or query fails, return sample data
      print('Error fetching approvals: $e');
      return List<Map<String, dynamic>>.from(_sampleApprovals);
    }
  }

  static Future<bool> approve(String id) async {
    try {
      final getReq = ModelQueries.get(
        AmplifyModels.Approvals.classType, 
        AmplifyModels.ApprovalsModelIdentifier(id: id)
      );
      final getRes = await Amplify.API.query(request: getReq).response;
      final existing = getRes.data;

      if (existing != null) {
        Map<String, dynamic> dataMap = {};
        if (existing.data != null) {
          try {
            dataMap = jsonDecode(existing.data!) as Map<String, dynamic>;
          } catch (_) {}
        }
        dataMap['approved_at'] = DateTime.now().toIso8601String();

        final updated = existing.copyWith(
          status: 'approved',
          data: jsonEncode(dataMap),
        );
        final updateReq = ModelMutations.update(updated);
        await Amplify.API.mutate(request: updateReq).response;
      }
      return true;
    } catch (e) {
      print('Error approving: $e');
      return true;
    }
  }

  static Future<bool> reject(String id, {String? reason}) async {
    try {
      final getReq = ModelQueries.get(
        AmplifyModels.Approvals.classType, 
        AmplifyModels.ApprovalsModelIdentifier(id: id)
      );
      final getRes = await Amplify.API.query(request: getReq).response;
      final existing = getRes.data;

      if (existing != null) {
        Map<String, dynamic> dataMap = {};
        if (existing.data != null) {
          try {
            dataMap = jsonDecode(existing.data!) as Map<String, dynamic>;
          } catch (_) {}
        }
        dataMap['rejected_at'] = DateTime.now().toIso8601String();
        dataMap['reject_reason'] = reason;

        final updated = existing.copyWith(
          status: 'rejected',
          data: jsonEncode(dataMap),
        );
        final updateReq = ModelMutations.update(updated);
        await Amplify.API.mutate(request: updateReq).response;
      }
      return true;
    } catch (e) {
      print('Error rejecting: $e');
      return true;
    }
  }

  static Future<bool> approveAll() async {
    try {
      final request = ModelQueries.list(AmplifyModels.Approvals.classType);
      final response = await Amplify.API.query(request: request).response;
      final items = response.data?.items ?? [];
      
      final pending = items.whereType<AmplifyModels.Approvals>().where((a) => a.status == 'pending');
      
      for (var p in pending) {
        Map<String, dynamic> dataMap = {};
        if (p.data != null) {
          try {
            dataMap = jsonDecode(p.data!) as Map<String, dynamic>;
          } catch (_) {}
        }
        dataMap['approved_at'] = DateTime.now().toIso8601String();

        final updated = p.copyWith(
          status: 'approved',
          data: jsonEncode(dataMap),
        );
        final updateReq = ModelMutations.update(updated);
        await Amplify.API.mutate(request: updateReq).response;
      }
      return true;
    } catch (e) {
      print('Error approving all: $e');
      return true;
    }
  }
}
