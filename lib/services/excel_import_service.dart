import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:excel/excel.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'client_service.dart';
import 'case_service.dart';
import 'auth_service.dart';

class ExcelImportResult {
  final int totalRecords;
  final int clientsAdded;
  final int clientsSkipped;
  final int workfilesAdded;
  final int workfilesSkipped;
  final List<String> errors;

  ExcelImportResult({
    required this.totalRecords,
    required this.clientsAdded,
    required this.clientsSkipped,
    required this.workfilesAdded,
    required this.workfilesSkipped,
    required this.errors,
  });
}

class ExcelImportService {
  static const String defaultDownloadsPath = r'C:\Users\adith\Downloads\Cochin United FIle.xlsx';

  /// Parse records from Excel file on disk, or fall back to bundled asset JSON
  Future<List<Map<String, dynamic>>> loadRecords({String? filePath}) async {
    final targetPath = filePath ?? defaultDownloadsPath;
    final file = File(targetPath);

    if (file.existsSync()) {
      try {
        final bytes = await file.readAsBytes();
        final excel = Excel.decodeBytes(bytes);
        final List<Map<String, dynamic>> parsed = [];

        for (final table in excel.tables.keys) {
          final rows = excel.tables[table]?.rows ?? [];
          for (int i = 0; i < rows.length; i++) {
            final row = rows[i];
            if (row.isEmpty) continue;

            final c0 = _cellString(row, 0).toLowerCase();
            final c4 = _cellString(row, 4).toLowerCase();

            // Skip header rows
            if (c0.startsWith('si') || c4 == 'client name') continue;

            final clientName = _cellString(row, 4);
            final fileNo = _cellString(row, 1);
            final caseNo = _cellString(row, 3);

            if (clientName.isNotEmpty) {
              parsed.add({
                'row': i + 1,
                'fileNo': fileNo,
                'year': _cellString(row, 2),
                'caseNo': caseNo,
                'clientName': clientName,
                'clientStatus': _cellString(row, 5),
                'court': _cellString(row, 6),
                'contact': _cellString(row, 7),
                'careOf': _cellString(row, 8),
                'remarks': _cellString(row, 9),
              });
            }
          }
        }

        if (parsed.isNotEmpty) {
          return parsed;
        }
      } catch (e) {
        // In case of file reading issues (e.g. file lock in Excel), fall through to bundled asset
        print('Excel decode error: $e, falling back to bundled JSON asset');
      }
    }

    // Bundled fallback
    try {
      final jsonStr = await rootBundle.loadString('assets/cochin_united_import_data.json');
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      print('Fallback asset error: $e');
      return [];
    }
  }

  String _cellString(List<Data?> row, int index) {
    if (index >= row.length) return '';
    final cell = row[index];
    if (cell == null || cell.value == null) return '';
    return cell.value.toString().trim();
  }

  /// Auto-determine case type based on case number prefix
  String _determineCaseType(String caseNo) {
    final upper = caseNo.toUpperCase().trim();
    if (upper.startsWith('CC') ||
        upper.startsWith('ST') ||
        upper.startsWith('SC') ||
        upper.startsWith('CMP') ||
        upper.contains('CRL') ||
        upper.startsWith('CRIME')) {
      return 'Criminal';
    } else if (upper.contains('MV') || upper.contains('MACT') || upper.contains('OPMV')) {
      return 'Motor Accident';
    } else if (upper.startsWith('OS') ||
        upper.startsWith('OP') ||
        upper.startsWith('CS') ||
        upper.startsWith('EP') ||
        upper.startsWith('MC') ||
        upper.startsWith('RCP') ||
        upper.contains('ARB')) {
      return 'Civil';
    }
    return 'General';
  }

  /// Auto-determine case status based on remarks
  String _determineCaseStatus(String remarks) {
    final r = remarks.trim().toLowerCase();
    if (r == 'complete' || r == 'completed' || r == 'settled' || r == 'disposed') {
      return 'Closed';
    }
    return 'Open';
  }

  /// Import records into Clients and Cases
  Future<ExcelImportResult> importRecords({
    required List<Map<String, dynamic>> records,
    void Function(int current, int total, String status)? onProgress,
  }) async {
    int clientsAdded = 0;
    int clientsSkipped = 0;
    int workfilesAdded = 0;
    int workfilesSkipped = 0;
    final List<String> errors = [];

    // 1. Fetch existing clients and cases for duplicate avoidance
    onProgress?.call(0, records.length, 'Checking existing records...');
    final clientService = ClientService();
    final existingClients = await clientService.getAllClients();
    final existingCases = await CaseService.getCases();

    final existingClientNames = <String>{};
    for (final c in existingClients) {
      final name = (c['name'] ?? '').toString().trim().toLowerCase();
      if (name.isNotEmpty) existingClientNames.add(name);
    }

    final existingCaseKeys = <String>{};
    for (final c in existingCases) {
      final caseNum = (c['case_number'] ?? c['court_case_number'] ?? '').toString().trim().toLowerCase();
      if (caseNum.isNotEmpty) existingCaseKeys.add('num:$caseNum');

      String workfileNo = '';
      if (c['case_description'] != null) {
        try {
          final m = jsonDecode(c['case_description']);
          workfileNo = (m['workfile_no'] ?? '').toString().trim().toLowerCase();
        } catch (_) {}
      }
      if (workfileNo.isEmpty) {
        workfileNo = (c['workfile_no'] ?? '').toString().trim().toLowerCase();
      }
      if (workfileNo.isNotEmpty) existingCaseKeys.add('wf:$workfileNo');
    }

    String currentUserName = 'Excel Import';
    try {
      final authName = await AuthService().getUserName();
      if (authName != null && authName.isNotEmpty) {
        currentUserName = authName;
      }
    } catch (_) {}

    final total = records.length;

    for (int i = 0; i < records.length; i++) {
      final rec = records[i];
      final clientName = (rec['clientName'] ?? '').toString().trim();
      final fileNo = (rec['fileNo'] ?? '').toString().trim();
      final caseNo = (rec['caseNo'] ?? '').toString().trim();
      final year = (rec['year'] ?? '').toString().trim();
      final court = (rec['court'] ?? '').toString().trim();
      final contact = (rec['contact'] ?? '').toString().trim();
      final careOf = (rec['careOf'] ?? '').toString().trim();
      final clientStatus = (rec['clientStatus'] ?? '').toString().trim();
      final remarks = (rec['remarks'] ?? '').toString().trim();

      onProgress?.call(i + 1, total, 'Importing: $clientName ($fileNo)...');

      // Sanitize email
      final sanitizedName = clientName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
      final email = sanitizedName.isNotEmpty
          ? '$sanitizedName@client.cochinunited.com'
          : 'client_${UUID.getUUID().substring(0, 8)}@client.cochinunited.com';

      // --- 1. Client Details ---
      final clientKey = clientName.toLowerCase();
      String clientId = UUID.getUUID();

      if (existingClientNames.contains(clientKey)) {
        clientsSkipped++;
        // Find existing client id
        final match = existingClients.firstWhere(
          (c) => (c['name'] ?? '').toString().trim().toLowerCase() == clientKey,
          orElse: () => {},
        );
        if (match['id'] != null) {
          clientId = match['id'].toString();
        }
      } else {
        try {
          final clientData = {
            'id': clientId,
            'name': clientName,
            'email': email,
            'phone': contact == 'NIL' || contact == 'Nil' ? '' : contact,
            'file_no': fileNo,
            'case_number': caseNo,
            'court_name': court,
            'client_type': clientStatus,
            'care_of': careOf,
            'year': year,
            'case_status': remarks,
            'remarks': remarks,
            'tenant_id': 'TENANT_CUC_001',
          };

          await clientService.addClientFull(clientData);
          existingClientNames.add(clientKey);
          clientsAdded++;
        } catch (e) {
          errors.add('Failed to add client "$clientName": $e');
        }
      }

      // --- 2. Workfile / Case Details ---
      final caseStatus = _determineCaseStatus(remarks);
      final caseType = _determineCaseType(caseNo);
      final caseTitle = caseNo.isNotEmpty ? '$caseNo - $clientName' : '$clientName ($fileNo)';

      final wfKey = 'wf:${fileNo.toLowerCase()}';
      final numKey = caseNo.isNotEmpty ? 'num:${caseNo.toLowerCase()}' : '';

      bool isCaseDuplicate = false;
      if (fileNo.isNotEmpty && existingCaseKeys.contains(wfKey)) {
        isCaseDuplicate = true;
      } else if (numKey.isNotEmpty && existingCaseKeys.contains(numKey)) {
        isCaseDuplicate = true;
      }

      if (isCaseDuplicate) {
        workfilesSkipped++;
      } else {
        try {
          final responsibleStaff = <String>[];
          if (careOf.isNotEmpty && careOf.toLowerCase() != 'care of') {
            responsibleStaff.add(careOf);
          }

          final caseData = {
            'case_title': caseTitle,
            'client_name': clientName,
            'case_type': caseType,
            'case_status': caseStatus,
            'status': caseStatus,
            'court_case_number': caseNo.isNotEmpty ? caseNo : fileNo,
            'case_number': caseNo.isNotEmpty ? caseNo : fileNo,
            'court_details': court,
            'court_name': court,
            'court': court,
            'responsible_staff': responsibleStaff,
            'created_by': currentUserName,
            'year': year,
            'case_year': year,
            'client_status': clientStatus,
            'care_of': careOf,
            'remarks': remarks,
            'case_description': jsonEncode({
              'client_id': clientId,
              'client_name': clientName,
              'client_email': email,
              'workfile_no': fileNo,
              'year': year,
              'court': court,
              'court_name': court,
              'client_status': clientStatus,
              'care_of': careOf,
              'remarks': remarks,
              'contact': contact,
              'case_number': caseNo,
              'vault_documents': [],
            }),
          };

          await CaseService.addCase(caseData);
          if (fileNo.isNotEmpty) existingCaseKeys.add(wfKey);
          if (numKey.isNotEmpty) existingCaseKeys.add(numKey);
          workfilesAdded++;
        } catch (e) {
          errors.add('Failed to add workfile for "$clientName": $e');
        }
      }
    }

    onProgress?.call(records.length, records.length, 'Completed');

    return ExcelImportResult(
      totalRecords: records.length,
      clientsAdded: clientsAdded,
      clientsSkipped: clientsSkipped,
      workfilesAdded: workfilesAdded,
      workfilesSkipped: workfilesSkipped,
      errors: errors,
    );
  }
}
