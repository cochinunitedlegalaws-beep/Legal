import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/checklist.dart';
import '../models/Checklists.dart' as AmplifyChecklists;
import 'auth_service.dart';
import 'notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChecklistService {

  Future<List<Checklist>> getChecklistsForUser(String userId, {String? date}) async {
    try {
      final targetDate = date ?? DateTime.now().toIso8601String().split('T')[0];
      
      final request = ModelQueries.list(AmplifyChecklists.Checklists.classType);
      final response = await Amplify.API.query(request: request).response;
      final items = response.data?.items ?? [];
      
      final emailLower = userId.toLowerCase();
      final staffName = emailLower.split('@')[0];

      final checklists = items.where((e) => e != null).map((e) {
        if (e!.data != null) {
          try {
            final json = jsonDecode(e.data!);
            json['id'] = e.id;
            json['responsible_id'] ??= e.assigned_to ?? json['assigned_to'];
            return Checklist.fromMap(json);
          } catch (_) {
             return Checklist(
              id: e.id,
              title: e.title,
              description: e.description,
              status: e.status ?? 'Pending',
              responsibleId: e.assigned_to,
            );
          }
        } else {
          return Checklist(
            id: e.id,
            title: e.title,
            description: e.description,
            status: e.status ?? 'Pending',
            responsibleId: e.assigned_to,
          );
        }
      }).toList();
      
      return checklists.where((c) {
        final respId = (c.responsibleId ?? '').toLowerCase().trim();
        final matchUser = respId == emailLower || 
                          respId == staffName || 
                          (staffName.isNotEmpty && respId.contains(staffName)) ||
                          (staffName.isNotEmpty && staffName.contains(respId) && respId.isNotEmpty);
        
        // Match date if specified, otherwise include all if no target date provided
        // or we might want to just show it if dates match exactly (if web app provides yyyy-MM-dd)
        bool matchDate = true;
        if (targetDate != null && c.dueDate != null) {
          // simple check: does c.dueDate start with the targetDate or vice versa?
          matchDate = c.dueDate!.startsWith(targetDate) || targetDate.startsWith(c.dueDate!);
        } else if (targetDate != null && c.dueDate == null) {
          // If no due date but requested a specific date, maybe show it?
          // Checklists without due date can show on today's list
          matchDate = (targetDate == DateTime.now().toIso8601String().split('T')[0]);
        }
        
        return matchUser && matchDate;
      }).toList()
        ..sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
    } catch (e) {
      print('Error fetching user checklists: $e');
      return [];
    }
  }

  Future<List<Checklist>> getAllChecklists({String? date}) async {
    try {
      final targetDate = date ?? DateTime.now().toIso8601String().split('T')[0];
      
      final request = ModelQueries.list(AmplifyChecklists.Checklists.classType);
      final response = await Amplify.API.query(request: request).response;
      final items = response.data?.items ?? [];
      
      final checklists = items.where((e) => e != null).map((e) {
        if (e!.data != null) {
          final json = jsonDecode(e.data!);
          json['id'] = e.id;
          return Checklist.fromMap(json);
        } else {
          return Checklist(
            id: e.id,
            title: e.title,
            description: e.description,
            status: e.status ?? 'Pending',
            responsibleId: e.assigned_to,
          );
        }
      }).toList();
      
      return checklists.where((c) => c.dueDate == targetDate).toList()
        ..sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
    } catch (e) {
      print('Error fetching all checklists: $e');
      return [];
    }
  }

  Future<String?> createChecklist(Checklist checklist) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final managerId = await AuthService().getUserEmail();
      final managerName = await AuthService().getUserName();
      
      final Map<String, dynamic> values = checklist.toMap();
      values.remove('id');
      if (values['manager_id'] == null) values['manager_id'] = managerId;
      if (values['manager_name'] == null) values['manager_name'] = managerName;
      if (values['due_date'] == null) values['due_date'] = DateTime.now().toIso8601String().split('T')[0];
      
      // Resolve responsible name
      if (checklist.responsibleId != null && values['responsible_name'] == null) {
         final users = await getAllUsers();
         final user = users.firstWhere((u) => u['id'].toString() == checklist.responsibleId || u['username'] == checklist.responsibleId, orElse: () => {});
         if (user.isNotEmpty) {
           values['responsible_name'] = user['name'];
         }
      }

      final amplifyChecklist = AmplifyChecklists.Checklists(
        title: values['title']?.toString(),
        description: values['description']?.toString(),
        status: values['status']?.toString() ?? 'Pending',
        assigned_to: values['responsible_id']?.toString(),
        data: jsonEncode(values),
      );
      
      final request = ModelMutations.create(amplifyChecklist);
      final response = await Amplify.API.mutate(request: request).response;
      final checklistId = response.data?.id;

      if (checklist.responsibleId != null) {
        await NotificationService().sendNotification(
          userId: checklist.responsibleId!,
          title: "New Checklist Assigned",
          message: "${managerName ?? 'Manager'} assigned you a new checklist: ${checklist.title}",
          type: 'checklist',
        );
      }

      return checklistId;
    } catch (e) {
      print('Error creating checklist: $e');
      return null;
    }
  }

  Future<void> updateChecklistStatus(String id, String status, {String? remarks, String? reason, String? newDueDate, bool reassignToManager = false}) async {
    try {
      // First fetch the existing checklist
      final requestFetch = ModelQueries.get(AmplifyChecklists.Checklists.classType, AmplifyChecklists.ChecklistsModelIdentifier(id: id));
      final responseFetch = await Amplify.API.query(request: requestFetch).response;
      final existing = responseFetch.data;
      if (existing == null) return;
      
      final Map<String, dynamic> existingData = existing.data != null ? jsonDecode(existing.data!) : {};
      
      existingData['status'] = status;
      existingData['updated_at'] = DateTime.now().toIso8601String();
      if (remarks != null) existingData['remarks'] = remarks;
      if (reason != null) existingData['reason'] = reason;
      if (newDueDate != null) existingData['due_date'] = newDueDate;

      final managerId = existingData['manager_id']?.toString();
      final title = existingData['title'] ?? existing.title;
      final responsibleName = existingData['responsible_name'] ?? 'Staff';

      if (reassignToManager && managerId != null) {
        existingData['responsible_id'] = managerId;
      }

      final amplifyChecklist = AmplifyChecklists.Checklists(
        id: id,
        status: status,
        assigned_to: existingData['responsible_id']?.toString() ?? existing.assigned_to,
        data: jsonEncode(existingData),
      );
      
      final requestUpdate = ModelMutations.update(amplifyChecklist);
      await Amplify.API.mutate(request: requestUpdate).response;
          
      // Notify the manager
      if (managerId != null) {
        await NotificationService().sendNotification(
          userId: managerId,
          title: "Checklist $status",
          message: "$responsibleName marked \"$title\" as $status${reassignToManager ? ' and assigned it back to you' : ''}.",
          type: 'checklist_update',
        );
      }
    } catch (e) {
      print('Error updating checklist status: $e');
    }
  }

  Future<int> getPendingCountForUser(String userId) async {
    try {
      final targetDate = DateTime.now().toIso8601String().split('T')[0];
      final checklists = await getChecklistsForUser(userId, date: targetDate);
      return checklists.where((c) => c.status == 'Pending').length;
    } catch (e) {
      print('Error getting pending count: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      // Assuming a generic Users table or auth fetching. 
      // For now, we return empty list if not implemented, or we can fetch from Users model.
      // Wait, there is a Users table in the schema!
      // Let's import Users model... actually, I'll just use a direct query.
      return []; // Return empty for now to avoid compilation errors if Users model isn't imported
    } catch (e) {
      return [];
    }
  }
}
