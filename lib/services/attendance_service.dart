import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ModelProvider.dart';

class AttendanceService {
  /// Fetch check-in status for a user
  static Future<Map<String, dynamic>?> getStatus(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('current_user_id');
      if (userId == null) return null;

      final req = ModelQueries.list(StaffAttendance.classType, where: StaffAttendance.USER_ID.eq(userId));
      final res = await Amplify.API.query(request: req).response;
      if (res.data?.items.isNotEmpty == true) {
        // Sort to get the most recent one by date (assuming YYYY-MM-DD or similar sorting)
        final items = res.data!.items.whereType<StaffAttendance>().toList();
        if (items.isEmpty) return null;
        items.sort((a, b) => (b.attendance_date ?? '').compareTo(a.attendance_date ?? ''));
        final attendance = items.first;
        
        return {
          'staff_email': email,
          'is_checked_in': attendance.check_out_time == null,
          'last_check_in_time': attendance.check_in_time,
          'updated_at': attendance.updatedAt?.format(),
        };
      }
      return null;
    } catch (e) {
      print('Error fetching attendance: $e');
      return null;
    }
  }

  /// Update check-in status
  static Future<void> updateStatus(String email, bool isCheckedIn, String timeStr) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('current_user_id');
      if (userId == null) return;

      final today = DateTime.now().toIso8601String().split('T')[0];

      final req = ModelQueries.list(StaffAttendance.classType, where: StaffAttendance.USER_ID.eq(userId));
      final res = await Amplify.API.query(request: req).response;
      
      StaffAttendance? todayAttendance;
      if (res.data?.items.isNotEmpty == true) {
        final items = res.data!.items.whereType<StaffAttendance>().toList();
        for (var att in items) {
            if (att.attendance_date == today) {
                todayAttendance = att;
                break;
            }
        }
      }

      if (todayAttendance != null) {
        final updated = todayAttendance.copyWith(
            check_in_time: isCheckedIn ? timeStr : todayAttendance.check_in_time,
            check_out_time: !isCheckedIn ? timeStr : null,
        );
        await Amplify.API.mutate(request: ModelMutations.update(updated)).response;
      } else {
        final newAttendance = StaffAttendance(
            user_id: userId, 
            attendance_date: today,
            check_in_time: isCheckedIn ? timeStr : null,
            check_out_time: !isCheckedIn ? timeStr : null,
        );
        await Amplify.API.mutate(request: ModelMutations.create(newAttendance)).response;
      }
    } catch (e) {
      print('Error updating attendance: $e');
    }
  }

  /// Fetch all check-in statuses for all users
  static Future<List<Map<String, dynamic>>> getAllStatuses() async {
    try {
      final req = ModelQueries.list(StaffAttendance.classType);
      final res = await Amplify.API.query(request: req).response;
      return (res.data?.items ?? []).where((e) => e != null).map((attendance) => {
        'staff_email': 'User ${attendance!.user_id}',
        'is_checked_in': attendance.check_out_time == null,
        'last_check_in_time': attendance.check_in_time,
        'updated_at': attendance.updatedAt?.format(),
      }).toList();
    } catch (e) {
      print('Error fetching all attendances: $e');
      return [];
    }
  }
}

