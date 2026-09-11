import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';

/// Wrapper around Amplify API that previously automatically backed up mutations to Supabase.
/// Use this instead of calling Amplify.API.mutate() directly for critical data.
class BackupAwareApi {
  static final BackupAwareApi _instance = BackupAwareApi._();
  factory BackupAwareApi() => _instance;
  BackupAwareApi._();

  /// Create a record in DynamoDB.
  Future<GraphQLResponse<T>> create<T extends Model>(T model) async {
    final response = await Amplify.API
        .mutate(request: ModelMutations.create(model))
        .response;

    return response;
  }

  /// Update a record in DynamoDB.
  Future<GraphQLResponse<T>> update<T extends Model>(T model) async {
    final response = await Amplify.API
        .mutate(request: ModelMutations.update(model))
        .response;

    return response;
  }

  /// Delete a record from DynamoDB.
  Future<GraphQLResponse<T>> delete<T extends Model>(T model) async {
    final response = await Amplify.API
        .mutate(request: ModelMutations.delete(model))
        .response;

    return response;
  }

  /// Delete a record by ID from DynamoDB.
  Future<GraphQLResponse<T>> deleteById<T extends Model>(ModelType<T> classType, ModelIdentifier<T> id) async {
    final response = await Amplify.API
        .mutate(request: ModelMutations.deleteById(classType, id))
        .response;

    return response;
  }
}
