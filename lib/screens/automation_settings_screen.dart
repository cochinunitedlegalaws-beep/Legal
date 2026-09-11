import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../services/automation_service.dart';
import '../widgets/responsive.dart';

class AutomationSettingsScreen extends StatefulWidget {
  const AutomationSettingsScreen({super.key});

  @override
  State<AutomationSettingsScreen> createState() => _AutomationSettingsScreenState();
}

class _AutomationSettingsScreenState extends State<AutomationSettingsScreen> {
  bool _waCourtDates = false;
  bool _waInvoices = false;
  bool _emailDigests = false;
  bool _isLoading = true;
  bool _isTesting = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _waCourtDates = prefs.getBool('auto_wa_court_dates') ?? false;
      _waInvoices = prefs.getBool('auto_wa_invoices') ?? false;
      _emailDigests = prefs.getBool('auto_email_digests') ?? false;
      _isLoading = false;
    });
  }

  Future<void> _savePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _testWhatsApp() async {
    setState(() => _isTesting = true);
    await AutomationService.sendWhatsAppMessage('+919876543210', 'Hello from Cochin United Legal! Your hearing date for Case XYZ is scheduled for tomorrow.');
    if (mounted) {
      setState(() => _isTesting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test WhatsApp message sent! Check console logs.'), backgroundColor: AppTheme.successGreen),
      );
    }
  }

  Future<void> _testEmail() async {
    setState(() => _isTesting = true);
    await AutomationService.sendEmailDigest('client@example.com', 'Weekly Case Digest', 'Here is your weekly summary of case activities...');
    if (mounted) {
      setState(() => _isTesting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test Email digest sent! Check console logs.'), backgroundColor: AppTheme.successGreen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const ResponsiveScaffold(backgroundColor: AppTheme.primaryColor, body: Center(child: CircularProgressIndicator(color: AppTheme.accentColor)));
    }

    return ResponsiveScaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: const Text('Automation Settings', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: AppTheme.accentColor)),
        iconTheme: const IconThemeData(color: AppTheme.accentColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('WhatsApp Notifications (Mock)', style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildToggleTile(
            title: 'Court Date Reminders',
            subtitle: 'Automatically message clients when a new court date is assigned.',
            value: _waCourtDates,
            onChanged: (val) {
              setState(() => _waCourtDates = val);
              _savePreference('auto_wa_court_dates', val);
            },
            icon: Icons.calendar_month,
          ),
          const SizedBox(height: 8),
          _buildToggleTile(
            title: 'Invoice Generation',
            subtitle: 'Automatically message clients when a new invoice is generated.',
            value: _waInvoices,
            onChanged: (val) {
              setState(() => _waInvoices = val);
              _savePreference('auto_wa_invoices', val);
            },
            icon: Icons.receipt_long,
          ),
          const SizedBox(height: 32),
          const Text('Email Automations (Mock)', style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildToggleTile(
            title: 'Weekly Client Digests',
            subtitle: 'Automatically send a weekly summary of case activities to the client.',
            value: _emailDigests,
            onChanged: (val) {
              setState(() => _emailDigests = val);
              _savePreference('auto_email_digests', val);
            },
            icon: Icons.email,
          ),
          const SizedBox(height: 48),
          const Text('Test Integrations', style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isTesting ? null : _testWhatsApp,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 16)),
                  icon: const Icon(Icons.message, color: Colors.white),
                  label: const Text('Test WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isTesting ? null : _testEmail,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(vertical: 16)),
                  icon: const Icon(Icons.email, color: Colors.white),
                  label: const Text('Test Email', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile({required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: SwitchListTile(
        activeColor: AppTheme.accentColor,
        inactiveTrackColor: AppTheme.surfaceColor,
        secondary: Icon(icon, color: AppTheme.accentColor),
        title: Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
