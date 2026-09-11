import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/inward_post_model.dart';
import '../models/InwardPosts.dart' as AmplifyInwardPosts;

class InwardPostService {
  /// Update an entire inward post
  static Future<void> updatePost(InwardPost post) async {
    try {
      final amplifyPost = AmplifyInwardPosts.InwardPosts(
        id: post.id,
        sender: post.senderName,
        subject: post.description,
        received_date: post.receivedDate.toIso8601String(),
        status: post.status.toString(),
        data: jsonEncode(post.toJson()),
      );
      final request = ModelMutations.update(amplifyPost);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Error updating inward post: $e');
    }
  }

  /// Fetch all inward posts
  static Future<List<InwardPost>> getPosts() async {
    try {
      final request = ModelQueries.list(AmplifyInwardPosts.InwardPosts.classType);
      final response = await Amplify.API.query(request: request).response;
      final items = response.data?.items ?? [];
      
      final posts = items.where((e) => e != null).map((e) {
        if (e!.data != null) {
          final json = jsonDecode(e.data!);
          return InwardPost.fromJson(json);
        } else {
          // Fallback if data is null but other fields exist
          return InwardPost(
            id: e.id,
            senderName: e.sender ?? '',
            recipientName: '',
            receivedBy: '',
            description: e.subject ?? '',
            receivedDate: e.received_date != null ? DateTime.parse(e.received_date!) : DateTime.now(),
            status: PostStatus.values.firstWhere(
              (s) => s.toString() == e.status,
              orElse: () => PostStatus.pendingConfirmation,
            ),
          );
        }
      }).toList();
      
      posts.sort((a, b) => b.receivedDate.compareTo(a.receivedDate));
      return posts;
    } catch (e) {
      print('Error fetching inward posts: $e');
      return [];
    }
  }

  /// Add a new inward post
  static Future<void> addPost(InwardPost post) async {
    try {
      final amplifyPost = AmplifyInwardPosts.InwardPosts(
        sender: post.senderName,
        subject: post.description,
        received_date: post.receivedDate.toIso8601String(),
        status: post.status.toString(),
        data: jsonEncode(post.toJson()),
      );
      final request = ModelMutations.create(amplifyPost);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Error adding inward post: $e');
    }
  }
  
  /// Update post status
  static Future<void> updatePostStatus(String id, PostStatus status) async {
    try {
      final all = await getPosts();
      final post = all.firstWhere((p) => p.id == id);
      final updatedPost = post.copyWith(status: status);
      
      final amplifyPost = AmplifyInwardPosts.InwardPosts(
        id: id,
        status: status.toString(),
        data: jsonEncode(updatedPost.toJson()),
      );
      final request = ModelMutations.update(amplifyPost);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Error updating inward post status: $e');
    }
  }
}

