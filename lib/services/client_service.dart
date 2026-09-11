import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/Clients.dart' as AmplifyClients;
import '../models/client.dart';

class ClientService {
  static Future<String?> _getTenantId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('tenant_id') ?? 'TENANT_CUC_001';
  }
  Future<List<Map<String, dynamic>>> searchClients(String query) async {
    List<Map<String, dynamic>> allResults = [];
    try {
      final request = ModelQueries.list(AmplifyClients.Clients.classType);
      final response = await Amplify.API.query(request: request).response;
      final items = response.data?.items ?? [];
      
      final amplifyResults = items.where((c) => c != null && c.name != null && c.name!.toLowerCase().contains(query.toLowerCase())).map((c) {
        return {
          'id': c!.id,
          'name': c.name,
          'email': c.email,
          'phone': c.phone,
          'address': c.address,
          'type_of_work': c.type_of_work,
          'balance_due': c.balance_due,
          'data': c.data != null ? jsonDecode(c.data!) : null,
        };
      }).toList();
      final tenantId = await _getTenantId();
      final filteredAmplify = amplifyResults.where((r) {
        if (r['name'] == 'Alexander Sterling' || r['name'] == 'Eleanor Vance') return false;
        final t = r['data'] is Map ? r['data']['tenant_id'] : null;
        return t == null || t == tenantId;
      }).toList();
      allResults.addAll(filteredAmplify);

    } catch (e) {
      // ignore
      print('Error searching amplify clients: $e');
    }
    
    final localResults = await _searchClientsLocal(query);
    for (var local in localResults) {
      if (!allResults.any((r) => r['name'] == local['name'])) {
        allResults.add(local);
      }
    }
    return allResults;
  }
  
  Future<List<Map<String, dynamic>>> getAllClients() async {
    List<Map<String, dynamic>> allResults = [];
    try {
      final request = ModelQueries.list(AmplifyClients.Clients.classType);
      final response = await Amplify.API.query(request: request).response;
      final items = response.data?.items ?? [];
      
      final amplifyResults = items.where((c) => c != null).map((c) {
        final Map<String, dynamic> decodedData = c!.data != null ? jsonDecode(c.data!) : {};
        return {
          'id': c.id,
          'name': c.name,
          'email': c.email,
          'phone': c.phone,
          'address': c.address,
          'type_of_work': c.type_of_work,
          'balance_due': c.balance_due,
          ...decodedData,
        };
      }).toList();
      
      amplifyResults.sort((a, b) => (a['name']?.toString() ?? '').compareTo(b['name']?.toString() ?? ''));
      final tenantId = await _getTenantId();
      final filteredAmplify = amplifyResults.where((r) {
        if (r['name'] == 'Alexander Sterling' || r['name'] == 'Eleanor Vance') return false;
        final t = r['tenant_id'];
        return t == null || t == tenantId;
      }).toList();
      allResults.addAll(filteredAmplify);

    } catch (e) {
      // ignore
    }
    
    final localResults = await _getAllClientsLocal();
    for (var local in localResults) {
      if (!allResults.any((r) => r['name'] == local['name'])) {
        allResults.add(local);
      }
    }
    return allResults;
  }

  Future<Map<String, dynamic>?> addClient(String name, String email) async {
    try {
      final tenantId = await _getTenantId();
      final amplifyClient = AmplifyClients.Clients(
        name: name,
        email: email,
        data: jsonEncode({'tenant_id': tenantId}),
      );
      final request = ModelMutations.create(amplifyClient);
      final response = await Amplify.API.mutate(request: request).response;
      final c = response.data;
      if (c == null) {
        return await _addClientLocal({'name': name, 'email': email});
      }
      
      await _addClientLocal({'name': name, 'email': email, 'tenant_id': tenantId});
      
      return {
        'id': c.id,
        'name': c.name,
        'email': c.email,
      };
    } catch (e) {
      return await _addClientLocal({'name': name, 'email': email});
    }
  }

  Future<Map<String, dynamic>?> addClientFull(Map<String, dynamic> clientData) async {
    try {
      clientData['tenant_id'] = await _getTenantId();
      final amplifyClient = AmplifyClients.Clients(
        name: clientData['name']?.toString(),
        email: clientData['email']?.toString(),
        phone: clientData['phone']?.toString(),
        address: clientData['address']?.toString(),
        type_of_work: clientData['type_of_work']?.toString(),
        balance_due: clientData['balance_due']?.toString(),
        data: jsonEncode(clientData),
      );
      final request = ModelMutations.create(amplifyClient);
      final response = await Amplify.API.mutate(request: request).response;
      final c = response.data;
      if (c == null) {
        return await _addClientLocal(clientData);
      }
      
      await _addClientLocal(clientData);
      
      return {
        'id': c.id,
        'name': c.name,
        'email': c.email,
        'phone': c.phone,
        'address': c.address,
        'type_of_work': c.type_of_work,
        'balance_due': c.balance_due,
      };
    } catch (e) {
      return _addClientLocal(clientData);
    }
  }

  Future<List<Map<String, dynamic>>> _getAllClientsLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final String? clientsJson = prefs.getString('local_clients');
    if (clientsJson == null) return [];
    List<dynamic> list = jsonDecode(clientsJson);
    final tenantId = await _getTenantId();
    return list.map((e) => Map<String, dynamic>.from(e)).where((c) {
      if (c['name'] == 'Alexander Sterling' || c['name'] == 'Eleanor Vance') return false;
      return c['tenant_id'] == tenantId;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _searchClientsLocal(String query) async {
    final all = await _getAllClientsLocal();
    if (query.isEmpty) return all;
    return all.where((c) => (c['name'] ?? '').toString().toLowerCase().contains(query.toLowerCase())).toList();
  }

  Future<Map<String, dynamic>> _addClientLocal(Map<String, dynamic> clientData) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await _getAllClientsLocal();
    clientData['tenant_id'] = await _getTenantId();
    all.add(clientData);
    await prefs.setString('local_clients', jsonEncode(all));
    return clientData;
  }

  static Future<void> updateClient(String id, Map<String, dynamic> clientData) async {
    clientData['tenant_id'] = await _getTenantId();
    try {
      final amplifyClient = AmplifyClients.Clients(
        id: id,
        name: clientData['name']?.toString(),
        email: clientData['email']?.toString(),
        phone: clientData['phone']?.toString(),
        address: clientData['address']?.toString(),
        type_of_work: clientData['type_of_work']?.toString(),
        balance_due: clientData['balance_due']?.toString(),
        data: jsonEncode(clientData),
      );
      final request = ModelMutations.update(amplifyClient);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Error updating client: $e');
    }
  }

  static Future<void> deleteClient(String id) async {
    bool amplifySuccess = false;
    try {
      final request = ModelMutations.deleteById(
        AmplifyClients.Clients.classType,
        AmplifyClients.ClientsModelIdentifier(id: id),
      );
      final response = await Amplify.API.mutate(request: request).response;
      if (response.hasErrors) {
        throw Exception('GraphQL errors: ${response.errors}');
      }
      amplifySuccess = true;
    } catch (e) {
      print('Error deleting client from Amplify: $e');
      throw Exception('Amplify Error: $e');
    }

    bool localSuccess = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? clientsJson = prefs.getString('local_clients');
      if (clientsJson != null) {
        List<dynamic> list = jsonDecode(clientsJson);
        final initialLength = list.length;
        list.removeWhere((c) => c['id'] == id);
        if (list.length < initialLength) {
          await prefs.setString('local_clients', jsonEncode(list));
          localSuccess = true;
        }
      }
    } catch (e) {
      print('Error deleting client from local: $e');
    }

    if (!amplifySuccess && !localSuccess) {
      throw Exception('Failed to delete client');
    }
  }
}
