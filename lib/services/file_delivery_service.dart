import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/file_delivery_model.dart';

class FileDeliveryService {
  static const String _storageKey = 'file_delivery_data';

  static Future<List<FileDeliveryModel>> getDeliveries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataString = prefs.getString(_storageKey);
      if (dataString == null || dataString.isEmpty) {
        return [];
      }
      final List<dynamic> jsonList = jsonDecode(dataString);
      return jsonList
          .map((e) => FileDeliveryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching file deliveries: $e');
      return [];
    }
  }

  static Future<void> createDelivery(FileDeliveryModel delivery) async {
    try {
      final deliveries = await getDeliveries();
      deliveries.insert(0, delivery);
      await _saveDeliveries(deliveries);
    } catch (e) {
      print('Error creating file delivery: $e');
      rethrow;
    }
  }

  static Future<void> updateDelivery(FileDeliveryModel updatedDelivery) async {
    try {
      final deliveries = await getDeliveries();
      final index = deliveries.indexWhere((d) => d.id == updatedDelivery.id);
      if (index != -1) {
        deliveries[index] = updatedDelivery;
        await _saveDeliveries(deliveries);
      }
    } catch (e) {
      print('Error updating file delivery: $e');
      rethrow;
    }
  }

  static Future<void> deleteDelivery(String id) async {
    try {
      final deliveries = await getDeliveries();
      deliveries.removeWhere((d) => d.id == id);
      await _saveDeliveries(deliveries);
    } catch (e) {
      print('Error deleting file delivery: $e');
      rethrow;
    }
  }

  static Future<void> _saveDeliveries(
    List<FileDeliveryModel> deliveries,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = deliveries.map((d) => d.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }
}
