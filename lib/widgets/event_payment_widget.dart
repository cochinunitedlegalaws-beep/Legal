import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/daily_case_payment.dart';
import '../services/daily_case_payment_service.dart';
import 'payment_update_dialog.dart';

class EventPaymentWidget extends StatefulWidget {
  final String eventId;
  final String caseId;
  final String? clientName;
  final String? caseType;
  final String? counsel;
  final VoidCallback? onPaymentUpdated;

  const EventPaymentWidget({
    super.key,
    required this.eventId,
    required this.caseId,
    this.clientName,
    this.caseType,
    this.counsel,
    this.onPaymentUpdated,
  });

  @override
  State<EventPaymentWidget> createState() => _EventPaymentWidgetState();
}

class _EventPaymentWidgetState extends State<EventPaymentWidget> {
  late Future<List<DailyCasePayment>> _paymentsFuture;

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  void _loadPayments() {
    _paymentsFuture = DailyCasePaymentService.getPaymentsByEventId(widget.eventId);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return AppTheme.successGreen;
      case 'Partial':
        return AppTheme.accentColor;
      case 'Pending':
        return AppTheme.accentColor;
      case 'Overdue':
        return AppTheme.errorRed;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Paid':
        return Icons.check_circle;
      case 'Partial':
        return Icons.radio_button_checked;
      case 'Pending':
        return Icons.schedule;
      case 'Overdue':
        return Icons.error_outline;
      default:
        return Icons.info_outline;
    }
  }

  void _openPaymentDialog(DailyCasePayment? payment) {
    showDialog(
      context: context,
      builder: (context) => PaymentUpdateDialog(
        eventId: widget.eventId,
        caseId: widget.caseId,
        existingPaymentId: payment?.id,
        clientName: widget.clientName,
        caseType: widget.caseType,
        counsel: widget.counsel,
        onPaymentUpdated: () {
          _loadPayments();
          widget.onPaymentUpdated?.call();
          setState(() {});
        },
      ),
    );
  }

  void _deletePayment(String paymentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Delete Payment', style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text('Are you sure you want to delete this payment record?', 
          style: TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: AppTheme.errorRed)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DailyCasePaymentService.deletePayment(paymentId);
      _loadPayments();
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment deleted'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DailyCasePayment>>(
      future: _paymentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              height: 40,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          );
        }

        final payments = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Payment List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payments for this Case',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _openPaymentDialog(null),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Payment', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Payment Records or Empty State
            if (payments.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.textSecondary.withValues(alpha: 0.12)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.payment, color: AppTheme.textSecondary.withValues(alpha: 0.5), size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'No payments recorded',
                      style: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.7), fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => _openPaymentDialog(null),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add First Payment'),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor,
                      border: Border.all(color: _getStatusColor(payment.status).withValues(alpha: 0.3)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Amount and Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  payment.amount,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  payment.caseType,
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getStatusColor(payment.status).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getStatusIcon(payment.status),
                                    color: _getStatusColor(payment.status),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    payment.status,
                                    style: TextStyle(
                                      color: _getStatusColor(payment.status),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Payment Details
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Method: ${payment.paymentMethod}',
                                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                              ),
                            ),
                            Text(
                              'Recorded: ${payment.lastUpdated.day}/${payment.lastUpdated.month}/${payment.lastUpdated.year}',
                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                            ),
                          ],
                        ),

                        // Additional Details
                        if (payment.chequeNumber != null && payment.chequeNumber!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Cheque #: ${payment.chequeNumber}',
                              style: const TextStyle(color: AppTheme.accentColor, fontSize: 11),
                            ),
                          ),

                        if (payment.expectedPaymentDate != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Expected by: ${payment.expectedPaymentDate!.day}/${payment.expectedPaymentDate!.month}/${payment.expectedPaymentDate!.year}',
                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                            ),
                          ),

                        if (payment.advanceAmount.isNotEmpty || payment.balanceAmount.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Advance: ₹${double.parse(payment.advanceAmount.isEmpty ? '0' : payment.advanceAmount).toStringAsFixed(2) ?? '0'} | Balance: ₹${double.parse(payment.balanceAmount.isEmpty ? '0' : payment.balanceAmount).toStringAsFixed(2) ?? '0'}',
                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                            ),
                          ),

                        if (payment.notes.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Notes: ${payment.notes}',
                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                        const SizedBox(height: 8),

                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () => _openPaymentDialog(payment),
                              icon: const Icon(Icons.edit, size: 14),
                              label: const Text('Edit', style: TextStyle(fontSize: 11)),
                              style: TextButton.styleFrom(foregroundColor: AppTheme.accentColor),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: () => _deletePayment(payment.id),
                              icon: const Icon(Icons.delete, size: 14),
                              label: const Text('Delete', style: TextStyle(fontSize: 11)),
                              style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
