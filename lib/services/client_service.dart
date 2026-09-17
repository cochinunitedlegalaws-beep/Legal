import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/Clients.dart' as AmplifyClients;

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
        final Map<String, dynamic> decodedData = c!.data != null ? jsonDecode(c.data!) : {};
        return {
          ...decodedData,
          'id': c.id,
          'name': c.name,
          'email': c.email,
          'phone': c.phone,
          'address': c.address,
          'type_of_work': c.type_of_work,
          'balance_due': c.balance_due,
        };
      }).toList();
      final tenantId = await _getTenantId();
      final filteredAmplify = amplifyResults.where((r) {
        if (r['name'] == 'Alexander Sterling' || r['name'] == 'Eleanor Vance') return false;
        final t = r['tenant_id'];
        return t == null || t == tenantId;
      }).toList();
      allResults.addAll(filteredAmplify);

    } catch (e) {
      // ignore
      print('Error searching amplify clients: $e');
    }
    
    final localResults = await _searchClientsLocal(query);
    for (var local in localResults) {
      if (!allResults.any((r) => (local['id'] != null && r['id'] == local['id']) || r['name'] == local['name'])) {
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
          ...decodedData,
          'id': c.id,
          'name': c.name,
          'email': c.email,
          'phone': c.phone,
          'address': c.address,
          'type_of_work': c.type_of_work,
          'balance_due': c.balance_due,
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
      if (!allResults.any((r) => (local['id'] != null && r['id'] == local['id']) || r['name'] == local['name'])) {
        if (local['id'] == null || local['id'].toString().isEmpty) {
          local['id'] = UUID.getUUID();
        }
        allResults.add(local);
      }
    }
    return allResults;
  }

  Future<Map<String, dynamic>?> addClient(String name, String email) async {
    final newId = UUID.getUUID();
    final tenantId = await _getTenantId();
    try {
      final amplifyClient = AmplifyClients.Clients(
        id: newId,
        name: name,
        email: email,
        data: jsonEncode({'tenant_id': tenantId}),
      );
      final request = ModelMutations.create(amplifyClient);
      final response = await Amplify.API.mutate(request: request).response;
      final c = response.data;
      final actualId = c?.id ?? newId;
      await _addClientLocal({'id': actualId, 'name': name, 'email': email, 'tenant_id': tenantId});
      
      return {
        'id': actualId,
        'name': c?.name ?? name,
        'email': c?.email ?? email,
      };
    } catch (e) {
      return await _addClientLocal({'id': newId, 'name': name, 'email': email, 'tenant_id': tenantId});
    }
  }

  Future<Map<String, dynamic>?> addClientFull(Map<String, dynamic> clientData) async {
    final newId = clientData['id']?.toString() ?? UUID.getUUID();
    clientData['id'] = newId;
    final tenantId = await _getTenantId();
    clientData['tenant_id'] = tenantId;
    try {
      final amplifyClient = AmplifyClients.Clients(
        id: newId,
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
      final actualId = c?.id ?? newId;
      clientData['id'] = actualId;
      await _addClientLocal(clientData);
      
      return {
        'id': actualId,
        'name': c?.name ?? clientData['name'],
        'email': c?.email ?? clientData['email'],
        'phone': c?.phone ?? clientData['phone'],
        'address': c?.address ?? clientData['address'],
        'type_of_work': c?.type_of_work ?? clientData['type_of_work'],
        'balance_due': c?.balance_due ?? clientData['balance_due'],
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
    bool needsSave = false;
    final List<Map<String, dynamic>> parsed = [];
    for (var e in list) {
      final map = Map<String, dynamic>.from(e);
      if (map['id'] == null || map['id'].toString().isEmpty) {
        map['id'] = UUID.getUUID();
        needsSave = true;
      }
      if (map['tenant_id'] == null) {
        map['tenant_id'] = tenantId;
        needsSave = true;
      }
      if (map['name'] == 'Alexander Sterling' || map['name'] == 'Eleanor Vance') {
        continue;
      }
      if (map['tenant_id'] == tenantId) {
        parsed.add(map);
      }
    }
    if (needsSave) {
      final updatedList = list.map((e) {
        final map = Map<String, dynamic>.from(e);
        if (map['id'] == null || map['id'].toString().isEmpty) {
          map['id'] = UUID.getUUID();
        }
        if (map['tenant_id'] == null) {
          map['tenant_id'] = tenantId;
        }
        return map;
      }).toList();
      await prefs.setString('local_clients', jsonEncode(updatedList));
    }
    return parsed;
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
    if (clientData['id'] == null || clientData['id'].toString().isEmpty) {
      clientData['id'] = UUID.getUUID();
    }
    final existingIndex = all.indexWhere((c) =>
      (clientData['id'] != null && c['id'] == clientData['id']) ||
      (clientData['name'] != null && c['name'] == clientData['name'])
    );
    if (existingIndex >= 0) {
      all[existingIndex] = clientData;
    } else {
      all.add(clientData);
    }
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

  static Future<void> deleteClient(String? id, {String? name, String? email}) async {
    if (id != null && id.isNotEmpty) {
      try {
        final getRequest = ModelQueries.get(
          AmplifyClients.Clients.classType,
          AmplifyClients.ClientsModelIdentifier(id: id),
        );
        final getResponse = await Amplify.API.query(request: getRequest).response;
        final existingClient = getResponse.data;

        if (existingClient != null) {
          final deleteRequest = ModelMutations.delete(existingClient);
          final deleteResponse = await Amplify.API.mutate(request: deleteRequest).response;
          if (deleteResponse.hasErrors) {
            print('GraphQL errors during delete: ${deleteResponse.errors}');
          }
        }
      } catch (e) {
        print('Error deleting client from Amplify: $e');
      }
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? clientsJson = prefs.getString('local_clients');
      if (clientsJson != null) {
        List<dynamic> list = jsonDecode(clientsJson);
        list.removeWhere((c) {
          if (id != null && id.isNotEmpty && c['id'] == id) return true;
          if (name != null && name.isNotEmpty && c['name'] == name) return true;
          if (email != null && email.isNotEmpty && c['email'] == email) return true;
          return false;
        });
        await prefs.setString('local_clients', jsonEncode(list));
      }
    } catch (e) {
      print('Error deleting client from local: $e');
    }
  }
}
