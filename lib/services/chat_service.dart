import 'dart:async';
import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/ChatMessages.dart' as AmplifyChatMessages;


class ChatService {

  static Map<String, dynamic> _convertMessage(AmplifyChatMessages.ChatMessages e) {
    if (e.data != null) {
      final json = jsonDecode(e.data!);
      json['id'] = e.id;
      json['timestamp'] = e.createdAt?.format() ?? DateTime.now().toIso8601String();
      return json;
    } else {
      return {
        'id': e.id,
        'sender': e.sender,
        'message': e.message,
        'role': e.data != null ? jsonDecode(e.data!)['role'] ?? 'user' : 'user',
        'timestamp': e.createdAt?.format() ?? DateTime.now().toIso8601String(),
      };
    }
  }

  /// Fetch all chat messages
  static Future<List<Map<String, dynamic>>> getMessages() async {
    try {
      final request = ModelQueries.list(AmplifyChatMessages.ChatMessages.classType);
      final response = await Amplify.API.query(request: request).response;
      final items = response.data?.items ?? [];
      
      final messages = items.where((e) => e != null).map((e) => _convertMessage(e!)).toList();
      
      messages.sort((a, b) {
        final aTime = DateTime.tryParse(a['timestamp'] ?? '') ?? DateTime.now();
        final bTime = DateTime.tryParse(b['timestamp'] ?? '') ?? DateTime.now();
        return aTime.compareTo(bTime);
      });
      return messages;
    } catch (e) {
      print('Error fetching chat messages: $e');
      return [];
    }
  }

  /// Add a new chat message
  static Future<void> sendMessage(String sender, String message, String role) async {
    try {
      final data = {
        'sender': sender,
        'message': message,
        'role': role,
        'timestamp': DateTime.now().toIso8601String(),
      };
      final amplifyMessage = AmplifyChatMessages.ChatMessages(
        sender: sender,
        message: message,
        
        data: jsonEncode({'role': role}),
      );
      final request = ModelMutations.create(amplifyMessage);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  /// Stream messages for real-time updates
  static Stream<List<Map<String, dynamic>>> streamMessages() {
    final controller = StreamController<List<Map<String, dynamic>>>();
    
    getMessages().then((messages) {
      if (!controller.isClosed) {
        controller.add(messages);
      }
      
      final subscription = Amplify.API.subscribe(
        ModelSubscriptions.onCreate(AmplifyChatMessages.ChatMessages.classType),
      ).listen((event) {
        final newMessage = event.data;
        if (newMessage != null) {
          messages.add(_convertMessage(newMessage));
          if (!controller.isClosed) {
            controller.add(messages);
          }
        }
      });
      
      controller.onCancel = () {
        subscription.cancel();
      };
    }).catchError((e) {
      if (!controller.isClosed) controller.addError(e);
    });

    return controller.stream;
  }
}
