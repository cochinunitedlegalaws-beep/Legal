import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/communication_log.dart';
import '../services/communication_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/responsive.dart';

class CommunicationLogScreen extends StatefulWidget {
  final String? relatedToId;
  const CommunicationLogScreen({super.key, this.relatedToId});

  @override
  State<CommunicationLogScreen> createState() => _CommunicationLogScreenState();
}

class _CommunicationLogScreenState extends State<CommunicationLogScreen> {
  List<CommunicationLog> _logs = [];
  bool _isLoading = true;
  String _currentUser = 'System';

  @override
  void initState() {
    super.initState();
    _initUser();
    _loadLogs();
  }

  Future<void> _initUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _currentUser = prefs.getString('user_email')?.split('@')[0] ?? 'System';
      });
    }
  }

  Future<void> _loadLogs() async {
    setState(() => _isLoading = true);
    final logs = await CommunicationService.getLogs(relatedToId: widget.relatedToId);
    if (mounted) {
      setState(() {
        _logs = logs;
        _isLoading = false;
      });
    }
  }

  void _showAddLogDialog() {
    final contactController = TextEditingController();
    final summaryController = TextEditingController();
    String selectedType = 'Phone Call';
    String selectedDirection = 'Outbound';
    String relatedType = 'Client';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: AppTheme.surfaceColor,
              title: const Text('Log Communication', style: TextStyle(color: AppTheme.accentColor, fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.relatedToId == null) ...[
                      DropdownButtonFormField<String>(
                        value: relatedType,
                        dropdownColor: AppTheme.primaryColor,
                        style: const TextStyle(color: AppTheme.textPrimary, fontFamily: 'Montserrat'),
                        decoration: InputDecoration(
                          labelText: 'Related To',
                          labelStyle: const TextStyle(color: AppTheme.textSecondary),
                          filled: true,
                          fillColor: AppTheme.secondaryColor,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                        items: ['Client', 'Case', 'Other'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (val) => setStateDialog(() => relatedType = val!),
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextField(
                      controller: contactController,
                      style: const TextStyle(color: AppTheme.textPrimary, fontFamily: 'Montserrat'),
                      decoration: InputDecoration(
                        labelText: 'Contact Person / Reference',
                        labelStyle: const TextStyle(color: AppTheme.textSecondary),
                        filled: true,
                        fillColor: AppTheme.secondaryColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedType,
                            dropdownColor: AppTheme.primaryColor,
                            style: const TextStyle(color: AppTheme.textPrimary, fontFamily: 'Montserrat'),
                            decoration: InputDecoration(
                              labelText: 'Type',
                              labelStyle: const TextStyle(color: AppTheme.textSecondary),
                              filled: true,
                              fillColor: AppTheme.secondaryColor,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            ),
                            items: ['Phone Call', 'Email', 'In-Person', 'WhatsApp', 'Letter'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                            onChanged: (val) => setStateDialog(() => selectedType = val!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedDirection,
                            dropdownColor: AppTheme.primaryColor,
                            style: const TextStyle(color: AppTheme.textPrimary, fontFamily: 'Montserrat'),
                            decoration: InputDecoration(
                              labelText: 'Direction',
                              labelStyle: const TextStyle(color: AppTheme.textSecondary),
                              filled: true,
                              fillColor: AppTheme.secondaryColor,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            ),
                            items: ['Inbound', 'Outbound'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                            onChanged: (val) => setStateDialog(() => selectedDirection = val!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: summaryController,
                      maxLines: 3,
                      style: const TextStyle(color: AppTheme.textPrimary, fontFamily: 'Montserrat'),
                      decoration: InputDecoration(
                        labelText: 'Summary / Notes',
                        labelStyle: const TextStyle(color: AppTheme.textSecondary),
                        filled: true,
                        fillColor: AppTheme.secondaryColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL', style: TextStyle(color: AppTheme.textSecondary, fontFamily: 'Montserrat')),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor, foregroundColor: Colors.white),
                  onPressed: () async {
                    if (contactController.text.trim().isEmpty) return;
                    
                    final newLog = CommunicationLog(
                      id: CommunicationLog.generateId(),
                      relatedToId: widget.relatedToId ?? contactController.text.trim(),
                      relatedToType: widget.relatedToId != null ? 'Case/Client' : relatedType,
                      contactName: contactController.text.trim(),
                      type: selectedType,
                      direction: selectedDirection,
                      summary: summaryController.text.trim(),
                      staffName: _currentUser,
                      timestamp: DateTime.now(),
                    );
                    
                    await CommunicationService.addLog(newLog);
                    Navigator.pop(context);
                    _loadLogs();
                  },
                  child: const Text('SAVE LOG', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
                ),
              ],
            );
          }
        );
      }
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Phone Call': return Icons.phone_in_talk;
      case 'Email': return Icons.email;
      case 'In-Person': return Icons.people;
      case 'WhatsApp': return Icons.chat;
      case 'Letter': return Icons.mark_email_read;
      default: return Icons.message;
    }
  }

  String _formatDate(DateTime d) {
    return '${d.day}/${d.month}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: const Text('Communication Log', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: AppTheme.accentColor)),
        iconTheme: const IconThemeData(color: AppTheme.accentColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_rounded, color: AppTheme.accentColor),
            onPressed: _showAddLogDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.accentColor))
          : _logs.isEmpty
              ? _buildEmptyState()
              : _buildLogsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.speaker_notes_off, size: 64, color: AppTheme.textSecondary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          const Text(
            'No Communication Logs',
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the + button to log a call, email, or meeting.',
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: AppTheme.textSecondary),
          ),
        ],
      ).animate().fadeIn().scale(),
    );
  }

  Widget _buildLogsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _logs.length,
      itemBuilder: (context, index) {
        final log = _logs[index];
        final isOutbound = log.direction == 'Outbound';
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (isOutbound ? AppTheme.accentColor : AppTheme.successGreen).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconForType(log.type),
                  color: isOutbound ? AppTheme.accentColor : AppTheme.successGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            log.contactName,
                            style: const TextStyle(fontFamily: 'Montserrat', fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          _formatDate(log.timestamp),
                          style: const TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(isOutbound ? Icons.call_made : Icons.call_received, size: 12, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${log.direction} ${log.type} • Logged by ${log.staffName}',
                          style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    if (log.summary.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.textSecondary.withValues(alpha: 0.1)),
                        ),
                        child: Text(
                          log.summary,
                          style: const TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: AppTheme.textPrimary, height: 1.4),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppTheme.textSecondary, size: 20),
                color: AppTheme.primaryColor,
                onSelected: (val) {
                  if (val == 'delete') {
                    CommunicationService.deleteLog(log.id).then((_) => _loadLogs());
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete Log', style: TextStyle(color: AppTheme.errorRed, fontFamily: 'Montserrat')),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 50 * index)).slideY(begin: 0.2);
      },
    );
  }
}
