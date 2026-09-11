import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/docs/v1.dart' as docs;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleDocsService {
  // Using the Web Client ID provided by the user via environment variables
  static String get _webClientId => dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
  // Client secret loaded from environment variables
  static String get _clientSecret => dotenv.env['GOOGLE_CLIENT_SECRET'] ?? '';
  
  static final _scopes = [
    drive.DriveApi.driveScope,
    drive.DriveApi.driveFileScope,
    docs.DocsApi.documentsScope,
  ];

  static AutoRefreshingAuthClient? _authClient;
  static const String _credentialsKey = 'google_docs_credentials';

  static Future<void> _saveCredentials(AccessCredentials credentials) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'accessToken': credentials.accessToken.data,
      'expiry': credentials.accessToken.expiry.toIso8601String(),
      'type': credentials.accessToken.type,
      'refreshToken': credentials.refreshToken,
      'idToken': credentials.idToken,
      'scopes': credentials.scopes,
    };
    await prefs.setString(_credentialsKey, jsonEncode(data));
  }

  static Future<AccessCredentials?> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_credentialsKey);
    if (str == null) return null;
    try {
      final data = jsonDecode(str);
      final accessToken = AccessToken(
        data['type'],
        data['accessToken'],
        DateTime.parse(data['expiry']).toUtc(),
      );
      return AccessCredentials(
        accessToken,
        data['refreshToken'],
        List<String>.from(data['scopes']),
        idToken: data['idToken'],
      );
    } catch (e) {
      print('Error loading credentials: $e');
      return null;
    }
  }

  static Future<String?> signIn() async {
    try {
      final clientId = ClientId(_webClientId, _clientSecret);
      
      final savedCredentials = await _loadCredentials();
      if (savedCredentials != null) {
        _authClient = autoRefreshingClient(clientId, savedCredentials, http.Client());
        return 'Authenticated User';
      }

      // This will open a browser, ask the user to sign in, and redirect to a local server to capture the token.
      _authClient = await clientViaUserConsent(
        clientId, 
        _scopes, 
        (url) async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      );
      
      if (_authClient != null) {
        await _saveCredentials(_authClient!.credentials);
      }
      
      return 'Authenticated User';
    } catch (e) {
      print('Google Sign-In Error: $e');
      return null;
    }
  }

  static Future<void> signOut() async {
    _authClient?.close();
    _authClient = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_credentialsKey);
  }

  static Future<http.Client?> _getAuthenticatedClient() async {
    if (_authClient == null) {
      await signIn();
    }
    return _authClient;
  }

  /// Fetches files from the user's Google Drive. 
  /// Specifically looking for Google Docs (application/vnd.google-apps.document).
  static Future<List<drive.File>> getDriveFiles() async {
    final client = await _getAuthenticatedClient();
    if (client == null) return [];

    try {
      final driveApi = drive.DriveApi(client);
      final response = await driveApi.files.list(
        q: "mimeType='application/vnd.google-apps.document' and trashed=false",
        orderBy: 'modifiedTime desc',
        $fields: 'files(id, name, webViewLink, modifiedTime, iconLink)',
      );
      return response.files ?? [];
    } catch (e) {
      print('Error fetching drive files: $e');
      if (e.toString().contains('invalid_grant') || e.toString().contains('credentials')) {
        await signOut();
        throw Exception('Session expired. Please sign in again.');
      }
      if (e.toString().contains('API has not been used') || e.toString().contains('disabled')) {
        throw Exception('Google Drive API is disabled. Please enable it in Google Cloud Console.');
      }
      return [];
    }
  }

  /// Creates a new Google Doc, optionally inserts text, and returns the WebView link to open it.
  static Future<String?> createNewDocument(String title, {String? content}) async {
    final client = await _getAuthenticatedClient();
    if (client == null) return null;

    try {
      final docsApi = docs.DocsApi(client);
      final docToCreate = docs.Document(title: title);
      final createdDoc = await docsApi.documents.create(docToCreate);
      
      final docId = createdDoc.documentId;
      if (docId != null) {
        // Insert content if provided
        if (content != null && content.isNotEmpty) {
          try {
            final requests = [
              docs.Request(
                insertText: docs.InsertTextRequest(
                  location: docs.Location(index: 1),
                  text: content,
                ),
              )
            ];
            final updateReq = docs.BatchUpdateDocumentRequest(requests: requests);
            await docsApi.documents.batchUpdate(updateReq, docId);
          } catch (e) {
            print('Docs API might not be enabled for text insertion: $e');
          }
        }
        return 'https://docs.google.com/document/d/$docId/edit';
      }
      return null;
    } catch (e, stack) {
      print('Error creating document: $e');
      if (e.toString().contains('invalid_grant') || e.toString().contains('credentials')) {
        await signOut();
        throw Exception('Session expired. Please sign in again.');
      }
      throw Exception(e.toString());
    }
  }

  static Future<bool> deleteDocument(String documentId) async {
    final client = await _getAuthenticatedClient();
    if (client == null) return false;

    try {
      final driveApi = drive.DriveApi(client);
      await driveApi.files.delete(documentId);
      return true;
    } catch (e) {
      print('Error deleting document: $e');
      if (e.toString().contains('invalid_grant') || e.toString().contains('credentials')) {
        await signOut();
        throw Exception('Session expired. Please sign in again.');
      }
      return false;
    }
  }

  /// Reads a Google Doc and extracts its plain text using only the Docs API (bypassing Drive API).
  static Future<String> getDocumentText(String documentId) async {
    final client = await _getAuthenticatedClient();
    if (client == null) throw Exception('Not authenticated');

    try {
      final docsApi = docs.DocsApi(client);
      final doc = await docsApi.documents.get(documentId);
      
      final content = doc.body?.content;
      if (content == null) return '';

      final buffer = StringBuffer();
      for (final element in content) {
        if (element.paragraph != null) {
          final elements = element.paragraph?.elements;
          if (elements != null) {
            for (final el in elements) {
              if (el.textRun != null && el.textRun?.content != null) {
                buffer.write(el.textRun!.content);
              }
            }
          }
        } else if (element.table != null) {
           final rows = element.table?.tableRows;
           if (rows != null) {
             for (final row in rows) {
               final cells = row.tableCells;
               if (cells != null) {
                 for (final cell in cells) {
                   final cellContent = cell.content;
                   if (cellContent != null) {
                     for (final ce in cellContent) {
                       if (ce.paragraph != null && ce.paragraph?.elements != null) {
                         for (final pel in ce.paragraph!.elements!) {
                           if (pel.textRun != null && pel.textRun?.content != null) {
                             buffer.write(pel.textRun!.content);
                           }
                         }
                       }
                     }
                   }
                   buffer.write(' ');
                 }
               }
               buffer.writeln();
             }
           }
        }
      }
      return buffer.toString();
    } catch (e) {
      print('Error reading document: $e');
      if (e.toString().contains('invalid_grant') || e.toString().contains('credentials')) {
        await signOut();
        throw Exception('Session expired. Please sign in again.');
      }
      if (e.toString().contains('API has not been used') || e.toString().contains('disabled')) {
        throw Exception('API is disabled. Please enable it in Google Cloud Console.');
      }
      throw Exception(e.toString());
    }
  }
}
