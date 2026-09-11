import 'package:flutter/material.dart';
import '../models/daily_case_payment.dart';
import '../services/payment_reminder_service.dart';

class PaymentReminderWidget extends StatefulWidget {
  final String? caseId; // Optional: filter reminders by case

  const PaymentReminderWidget({
    Key? key,
    this.caseId,
  }) : super(key: key);

  @override
  State<PaymentReminderWidget> createState() => _PaymentReminderWidgetState();
}

class _PaymentReminderWidgetState extends State<PaymentReminderWidget> {
  late Future<List<DailyCasePayment>> remindersFuture;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  void _loadReminders() {
    if (widget.caseId != null) {
      remindersFuture = PaymentReminderService.getRemindersByCase(widget.caseId!);
    } else {
      remindersFuture = PaymentReminderService.getActiveReminders();
    }
  }

  Color _getPriorityColor(DailyCasePayment payment) {
    final status = payment.getReminderStatus();
    if (status == 'Paid') return Colors.green;
    if (status == 'Overdue') return Colors.red;
    if (status == 'Due Soon') return Colors.orange;
    return Colors.blue;
  }

  IconData _getPriorityIcon(DailyCasePayment payment) {
    final status = payment.getReminderStatus();
    if (status == 'Paid') return Icons.check_circle;
    if (status == 'Overdue') return Icons.error;
    if (status == 'Due Soon') return Icons.warning;
    return Icons.info;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DailyCasePayment>>(
      future: remindersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Error loading reminders: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final reminders = snapshot.data ?? [];

        if (reminders.isEmpty) {
          return Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline, size: 40, color: Colors.green),
                  SizedBox(height: 8),
                  Text(
                    'No Payment Reminders',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'All payments are on track!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border(
                    bottom: BorderSide(color: Colors.blue.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.notifications_active, color: Colors.blue),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Reminders',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            '${reminders.length} payment${reminders.length > 1 ? 's' : ''} requiring attention',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: reminders.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  final status = reminder.getReminderStatus();
                  final statusColor = _getPriorityColor(reminder);
                  final statusIcon = _getPriorityIcon(reminder);

                  return Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(statusIcon, color: statusColor, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reminder.clientName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Amount: ₹${reminder.amount}',
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 2),
                              Text(
                                reminder.getReminderText(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: statusColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 11,
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Compact version of the payment reminder widget for dashboard cards
class CompactPaymentReminderWidget extends StatefulWidget {
  final int maxReminders;

  const CompactPaymentReminderWidget({
    Key? key,
    this.maxReminders = 3,
  }) : super(key: key);

  @override
  State<CompactPaymentReminderWidget> createState() =>
      _CompactPaymentReminderWidgetState();
}

class _CompactPaymentReminderWidgetState
    extends State<CompactPaymentReminderWidget> {
  late Future<Map<String, int>> statsFuture;

  @override
  void initState() {
    super.initState();
    statsFuture = PaymentReminderService.getReminderStats();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: statsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              height: 30,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (snapshot.hasError) {
          return SizedBox.shrink();
        }

        final stats = snapshot.data ?? {};
        final overdueCount = stats['overdue'] ?? 0;
        final dueSoonCount = stats['dueSoon'] ?? 0;
        final total = stats['total'] ?? 0;

        if (total == 0) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              border: Border.all(color: Colors.green.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text(
                  'All payments on track',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: overdueCount > 0 ? Colors.red.shade50 : Colors.orange.shade50,
            border: Border.all(
              color: overdueCount > 0 ? Colors.red.shade300 : Colors.orange.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    overdueCount > 0 ? Icons.error : Icons.warning,
                    color: overdueCount > 0 ? Colors.red : Colors.orange,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$total Payment${total > 1 ? 's' : ''} Require Attention',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: overdueCount > 0 ? Colors.red : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              if (overdueCount > 0)
                Text(
                  '🔴 $overdueCount overdue',
                  style: TextStyle(color: Colors.red, fontSize: 11),
                ),
              if (dueSoonCount > 0)
                Text(
                  '🟠 $dueSoonCount due soon',
                  style: TextStyle(color: Colors.orange, fontSize: 11),
                ),
            ],
          ),
        );
      },
    );
  }
}
