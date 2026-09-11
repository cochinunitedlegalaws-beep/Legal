import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive.dart';
import '../widgets/event_payment_widget.dart';
import 'case_management_screen.dart';
import 'client_folder_screen.dart';
import '../services/client_service.dart';

class EventDetailScreen extends StatefulWidget {
  final String title;
  final String type;
  final String time;
  final DateTime date;
  final String? location;
  final String? attendees;
  final String? eventId;
  final String? caseId;
  final String? clientName;
  final String? caseType;
  final String? counsel;

  const EventDetailScreen({
    super.key,
    required this.title,
    required this.type,
    required this.time,
    required this.date,
    this.location,
    this.attendees,
    this.eventId,
    this.caseId,
    this.clientName,
    this.caseType,
    this.counsel,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  String? _clientEmail;

  @override
  void initState() {
    super.initState();
    _fetchClientEmail();
  }

  Future<void> _fetchClientEmail() async {
    if (widget.clientName == null || widget.clientName!.isEmpty) return;
    try {
      final clients = await ClientService().searchClients(widget.clientName!);
      if (clients.isNotEmpty && mounted) {
        setState(() {
          _clientEmail = clients.first['email']?.toString();
        });
      }
    } catch (e) {
      // ignore
    }
  }

  Color _typeColor() {
    switch (widget.type) {
      case 'Hearing':
        return AppTheme.accentColor;
      case 'Deadline':
        return AppTheme.errorRed;
      default:
        return AppTheme.successGreen;
    }
  }

  IconData _typeIcon() {
    switch (widget.type) {
      case 'Hearing':
        return Icons.gavel_rounded;
      case 'Deadline':
        return Icons.alarm_rounded;
      default:
        return Icons.people_alt_rounded;
    }
  }

  String _monthName(int month) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final color = _typeColor();

    return ResponsiveScaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.accentColor),
        title: Row(
          children: [
            Image.asset('assets/logo.png', width: 28, height: 28),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Event Details',
                  style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                Text(
                  'Cochin United Legal LLP',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Event Details Card
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.16), width: 1),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(_typeIcon(), color: color, size: 22),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.type.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _detailPill('DATE', '${_monthName(widget.date.month)} ${widget.date.day}, ${widget.date.year}'),
                        _detailPill('TIME', widget.time),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (widget.location != null) ...[
                      const Text(
                        'Location / Venue',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.location!,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (widget.attendees != null) ...[
                      const Text(
                        'Advocate & Counsel Attendees',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.attendees!,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              _buildQuickActions(context),
              const SizedBox(height: 24),

              // Payment Section (if eventId and caseId are provided)
              if (widget.eventId != null && widget.caseId != null)
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.16), width: 1),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: EventPaymentWidget(
                    eventId: widget.eventId!,
                    caseId: widget.caseId!,
                    clientName: widget.clientName,
                    caseType: widget.caseType,
                    counsel: widget.counsel,
                    onPaymentUpdated: () {
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailPill(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.secondaryColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    if (widget.caseId == null && widget.clientName == null) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.16), width: 1),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Advocate Quick Actions',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.accentColor,
            ),
          ),
          const SizedBox(height: 16),
          if (widget.caseId != null)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CaseManagementScreen()),
                );
              },
              icon: const Icon(Icons.folder_shared_rounded, size: 18),
              label: const Text('Open Case Ledger'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
                foregroundColor: AppTheme.accentColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppTheme.accentColor.withValues(alpha: 0.2)),
                ),
              ),
            ),
          if (widget.clientName != null) ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ClientFolderScreen(
                      clientName: widget.clientName!,
                      clientEmail: _clientEmail ?? 'unknown@example.com', // Fetched from ClientService
                      folderName: 'Case Documents',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.folder_special_rounded, size: 18),
              label: const Text('Open Client Vault'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
                foregroundColor: AppTheme.accentColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppTheme.accentColor.withValues(alpha: 0.2)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

