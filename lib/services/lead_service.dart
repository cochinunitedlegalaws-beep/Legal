import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/lead_model.dart';
import '../models/Leads.dart' as AmplifyModels;

class LeadService {
  static const _localKey = 'local_leads_db';

  static Future<List<Lead>> getLeads() async {
    List<Lead> allLeads = [];
    try {
      final request = ModelQueries.list(AmplifyModels.Leads.classType);
      final response = await Amplify.API.query(request: request).response;
      final items = response.data?.items ?? [];

      allLeads.addAll(items.whereType<AmplifyModels.Leads>().map((e) {
        final dataMap = e.data != null ? jsonDecode(e.data!) : <String, dynamic>{};
        return Lead.fromJson({
          'id': e.id,
          'name': e.name ?? '',
          'phone': e.phone ?? '',
          'email': e.email ?? '',
          'source': e.source ?? '',
          'inquiryType': dataMap['inquiry_type'] ?? '',
          'notes': dataMap['notes'] ?? '',
          'status': e.status ?? '',
          'createdAt': dataMap['created_at'] ?? DateTime.now().toIso8601String(),
          'lastModifiedAt': dataMap['last_modified_at'] ?? DateTime.now().toIso8601String(),
        });
      }).toList());
      
      allLeads.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      print('Failed to fetch leads from Amplify: $e');
    }

    final localLeads = await _getLocalLeads();
    for (var local in localLeads) {
      if (!allLeads.any((l) => l.id == local.id)) {
        allLeads.add(local);
      }
    }
    return allLeads;
  }

  static Future<void> addLead(Lead lead) async {
    try {
      final amplifyLead = AmplifyModels.Leads(
        id: lead.id,
        name: lead.name,
        email: lead.email,
        phone: lead.phone,
        status: lead.status,
        source: lead.source,
        data: jsonEncode({
          'inquiry_type': lead.inquiryType,
          'notes': lead.notes,
          'created_at': lead.createdAt.toIso8601String(),
          'last_modified_at': lead.lastModifiedAt.toIso8601String(),
        })
      );
      final request = ModelMutations.create(amplifyLead);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Saving lead locally: $e');
      final leads = await _getLocalLeads();
      leads.add(lead);
      await _saveLocalLeads(leads);
    }
  }

  static Future<void> updateLead(Lead lead) async {
    lead.lastModifiedAt = DateTime.now();
    try {
      final amplifyLead = AmplifyModels.Leads(
        id: lead.id,
        name: lead.name,
        email: lead.email,
        phone: lead.phone,
        status: lead.status,
        source: lead.source,
        data: jsonEncode({
          'inquiry_type': lead.inquiryType,
          'notes': lead.notes,
          'created_at': lead.createdAt.toIso8601String(),
          'last_modified_at': lead.lastModifiedAt.toIso8601String(),
        })
      );
      final request = ModelMutations.update(amplifyLead);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Updating lead locally: $e');
      final leads = await _getLocalLeads();
      final index = leads.indexWhere((l) => l.id == lead.id);
      if (index != -1) {
        leads[index] = lead;
        await _saveLocalLeads(leads);
      }
    }
  }

  static Future<void> deleteLead(String id) async {
    try {
      // Fetch full model first to get _version metadata
      final getRequest = ModelQueries.get(
        AmplifyModels.Leads.classType,
        AmplifyModels.LeadsModelIdentifier(id: id),
      );
      final getResponse = await Amplify.API.query(request: getRequest).response;
      final existingLead = getResponse.data;

      if (existingLead != null) {
        final deleteRequest = ModelMutations.delete(existingLead);
        await Amplify.API.mutate(request: deleteRequest).response;
      }
    } catch (e) {
      print('Deleting lead locally: $e');
      final leads = await _getLocalLeads();
      leads.removeWhere((l) => l.id == id);
      await _saveLocalLeads(leads);
    }
  }

  static Future<List<Lead>> _getLocalLeads() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_localKey);
    if (jsonStr == null) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => Lead.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> _saveLocalLeads(List<Lead> leads) async {
    final prefs = await SharedPreferences.getInstance();
    final listStr = jsonEncode(leads.map((e) => e.toJson()).toList());
    await prefs.setString(_localKey, listStr);
  }
}
