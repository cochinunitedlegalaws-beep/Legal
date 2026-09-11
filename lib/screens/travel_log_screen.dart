import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_app_bar.dart';
import '../models/Expenses.dart';
import '../widgets/responsive.dart';

class TravelLogScreen extends StatefulWidget {
  const TravelLogScreen({super.key});

  @override
  State<TravelLogScreen> createState() => _TravelLogScreenState();
}

class _TravelLogScreenState extends State<TravelLogScreen> {
  List<Map<String, dynamic>> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    setState(() => _isLoading = true);
    try {
      final request = ModelQueries.list(Expenses.classType, where: Expenses.CATEGORY.eq('Travel Log'));
      final response = await Amplify.API.query(request: request).response;
      
      final items = response.data?.items.whereType<Expenses>().toList() ?? [];
      
      List<Map<String, dynamic>> mappedLogs = items.map((e) {
        Map<String, dynamic> dataMap = {};
        if (e.data != null) {
          try { dataMap = jsonDecode(e.data!); } catch (_) {}
        }
        
        return {
          'user_id': dataMap['user_id'] ?? 'Unknown Staff',
          'destination': dataMap['destination'] ?? e.title ?? 'Unknown Destination',
          'purpose': dataMap['purpose'] ?? e.description,
          'expense': num.tryParse(e.amount ?? dataMap['expense']?.toString() ?? '0') ?? 0,
          'created_at': e.createdAt?.format() ?? DateTime.now().toIso8601String(),
        };
      }).toList();
      
      mappedLogs.sort((a, b) => b['created_at'].compareTo(a['created_at']));

      if (mounted) {
        setState(() {
          _logs = mappedLogs;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching travel logs: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load travel logs: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: const PremiumAppBar(
        title: Text('Staff Travel Logs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
              ? const Center(child: Text('No travel logs found.', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    final log = _logs[index];
                    final userId = log['user_id'] as String? ?? 'Unknown Staff';
                    final destination = log['destination'] as String? ?? 'Unknown Destination';
                    final purpose = log['purpose'] as String?;
                    final expense = log['expense'] as num?;
                    
                    String dateString = log['created_at'];
                    if (!dateString.endsWith('Z') && !dateString.contains('+')) {
                      dateString += 'Z';
                    }
                    final createdAt = DateTime.parse(dateString).toLocal();
                    final timeString = DateFormat('hh:mm a, MMM dd yyyy').format(createdAt);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: const CircleAvatar(
                          backgroundColor: AppTheme.primaryColor,
                          child: Icon(Icons.directions_car, color: Colors.white),
                        ),
                        title: Text(
                          destination,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (purpose != null && purpose.isNotEmpty) ...[
                                Text('Purpose: $purpose', style: const TextStyle(fontStyle: FontStyle.italic)),
                                const SizedBox(height: 4),
                              ],
                              Row(
                                children: [
                                  const Icon(Icons.person, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(userId, style: const TextStyle(fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(timeString, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                    ],
                                  ),
                                  if (expense != null && expense > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '₹$expense',
                                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
