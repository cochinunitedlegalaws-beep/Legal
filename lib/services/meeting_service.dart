import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/Meetings.dart' as AmplifyMeetings;

class MeetingService {

  /// Fetch all meetings
  static Future<List<Map<String, dynamic>>> getMeetings() async {
    try {
      final request = ModelQueries.list(AmplifyMeetings.Meetings.classType);
      final response = await Amplify.API.query(request: request).response;
      final items = response.data?.items ?? [];
      
      final meetings = items.where((e) => e != null).map((e) {
        if (e!.data != null) {
          final json = jsonDecode(e.data!);
          json['id'] = e.id;
          json['created_at'] = e.createdAt?.format();
          return json;
        } else {
          return {
            'id': e.id,
            'title': e.title,
            'meeting_date': e.meeting_date,
            'location': e.location,
            'attendees': e.attendees,
            'created_at': e.createdAt?.format(),
          };
        }
      }).toList();
      
      // Sort by descending created_at
      meetings.sort((a, b) {
        final aDate = a['created_at'] != null ? DateTime.tryParse(a['created_at']) : null;
        final bDate = b['created_at'] != null ? DateTime.tryParse(b['created_at']) : null;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return bDate.compareTo(aDate);
      });
      
      return List<Map<String, dynamic>>.from(meetings);
    } catch (e) {
      print('Error fetching meetings: $e');
      return [];
    }
  }

  /// Add a new meeting
  static Future<void> addMeeting(Map<String, dynamic> meeting) async {
    try {
      final amplifyMeeting = AmplifyMeetings.Meetings(
        title: meeting['title']?.toString(),
        meeting_date: meeting['meeting_date']?.toString(),
        location: meeting['location']?.toString(),
        attendees: meeting['attendees']?.toString(),
        data: jsonEncode(meeting),
      );
      final request = ModelMutations.create(amplifyMeeting);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Error adding meeting: $e');
    }
  }
}
