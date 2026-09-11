import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../screens/billing_screen.dart';
import '../services/billing_service.dart';

class PromisedPaymentReminderWidget extends StatefulWidget {
  final String? staffName; 

  const PromisedPaymentReminderWidget({super.key, this.staffName});

  @override
  State<PromisedPaymentReminderWidget> createState() => _PromisedPaymentReminderWidgetState();
}

class _PromisedPaymentReminderWidgetState extends State<PromisedPaymentReminderWidget> {
  List<Map<String, dynamic>> _promisedBills = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPromisedBills();
  }

  Future<void> _fetchPromisedBills() async {
    try {
      final allBillings = await BillingService.getBillings();
      
      final now = DateTime.now();
      final DateFormat format = DateFormat('dd/MM/yyyy');
      
      List<Map<String, dynamic>> filtered = [];
      for (var row in allBillings) {
        if (row['status'] != 'Pending' && row['status'] != null) continue;

        if (widget.staffName != null && widget.staffName!.isNotEmpty) {
          final authorities = row['authorities']?.toString().toLowerCase() ?? '';
          if (!authorities.contains(widget.staffName!.toLowerCase())) {
            continue;
          }
        }

        final data = row['data'] as Map<String, dynamic>?;
        if (data == null) continue;
        
        final isPaid = data['payment_received'] == true;
        if (isPaid) continue;

        final promisedDateStr = data['promised_payment_date']?.toString().trim();
        if (promisedDateStr == null || promisedDateStr.isEmpty) continue;
        
        try {
          final promisedDate = format.parse(promisedDateStr);
          final diff = promisedDate.difference(now).inDays;
          
          if (diff <= 7) {
            filtered.add({
              'id': row['id'],
              'invoice_no': row['invoice_no'],
              'client_name': row['client_name'],
              'amount': data['balance_due'] ?? row['amount'],
              'promised_date': promisedDateStr,
              'date_obj': promisedDate,
              'is_overdue': promisedDate.isBefore(DateTime(now.year, now.month, now.day)),
            });
          }
        } catch (_) {}
      }
      
      filtered.sort((a, b) => (a['date_obj'] as DateTime).compareTo(b['date_obj'] as DateTime));
      
      if (mounted) {
        setState(() {
          _promisedBills = filtered.take(100).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching promised bills: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.accentColor));
    }
    
    if (_promisedBills.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.secondaryColor),
        ),
        child: const Column(
          children: [
            Icon(Icons.event_available_rounded, size: 48, color: AppTheme.textSecondary),
            SizedBox(height: 16),
            Text('No Upcoming Promises', style: TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            Text('All promised payments are settled', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          ],
        ),
      );
    }
    
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              border: const Border(bottom: BorderSide(color: AppTheme.secondaryColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.calendar_month_rounded, color: AppTheme.accentColor, size: 20),
                    SizedBox(width: 8),
                    Text('Promised Payments', style: TextStyle(fontFamily: 'Cinzel', fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.accentColor)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: Text('${_promisedBills.where((b) => b['is_overdue']).length} Overdue', style: const TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: _promisedBills.length,
            separatorBuilder: (_, __) => const Divider(color: AppTheme.secondaryColor, height: 24),
            itemBuilder: (context, i) {
              final bill = _promisedBills[i];
              final bool isOverdue = bill['is_overdue'];
              
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BillingScreen()));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isOverdue ? Colors.redAccent.withOpacity(0.1) : AppTheme.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(isOverdue ? Icons.warning_rounded : Icons.schedule_rounded, 
                        color: isOverdue ? Colors.redAccent : AppTheme.accentColor, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(bill['client_name'] ?? 'Unknown', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
                              Text(bill['amount']?.toString() ?? '0/-', style: TextStyle(color: isOverdue ? Colors.redAccent : AppTheme.accentColor, fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(bill['invoice_no'] ?? '-', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                              Row(
                                children: [
                                  Icon(Icons.date_range, size: 12, color: isOverdue ? Colors.redAccent : AppTheme.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(bill['promised_date'], style: TextStyle(color: isOverdue ? Colors.redAccent : AppTheme.textSecondary, fontSize: 12, fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal)),
                                ],
                              ),
                            ],
                          ),
                        ],
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
  }
}
