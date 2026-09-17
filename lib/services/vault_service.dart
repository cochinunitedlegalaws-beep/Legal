import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/VaultFiles.dart' as AmplifyModels;

class VaultService {
  static Future<String?> _getTenantId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('tenant_id') ?? 'TENANT_CUC_001';
  }

  /// Fetch all vault files for a specific user
  static Future<List<Map<String, dynamic>>> getFiles(String userEmail) async {
    List<Map<String, dynamic>> allFiles = [];
    try {
      final request = ModelQueries.list(AmplifyModels.VaultFiles.classType);
      final response = await Amplify.API.query(request: request).response;
      
      final items = response.data?.items ?? [];
      
      final mappedFiles = items.whereType<AmplifyModels.VaultFiles>().map((e) {
        final dataMap = e.data != null ? jsonDecode(e.data!) : <String, dynamic>{};
        return {
          'id': e.id,
          'file_name': e.file_name ?? dataMap['file_name'] ?? '',
          'file_path': e.storage_path ?? dataMap['file_path'],
          'owner_email': e.uploaded_by ?? dataMap['owner_email'],
          'upload_date': dataMap['upload_date'] ?? DateTime.now().toIso8601String(),
          'file_size': dataMap['file_size'],
          'folder_name': dataMap['folder_name'] ?? 'Personal',
          'created_at': dataMap['created_at'],
        };
      }).where((f) => f['owner_email'] == userEmail).toList();
      
      mappedFiles.sort((a, b) => (b['upload_date'] as String).compareTo(a['upload_date'] as String));
      allFiles.addAll(mappedFiles);
    } catch (e) {
      print('Error fetching files from Amplify: $e');
    }
    
    final localFiles = await _getLocalFiles(userEmail);
    for (var local in localFiles) {
      if (!allFiles.any((f) => f['file_name'] == local['file_name'] && f['upload_date'] == local['upload_date'])) {
        allFiles.add(local);
      }
    }
    return allFiles;
  }

  /// Add a new vault file
  static Future<void> addFile({
    required String fileName,
    required String uploadDate,
    required String fileSize,
    required String ownerEmail,
    String folderName = 'Personal',
    Uint8List? fileBytes,
  }) async {
    String? storagePath;
    final tenantId = await _getTenantId();

    if (fileBytes != null) {
      try {
        final sanitizedEmail = ownerEmail.replaceAll('@', '_').replaceAll('.', '_');
        final sanitizedFileName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9.\-]'), '_');
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        storagePath = '$tenantId/$sanitizedEmail/${timestamp}_$sanitizedFileName'; // Tenant isolated path
        
        // AWS Amplify S3 Upload
        await Amplify.Storage.uploadData(
          data: StorageDataPayload.bytes(fileBytes),
          path: StoragePath.fromString(storagePath),
        ).result;
      } catch (e) {
        print('AWS S3 Upload Error: $e');
      }
    }

    try {
      final amplifyFile = AmplifyModels.VaultFiles(
        file_name: fileName,
        storage_path: storagePath,
        uploaded_by: ownerEmail,
        is_encrypted: false,
        data: jsonEncode({
          'upload_date': uploadDate,
          'file_size': fileSize,
          'owner_email': ownerEmail,
          'folder_name': folderName,
          'created_at': DateTime.now().toIso8601String(),
          if (storagePath != null) 'file_path': storagePath,
        }),
      );
      final request = ModelMutations.create(amplifyFile);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Error adding vault file to Amplify: $e');
      await _addLocalFile({
        'file_name': fileName,
        'upload_date': uploadDate,
        'file_size': fileSize,
        'owner_email': ownerEmail,
        'folder_name': folderName,
        'created_at': DateTime.now().toIso8601String(),
        if (storagePath != null) 'file_path': storagePath,
      });
    }
  }

  /// Get Pre-Signed URL from AWS S3
  static Future<String?> getFileUrl(String? filePath) async {
    if (filePath == null) return null;
    try {
      final result = await Amplify.Storage.getUrl(
        path: StoragePath.fromString(filePath),
        options: const StorageGetUrlOptions(
          pluginOptions: S3GetUrlPluginOptions(
            validateObjectExistence: true,
            expiresIn: Duration(hours: 1),
          ),
        ),
      ).result;
      return result.url.toString();
    } catch (e) {
      print('AWS S3 Error getting public url: $e');
      return null;
    }
  }

  /// Delete a vault file
  static Future<void> deleteFile(String id) async {
    try {
      final getReq = ModelQueries.get(
        AmplifyModels.VaultFiles.classType, 
        AmplifyModels.VaultFilesModelIdentifier(id: id)
      );
      final getRes = await Amplify.API.query(request: getReq).response;
      final fileData = getRes.data;

      if (fileData != null) {
        if (fileData.storage_path != null) {
          // Delete from AWS S3
          await Amplify.Storage.remove(
            path: StoragePath.fromString(fileData.storage_path!),
          ).result;
        }

        // Delete from Amplify API using the fetched model (includes _version)
        final delReq = ModelMutations.delete(fileData);
        await Amplify.API.mutate(request: delReq).response;
      }
    } catch (e) {
      print('Error deleting vault file: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> _getLocalFiles(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final String? json = prefs.getString('local_vault_files');
    if (json == null) return [];
    List<dynamic> list = jsonDecode(json);
    return list
      .map((e) => Map<String, dynamic>.from(e))
      .where((f) => f['owner_email'] == email)
      .toList();
  }

  static Future<void> _addLocalFile(Map<String, dynamic> file) async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonStr = prefs.getString('local_vault_files');
    List<dynamic> list = jsonStr != null ? jsonDecode(jsonStr) : [];
    list.add(file);
    await prefs.setString('local_vault_files', jsonEncode(list));
  }

  static Future<void> deleteClientFile(String fileName, String uploadDate, String ownerEmail) async {
    try {
      final request = ModelQueries.list(AmplifyModels.VaultFiles.classType);
      final response = await Amplify.API.query(request: request).response;
      final items = response.data?.items ?? [];
      
      final matches = items.whereType<AmplifyModels.VaultFiles>().where((e) {
        if (e.uploaded_by != ownerEmail) return false;
        if (e.file_name != fileName) return false;
        if (e.data != null) {
          try {
             final d = jsonDecode(e.data!);
             if (d['upload_date'] != uploadDate) return false;
          } catch (_) {}
        }
        return true;
      });

      for (var file in matches) {
        if (file.storage_path != null) {
          await Amplify.Storage.remove(
            path: StoragePath.fromString(file.storage_path!),
          ).result;
        }
        
        // Delete using the full model (includes _version metadata)
        final delReq = ModelMutations.delete(file);
        await Amplify.API.mutate(request: delReq).response;
      }
    } catch (e) {
      print('Error deleting from Amplify: $e');
    }

    // Also delete from local storage
    try {
      final prefs = await SharedPreferences.getInstance();
      const key = 'local_vault_files';
      final String? jsonStr = prefs.getString(key);
      if (jsonStr != null) {
        List<dynamic> list = jsonDecode(jsonStr);
        list.removeWhere((f) => f['file_name'] == fileName && f['upload_date'] == uploadDate && f['owner_email'] == ownerEmail);
        await prefs.setString(key, jsonEncode(list));
      }
    } catch (e) {
      print('Error deleting from local storage: $e');
    }
  }
}
