import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/daily_case_payment.dart';
import '../services/daily_case_payment_service.dart';

class PaymentUpdateDialog extends StatefulWidget {
  final String eventId;
  final String caseId;
  final String? existingPaymentId;
  final String? clientName;
  final String? caseType;
  final String? counsel;
  final VoidCallback onPaymentUpdated;

  const PaymentUpdateDialog({
    super.key,
    required this.eventId,
    required this.caseId,
    this.existingPaymentId,
    this.clientName,
    this.caseType,
    this.counsel,
    required this.onPaymentUpdated,
  });

  @override
  State<PaymentUpdateDialog> createState() => _PaymentUpdateDialogState();
}

class _PaymentUpdateDialogState extends State<PaymentUpdateDialog> {
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  late TextEditingController _chequeNumberController;
  late TextEditingController _advanceController;
  late TextEditingController _balanceController;
  
  String _selectedStatus = 'Pending';
  String _selectedPaymentMethod = 'Cheque';
  DateTime? _expectedPaymentDate;
  DailyCasePayment? _existingPayment;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _notesController = TextEditingController();
    _chequeNumberController = TextEditingController();
    _advanceController = TextEditingController();
    _balanceController = TextEditingController();
    _loadExistingPayment();
  }

  Future<void> _loadExistingPayment() async {
    if (widget.existingPaymentId != null) {
      final payment = await DailyCasePaymentService.getPaymentById(widget.existingPaymentId!);
      if (payment != null && mounted) {
        setState(() {
          _existingPayment = payment;
          _amountController.text = payment.amount;
          _selectedStatus = payment.status;
          _selectedPaymentMethod = payment.paymentMethod;
          _notesController.text = payment.notes;
          _chequeNumberController.text = payment.chequeNumber ?? '';
          _expectedPaymentDate = payment.expectedPaymentDate;
          _advanceController.text = payment.advanceAmount.toString();
          _balanceController.text = payment.balanceAmount.toString();
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _chequeNumberController.dispose();
    _advanceController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _savePayment() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter amount'), backgroundColor: AppTheme.errorRed),
      );
      return;
    }

    final payment = DailyCasePayment(
      id: _existingPayment?.id ?? DailyCasePayment.generateId(),
      eventId: widget.eventId,
      caseId: widget.caseId,
      clientName: widget.clientName ?? 'Unknown Client',
      caseType: widget.caseType ?? 'General',
      amount: _amountController.text,
      status: _selectedStatus,
      counsel: widget.counsel ?? 'Unassigned',
      dateRecorded: _existingPayment?.dateRecorded ?? DateTime.now(),
      lastUpdated: DateTime.now(),
      notes: _notesController.text,
      paymentMethod: _selectedPaymentMethod,
      chequeNumber: _chequeNumberController.text.isEmpty ? null : _chequeNumberController.text,
      expectedPaymentDate: _expectedPaymentDate,
      advanceAmount: _advanceController.text.isEmpty ? '0' : _advanceController.text,
      balanceAmount: _balanceController.text.isEmpty ? '0' : _balanceController.text,
    );

    if (_existingPayment == null) {
      await DailyCasePaymentService.addPayment(payment);
    } else {
      await DailyCasePaymentService.updatePayment(payment);
    }

    widget.onPaymentUpdated();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_existingPayment == null ? 'Payment added successfully' : 'Payment updated successfully'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        content: SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
      );
    }

    return AlertDialog(
      backgroundColor: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppTheme.accentColor.withValues(alpha: 0.12)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.accentColor.withValues(alpha: 0.18),
                    child: const Icon(Icons.payment, color: AppTheme.accentColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _existingPayment == null ? 'Add Payment' : 'Update Payment',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          widget.clientName ?? 'Daily Case',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Amount Field
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount (₹)',
                  hintText: 'Enter amount',
                  prefixIcon: const Icon(Icons.currency_rupee, color: AppTheme.accentColor),
                  filled: true,
                  fillColor: AppTheme.secondaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
                style: const TextStyle(color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 14),

              // Status Dropdown
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                items: ['Pending', 'Partial', 'Paid', 'Overdue']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedStatus = value);
                },
                decoration: InputDecoration(
                  labelText: 'Status',
                  filled: true,
                  fillColor: AppTheme.secondaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                style: const TextStyle(color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 14),

              // Payment Method Dropdown
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                items: ['Cheque', 'NEFT', 'Cash', 'Card', 'Others']
                    .map((method) => DropdownMenuItem(value: method, child: Text(method)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedPaymentMethod = value);
                },
                decoration: InputDecoration(
                  labelText: 'Payment Method',
                  filled: true,
                  fillColor: AppTheme.secondaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                style: const TextStyle(color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 14),

              // Cheque Number (visible only if Cheque is selected)
              if (_selectedPaymentMethod == 'Cheque') ...[
                TextField(
                  controller: _chequeNumberController,
                  decoration: InputDecoration(
                    labelText: 'Cheque Number',
                    hintText: 'Enter cheque number',
                    filled: true,
                    fillColor: AppTheme.secondaryColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                  style: const TextStyle(color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 14),
              ],

              // Expected Payment Date
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _expectedPaymentDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() => _expectedPaymentDate = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor,
                    border: Border.all(color: AppTheme.textSecondary.withValues(alpha: 0.12)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppTheme.textSecondary, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _expectedPaymentDate == null
                              ? 'Expected Payment Date'
                              : 'Expected: ${_expectedPaymentDate!.day}/${_expectedPaymentDate!.month}/${_expectedPaymentDate!.year}',
                          style: TextStyle(
                            color: _expectedPaymentDate == null
                                ? AppTheme.textSecondary
                                : AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Advance & Balance Row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _advanceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Advance (₹)',
                        hintText: '0',
                        filled: true,
                        fillColor: AppTheme.secondaryColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _balanceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Balance (₹)',
                        hintText: '0',
                        filled: true,
                        fillColor: AppTheme.secondaryColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Notes Field
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Add payment notes or remarks...',
                  filled: true,
                  fillColor: AppTheme.secondaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                style: const TextStyle(color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.textSecondary.withValues(alpha: 0.2)),
                        foregroundColor: AppTheme.textSecondary,
                      ),
                      child: const Text('CANCEL'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _savePayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('SAVE PAYMENT'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
