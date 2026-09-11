import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/chamber_document.dart';
import '../models/document_audit_log.dart';
import '../models/ChamberDocuments.dart' as AmplifyModels;
import '../models/DocumentAuditLogs.dart' as AmplifyModels;

/// Centralized persistence layer for chamber documents and audit logs.
/// All documents are stored in AWS Amplify (DynamoDB).
class DocumentService {
  DocumentService._();

  // ─────────────────────── Document CRUD ───────────────────────

  /// Retrieve all chamber documents.
  static Future<List<ChamberDocument>> getAllDocuments() async {
    try {
      final request = ModelQueries.list(AmplifyModels.ChamberDocuments.classType);
      final response = await Amplify.API.query(request: request).response;
      
      if (response.hasErrors) {
        print('Error fetching documents from Amplify: ${response.errors}');
        return [];
      }
      
      final items = response.data?.items ?? [];
      
      return items.whereType<AmplifyModels.ChamberDocuments>().map((e) {
        final dataMap = e.data != null ? jsonDecode(e.data!) : <String, dynamic>{};
        return ChamberDocument.fromJson({
          'id': e.id,
          'title': e.title ?? '',
          'category': e.category ?? '',
          'encrypted_content': dataMap['encrypted_content'] ?? dataMap['encryptedContent'],
          'created_by': dataMap['created_by'] ?? dataMap['createdBy'],
          'created_at': dataMap['created_at'] ?? dataMap['createdAt'] ?? e.createdAt?.format(),
          'last_edited_by': dataMap['last_edited_by'] ?? dataMap['lastEditedBy'],
          'last_edited_at': dataMap['last_edited_at'] ?? dataMap['lastEditedAt'] ?? e.updatedAt?.format(),
        });
      }).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      print('Error fetching documents: $e');
      return [];
    }
  }

  /// Save (insert or update) a document.
  static Future<void> saveDocument(ChamberDocument doc) async {
    try {
      // Create amplify model representation
      final amplifyDoc = AmplifyModels.ChamberDocuments(
        id: doc.id,
        title: doc.title,
        category: doc.category,
        data: jsonEncode({
          'encrypted_content': doc.encryptedContent,
          'created_by': doc.createdBy,
          'created_at': doc.createdAt.toIso8601String(),
          'last_edited_by': doc.lastEditedBy,
          'last_edited_at': doc.lastEditedAt.toIso8601String(),
        }),
      );

      // Try update first (Amplify doesn't have upsert directly out-of-box with the same signature easily)
      final getReq = ModelQueries.get(AmplifyModels.ChamberDocuments.classType, AmplifyModels.ChamberDocumentsModelIdentifier(id: doc.id));
      final getRes = await Amplify.API.query(request: getReq).response;
      
      if (getRes.data != null) {
        // Exists, update it
        final request = ModelMutations.update(amplifyDoc);
        await Amplify.API.mutate(request: request).response;
      } else {
        // Does not exist, create it
        final request = ModelMutations.create(amplifyDoc);
        await Amplify.API.mutate(request: request).response;
      }
    } catch (e) {
      print('Error saving document: $e');
    }
  }

  /// Delete a document by ID.
  static Future<void> deleteDocument(String id) async {
    try {
      final request = ModelMutations.deleteById(
        AmplifyModels.ChamberDocuments.classType,
        AmplifyModels.ChamberDocumentsModelIdentifier(id: id)
      );
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  // ─────────────────────── Audit Logging ───────────────────────

  /// Append a new audit event.
  static Future<void> logAuditEvent(DocumentAuditLog log) async {
    try {
      final amplifyLog = AmplifyModels.DocumentAuditLogs(
        action: log.action.name,
        details: log.details,
        data: jsonEncode({
          'document_id': log.documentId, // String, so we put it in JSON to avoid type mismatch with integer
          'document_title': log.documentTitle,
          'performed_by': log.performedBy,
          'performed_at': log.performedAt.toIso8601String(),
        })
      );
      final request = ModelMutations.create(amplifyLog);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Error logging audit event: $e');
    }
  }

  /// Retrieve all audit logs, optionally filtered by documentId.
  static Future<List<DocumentAuditLog>> getAuditLogs({String? documentId}) async {
    try {
      final request = ModelQueries.list(AmplifyModels.DocumentAuditLogs.classType);
      final response = await Amplify.API.query(request: request).response;
      
      final items = response.data?.items ?? [];
      
      final parsedLogs = items.whereType<AmplifyModels.DocumentAuditLogs>().map((e) {
        final dataMap = e.data != null ? jsonDecode(e.data!) : <String, dynamic>{};
        return DocumentAuditLog.fromJson({
          'documentId': dataMap['document_id'] ?? '',
          'documentTitle': dataMap['document_title'] ?? '',
          'action': e.action ?? 'view',
          'performedBy': dataMap['performed_by'] ?? '',
          'performedAt': dataMap['performed_at'] ?? '',
          'details': e.details ?? '',
        });
      }).toList();

      if (documentId != null) {
        parsedLogs.retainWhere((l) => l.documentId == documentId);
      }
      
      parsedLogs.sort((a, b) => b.performedAt.compareTo(a.performedAt));
      return parsedLogs;
    } catch (e) {
      print('Error fetching audit logs: $e');
      return [];
    }
  }
}
