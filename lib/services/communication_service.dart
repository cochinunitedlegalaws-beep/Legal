import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/communication_log.dart';
import '../models/CommunicationLogs.dart' as AmplifyModels;

class CommunicationService {
  static const _localKey = 'local_communication_logs_db';

  static Future<List<CommunicationLog>> getLogs({String? relatedToId}) async {
    List<CommunicationLog> allLogs = [];
    try {
      final request = ModelQueries.list(AmplifyModels.CommunicationLogs.classType);
      final response = await Amplify.API.query(request: request).response;
      final items = response.data?.items ?? [];
      
      allLogs.addAll(items.whereType<AmplifyModels.CommunicationLogs>().map((e) {
        final dataMap = e.data != null ? jsonDecode(e.data!) : <String, dynamic>{};
        return CommunicationLog.fromJson({
          'id': e.id,
          'relatedToId': e.client_id ?? dataMap['related_to_id'] ?? '',
          'relatedToType': dataMap['related_to_type'] ?? '',
          'contactName': dataMap['contact_name'] ?? '',
          'type': e.medium ?? dataMap['type'] ?? '',
          'direction': dataMap['direction'] ?? '',
          'summary': e.notes ?? dataMap['summary'] ?? '',
          'staffName': dataMap['staff_name'] ?? '',
          'timestamp': e.date ?? dataMap['timestamp'] ?? DateTime.now().toIso8601String(),
        });
      }).toList());
    } catch (e) {
      print('Failed to fetch communication logs from Amplify: $e');
    }

    final localLogs = await _getLocalLogs();
    for (var local in localLogs) {
      if ((relatedToId == null || local.relatedToId == relatedToId) && !allLogs.any((l) => l.id == local.id)) {
        allLogs.add(local);
      }
    }
    
    if (relatedToId != null) {
      allLogs.retainWhere((l) => l.relatedToId == relatedToId);
    }
    allLogs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return allLogs;
  }

  static Future<void> addLog(CommunicationLog log) async {
    try {
      final amplifyLog = AmplifyModels.CommunicationLogs(
        id: log.id,
        client_id: log.relatedToId,
        medium: log.type,
        notes: log.summary,
        date: log.timestamp.toIso8601String(),
        data: jsonEncode({
          'related_to_id': log.relatedToId,
          'related_to_type': log.relatedToType,
          'contact_name': log.contactName,
          'type': log.type,
          'direction': log.direction,
          'summary': log.summary,
          'staff_name': log.staffName,
          'timestamp': log.timestamp.toIso8601String(),
        })
      );
      final request = ModelMutations.create(amplifyLog);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Saving communication log locally: $e');
      final logs = await _getLocalLogs();
      logs.add(log);
      await _saveLocalLogs(logs);
    }
  }

  static Future<void> deleteLog(String id) async {
    try {
      final request = ModelMutations.deleteById(
        AmplifyModels.CommunicationLogs.classType, 
        AmplifyModels.CommunicationLogsModelIdentifier(id: id)
      );
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Deleting communication log locally: $e');
      final logs = await _getLocalLogs();
      logs.removeWhere((l) => l.id == id);
      await _saveLocalLogs(logs);
    }
  }

  static Future<List<CommunicationLog>> _getLocalLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_localKey);
    if (jsonStr == null) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => CommunicationLog.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> _saveLocalLogs(List<CommunicationLog> logs) async {
    final prefs = await SharedPreferences.getInstance();
    final listStr = jsonEncode(logs.map((e) => e.toJson()).toList());
    await prefs.setString(_localKey, listStr);
  }
}
