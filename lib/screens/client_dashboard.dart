import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../services/case_service.dart';
import '../services/vault_service.dart';
import '../services/client_service.dart';
import '../services/billing_service.dart';
import '../models/billing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_screen.dart';
import '../widgets/responsive.dart';

class ClientDashboardScreen extends StatefulWidget {
  final String clientEmail;
  const ClientDashboardScreen({super.key, required this.clientEmail});

  @override
  State<ClientDashboardScreen> createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen> {
  List<Map<String, dynamic>> _myCases = [];
  List<Map<String, dynamic>> _myVaultFiles = [];
  List<Billing> _myInvoices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClientData();
  }

  Future<void> _loadClientData() async {
    setState(() => _isLoading = true);
    final cases = await CaseService.getCasesByClient(widget.clientEmail);
    final files = await VaultService.getFiles(widget.clientEmail);
    
    final allClients = await ClientService().getAllClients();
    final clientData = allClients.firstWhere((c) => c['email'] == widget.clientEmail, orElse: () => {});
    List<Billing> ledger = [];
    if (clientData.isNotEmpty) {
      final String clientName = clientData['name'];
      ledger = await BillingService().getClientLedger(clientName);
    }
    
    if (mounted) {
      setState(() {
        _myCases = cases;
        _myVaultFiles = files;
        _myInvoices = ledger;
        _isLoading = false;
      });
    }
  }

  Future<void> _launchPayment(Billing b) async {
    final urlStr = 'https://rzp.io/i/cuc?invoice_id=${b.invoiceNo}&amount=${b.amount}';
    final url = Uri.parse(urlStr);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not launch payment link')));
      }
    }
  }

  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Row(
        children: [
          // Client Sidebar
          Container(
            width: 280,
            decoration: BoxDecoration(
              gradient: AppTheme.navyGradient,
              border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    children: [
                      const Icon(Icons.gavel, color: AppTheme.primaryColor, size: 32),
                      const SizedBox(width: 16),
                      Text('PORTAL', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2)),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12),
                _buildSidebarItem(Icons.dashboard, 'Dashboard', true),
                _buildSidebarItem(Icons.folder_shared, 'My Cases', false),
                _buildSidebarItem(Icons.cloud_done, 'My Vault', false),
                _buildSidebarItem(Icons.payment, 'Invoices', false),
                const Spacer(),
                const Divider(color: Colors.white12),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppTheme.errorRed),
                  title: const Text('Secure Logout', style: TextStyle(color: AppTheme.errorRed, fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
                  onTap: _logout,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          
          // Main Content Area
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primaryColor.withValues(alpha: 0.1), Colors.transparent],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome back,', style: TextStyle(color: AppTheme.textSecondary, fontSize: 18, fontFamily: 'Montserrat')),
                            const SizedBox(height: 8),
                            Text(widget.clientEmail, style: Theme.of(context).textTheme.displayMedium),
                            
                            const SizedBox(height: 48),
                            
                            // Stats Row
                            Builder(
                              builder: (context) {
                                int pendingInvoices = _myInvoices.where((b) {
                                  bool isPaid = b.status == 'Received' || (b.data?['payment_received'] == true);
                                  return !isPaid;
                                }).length;
                                return Row(
                                  children: [
                                    _buildStatCard('Active Cases', _myCases.length.toString(), Icons.folder_open),
                                    const SizedBox(width: 24),
                                    _buildStatCard('Secure Documents', _myVaultFiles.length.toString(), Icons.security),
                                    const SizedBox(width: 24),
                                    _buildStatCard('Pending Invoices', pendingInvoices.toString(), Icons.account_balance_wallet, color: AppTheme.errorRed),
                                  ],
                                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2);
                              }
                            ),

                            const SizedBox(height: 48),

                            // Recent Cases Section
                            Text('Recent Case Updates', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.textPrimary)),
                            const SizedBox(height: 24),
                            _myCases.isEmpty 
                              ? _buildEmptyState('No active cases found.')
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _myCases.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                                  itemBuilder: (context, index) {
                                    final c = _myCases[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.surfaceColor,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                                      ),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.all(24),
                                        leading: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                                          child: const Icon(Icons.gavel, color: AppTheme.primaryColor),
                                        ),
                                        title: Text(c['case_title'] ?? 'Unknown Case', style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text("Case No: ${c['case_id']} • Status: ${c['status']}", style: const TextStyle(color: AppTheme.textSecondary)),
                                        ),
                                        trailing: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1), foregroundColor: AppTheme.primaryColor, elevation: 0),
                                          child: const Text('View Details'),
                                        ),
                                      ),
                                    );
                                  },
                                ).animate().fadeIn(delay: 200.ms),
                                
                            const SizedBox(height: 48),

                            // Vault Section
                            Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
                              children: [
                                Text('Secure Vault', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.textPrimary)),
                                TextButton.icon(onPressed: () {}, icon: const Icon(Icons.upload_file), label: const Text('Upload Document'))
                              ],
                            ),
                            const SizedBox(height: 24),
                            _myVaultFiles.isEmpty
                              ? _buildEmptyState('Your vault is empty.')
                              : LayoutBuilder(
                                  builder: (context, constraints) {
                                    int crossAxisCount = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 600 ? 3 : 2);
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: 1.5,
                                      ),
                                  itemCount: _myVaultFiles.length,
                                  itemBuilder: (context, index) {
                                    final f = _myVaultFiles[index];
                                    return Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: AppTheme.surfaceColor,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.insert_drive_file, color: AppTheme.primaryColor, size: 40),
                                          const SizedBox(height: 16),
                                          Text(f['file_name'] ?? '', style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 4),
                                          Text(f['upload_date']?.substring(0, 10) ?? '', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                                        ],
                                      ),
                                    );
                                  },
                                ).animate().fadeIn(delay: 400.ms);
                              },
                            ),

                            const SizedBox(height: 48),

                            // Invoices Section
                            Text('Financials & Invoices', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.textPrimary)),
                            const SizedBox(height: 24),
                            _myInvoices.isEmpty 
                              ? _buildEmptyState('No invoices found.')
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _myInvoices.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                                  itemBuilder: (context, index) {
                                    final b = _myInvoices[index];
                                    final isPaid = b.status == 'Received' || (b.data?['payment_received'] == true);
                                    
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.surfaceColor,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                                      ),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.all(24),
                                        leading: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(color: (isPaid ? Colors.green : AppTheme.errorRed).withValues(alpha: 0.1), shape: BoxShape.circle),
                                          child: Icon(Icons.receipt_long, color: isPaid ? Colors.green : AppTheme.errorRed),
                                        ),
                                        title: Text('Invoice ${b.invoiceNo ?? '-'}', style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text("Date: ${b.date ?? '-'} • Amount: ₹${b.amount ?? '0'}", style: const TextStyle(color: AppTheme.textSecondary)),
                                        ),
                                        trailing: isPaid
                                          ? Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                                              child: const Text('PAID', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                            )
                                          : ElevatedButton.icon(
                                              onPressed: () => _launchPayment(b),
                                              icon: const Icon(Icons.payment, size: 18),
                                              label: const Text('Pay Now'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppTheme.primaryColor, 
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                              ),
                                            ),
                                      ),
                                    );
                                  },
                                ).animate().fadeIn(delay: 600.ms),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
          )
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary),
        title: Text(title, style: TextStyle(color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontFamily: 'Montserrat')),
        onTap: () {},
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, {Color color = AppTheme.primaryColor}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.05), blurRadius: 20, spreadRadius: 5)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, fontFamily: 'Montserrat')),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Cinzel')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(color: AppTheme.surfaceColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
      child: Center(
        child: Text(text, style: const TextStyle(color: AppTheme.textSecondary, fontStyle: FontStyle.italic)),
      ),
    );
  }
}
