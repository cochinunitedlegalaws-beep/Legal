import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive.dart';
import '../services/ecourts_service.dart';

class ECourtsDashboard extends StatefulWidget {
  const ECourtsDashboard({super.key});

  @override
  State<ECourtsDashboard> createState() => _ECourtsDashboardState();
}

class _ECourtsDashboardState extends State<ECourtsDashboard> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _caseData;
  String? _errorMessage;

  Future<void> _search() async {
    final cnr = _searchController.text.trim();
    if (cnr.isEmpty) {
      setState(() => _errorMessage = 'Please enter a valid CNR number.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _caseData = null;
    });

    try {
      final result = await ECourtsService.searchCaseByCNR(cnr);
      if (result['status'] == 'success' && result['data'] != null) {
        setState(() {
          _caseData = result['data'];
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Could not retrieve data for this CNR.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred while fetching case data.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildSearchBar(),
              const SizedBox(height: 32),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppTheme.accentColor))
                    : _errorMessage != null
                        ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent, fontSize: 16)))
                        : _caseData != null
                            ? _buildResults()
                            : const Center(
                                child: Text('Enter a 16-digit CNR Number to track case status.',
                                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'eCourts India Portal',
              style: TextStyle(fontFamily: 'Cinzel', fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            Text(
              'Live Case Tracking & Sync',
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppTheme.accentColor),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppTheme.textPrimary, fontFamily: 'Montserrat', fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'Enter 16-character CNR Number...',
                hintStyle: TextStyle(color: AppTheme.textSecondary),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            onPressed: _search,
            child: const Text('TRACK CASE', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final data = _caseData!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoCard('Case Type / No.', '${data['case_type'] ?? '-'} ${data['filing_number'] ?? '-'}', Icons.folder),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard('Status', data['case_status'] ?? '-', Icons.info_outline, isHighlight: true),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard('Next Hearing', data['next_hearing_date'] ?? '-', Icons.calendar_month, isHighlight: true),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Court', data['court_name'] ?? '-'),
                const Divider(color: AppTheme.secondaryColor, height: 24),
                _buildDetailRow('Judge', data['judge'] ?? '-'),
                const Divider(color: AppTheme.secondaryColor, height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Petitioner', style: TextStyle(color: AppTheme.accentColor, fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(data['petitioner'] ?? '-', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
                          Text('Adv: ${data['petitioner_advocate'] ?? '-'}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('VS', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Respondent', style: TextStyle(color: AppTheme.accentColor, fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(data['respondent'] ?? '-', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
                          Text('Adv: ${data['respondent_advocate'] ?? '-'}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Case History', style: TextStyle(fontFamily: 'Cinzel', fontSize: 18, color: AppTheme.accentColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...(data['history'] as List? ?? []).map((h) => _buildHistoryItem(h)).toList(),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlight ? AppTheme.accentColor.withOpacity(0.1) : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isHighlight ? AppTheme.accentColor : AppTheme.secondaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: isHighlight ? AppTheme.accentColor : AppTheme.textSecondary, size: 16),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: isHighlight ? AppTheme.accentColor : AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 100, child: Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
        Expanded(child: Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> history) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.textSecondary.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppTheme.secondaryColor, borderRadius: BorderRadius.circular(8)),
            child: Text(history['date'] ?? '-', style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(history['purpose'] ?? 'Hearing', style: const TextStyle(color: AppTheme.accentColor, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(history['order'] ?? '-', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
