import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/document_template.dart';
import '../models/client.dart';
import '../models/case_model.dart';
import 'package:intl/intl.dart';

class DocumentAutomationService {
  static const _localKey = 'local_templates_db';

  static Future<List<DocumentTemplate>> getTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_localKey);
    if (jsonStr == null) {
      // Return some default templates
      return _getDefaultTemplates();
    }
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => DocumentTemplate.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return _getDefaultTemplates();
    }
  }

  static Future<void> addTemplate(DocumentTemplate template) async {
    final templates = await getTemplates();
    templates.add(template);
    await _saveLocalTemplates(templates);
  }
  
  static Future<void> deleteTemplate(String id) async {
    final templates = await getTemplates();
    templates.removeWhere((t) => t.id == id);
    await _saveLocalTemplates(templates);
  }

  static Future<void> _saveLocalTemplates(List<DocumentTemplate> templates) async {
    final prefs = await SharedPreferences.getInstance();
    final listStr = jsonEncode(templates.map((e) => e.toJson()).toList());
    await prefs.setString(_localKey, listStr);
  }

  static String generateDocument(DocumentTemplate template, {Client? client, CaseFile? caseFile}) {
    String filledContent = template.content;

    // Date Variables
    final now = DateTime.now();
    filledContent = filledContent.replaceAll('[Date]', DateFormat('MMMM d, yyyy').format(now));
    filledContent = filledContent.replaceAll('[ShortDate]', DateFormat('MM/dd/yyyy').format(now));

    // Client Variables
    if (client != null) {
      filledContent = filledContent.replaceAll('[ClientName]', client.name ?? '');
      filledContent = filledContent.replaceAll('[ClientEmail]', client.email ?? '');
      filledContent = filledContent.replaceAll('[ClientPhone]', client.phone ?? '');
      filledContent = filledContent.replaceAll('[ClientAddress]', client.address ?? '');
      filledContent = filledContent.replaceAll('[ClientCompany]', client.name ?? ''); // Using name as fallback for company
    }

    // Case Variables
    if (caseFile != null) {
      filledContent = filledContent.replaceAll('[CaseTitle]', caseFile.caseTitle);
      filledContent = filledContent.replaceAll('[CaseNumber]', caseFile.courtCaseNumber);
      filledContent = filledContent.replaceAll('[CaseStatus]', caseFile.caseStatus);
      filledContent = filledContent.replaceAll('[CourtName]', caseFile.courtName);
      filledContent = filledContent.replaceAll('[OpposingParty]', caseFile.opposingParty);
      filledContent = filledContent.replaceAll('[OpposingCounsel]', caseFile.opposingCounsel);
      filledContent = filledContent.replaceAll('[JudgeName]', caseFile.courtName); // Fallback to courtName
    }

    return filledContent;
  }

  static List<DocumentTemplate> _getDefaultTemplates() {
    return [
      DocumentTemplate(
        id: 'default-1',
        title: 'Notice of Appearance',
        category: 'Litigation',
        content: '''IN THE [CourtName]

CASE NO: [CaseNumber]

[ClientName],
      Plaintiff/Defendant,
v.

[OpposingParty],
      Defendant/Plaintiff.
      
NOTICE OF APPEARANCE

COMES NOW the undersigned attorney and hereby enters their appearance as counsel of record for [ClientName] in the above-styled matter. 

Please direct all future correspondence, pleadings, and notices to the undersigned at the address provided below.

Respectfully submitted this [Date].

________________________
Attorney for [ClientName]
Cochin United Law Firm
''',
        
      ),
      DocumentTemplate(
        id: 'default-2',
        title: 'Client Engagement Letter',
        category: 'General',
        content: '''[Date]

[ClientName]
[ClientCompany]
[ClientAddress]

RE: Engagement for Legal Services - [CaseTitle]

Dear [ClientName],

Thank you for choosing Cochin United Law Firm to represent you regarding [CaseTitle]. This letter confirms the terms of our engagement.

Scope of Representation:
We will provide legal services in connection with [CaseTitle]. Our representation does not cover matters outside this specific scope unless explicitly agreed upon in writing.

Communication:
We will keep you informed of the progress of your case. You may reach us at any time, and we will do our best to return your calls promptly.

Please sign below to indicate your agreement to these terms.

Sincerely,
Cochin United Law Firm

________________________
[ClientName]
Date: [Date]
''',
        
      )
    ];
  }
}
