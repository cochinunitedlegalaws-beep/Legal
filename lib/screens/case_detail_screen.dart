import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive.dart';
import '../services/vault_service.dart';
import '../services/case_service.dart';
import '../services/client_service.dart';
import '../widgets/case_stages_widget.dart';
import 'billing_screen.dart';

class CaseDetailScreen extends StatefulWidget {
  final Map<String, String> caseFile;

  const CaseDetailScreen({super.key, required this.caseFile});

  @override
  State<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, dynamic> _extendedData;
  late String _dbId;
  int _currentStage = 0;
  String? _clientEmail;
  bool _isUploading = false;
  Map<String, List<dynamic>> _vaultDestinations = {};
  Map<int, String> _stageRemarks = {};

  List<Map<String, String>> get _referenceCases => [
        {
          'caseId': 'CU-2025-089',
          'clientName': 'Ernakulam Harbour Authority',
          'caseType': 'Arbitration Dispute',
          'status': 'Judgement Pending',
          'summary': 'Shipping agreement arbitration for coastal facility lease disputes.',
        },
        {
          'caseId': 'CU-2025-142',
          'clientName': 'M.G. Port Services',
          'caseType': 'Arbitration Dispute',
          'status': 'Closed',
          'summary': 'Cargo liability arbitration with settlement terms on demurrage fees.',
        },
        {
          'caseId': 'CU-2024-207',
          'clientName': 'Kochi Logistics Pvt Ltd',
          'caseType': 'Land Appeals',
          'status': 'Appeal Filed',
          'summary': 'Land acquisition appeal involving rights of way near port expansion.',
        },
        {
          'caseId': 'CU-2023-118',
          'clientName': 'South India Cargo Lines',
          'caseType': 'Arbitration Dispute',
          'status': 'Closed',
          'summary': 'Contractual shipping arbitration about carriage obligations and payment clauses.',
        },
      ];

  List<Map<String, String>> get _matchingReferenceCases {
    final caseType = widget.caseFile['caseType'] ?? '';
    return _referenceCases.where((reference) => reference['caseType'] == caseType).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _dbId = widget.caseFile['db_id'] ?? '';
    _parseExtendedData();
    _fetchClientEmail();
  }

  void _parseExtendedData() {
    final notes = widget.caseFile['notes'];
    if (notes != null && notes.startsWith('{') && notes.endsWith('}')) {
      try {
        _extendedData = jsonDecode(notes) as Map<String, dynamic>;
      } catch (e) {
        _extendedData = {};
      }
    } else {
      _extendedData = {};
    }

    _currentStage = _extendedData['current_stage'] ?? 0;

    if (_extendedData.containsKey('stage_remarks')) {
      final remarksData = _extendedData['stage_remarks'] as Map<String, dynamic>;
      _stageRemarks = remarksData.map((k, v) => MapEntry(int.parse(k), v.toString()));
    } else {
      _stageRemarks = {};
    }

    if (_extendedData.containsKey('case_vault')) {
      final vaultData = _extendedData['case_vault'] as Map<String, dynamic>;
      _vaultDestinations = vaultData.map((k, v) => MapEntry(k, List<dynamic>.from(v)));
    } else {
      final oldDocs = _extendedData['uploaded_documents'] as List<dynamic>? ?? [];
      _vaultDestinations = {
        'General Documents': List<dynamic>.from(oldDocs)
      };
    }
  }

  Future<void> _fetchClientEmail() async {
    final clientName = widget.caseFile['clientName'] ?? '';
    if (clientName.isEmpty) return;

    try {
      final clients = await ClientService().searchClients(clientName);
      if (clients.isNotEmpty && mounted) {
        setState(() {
          _clientEmail = clients.first['email']?.toString();
        });
      }
    } catch (e) {
      // ignore
    }
  }

  Future<void> _saveVaultDestinations() async {
    _extendedData['case_vault'] = _vaultDestinations;
    final newNotes = jsonEncode(_extendedData);
    widget.caseFile['notes'] = newNotes;
    if (_dbId.isNotEmpty) {
      await CaseService.updateCase(_dbId, {'notes': newNotes});
    }
  }

  void _showStageDetailsDialog(int step) {
    final tc = TextEditingController(text: _stageRemarks[step] ?? '');
    final stageInfo = CaseStages.getStage(step);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(stageInfo.name, style: const TextStyle(color: AppTheme.textPrimary, fontFamily: 'Cinzel')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stageInfo.description, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            const SizedBox(height: 16),
            TextField(
              controller: tc,
              maxLines: 3,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Add remarks for this stage...',
                hintStyle: const TextStyle(color: AppTheme.textSecondary),
                filled: true,
                fillColor: AppTheme.backgroundColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: AppTheme.textSecondary))),
          if (_currentStage != step)
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _updateStageAndRemarks(step, tc.text.trim(), setAsCurrent: true);
              }, 
              child: const Text('SET AS CURRENT', style: TextStyle(color: AppTheme.accentColor))
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(context);
              await _updateStageAndRemarks(step, tc.text.trim(), setAsCurrent: false);
            },
            child: const Text('SAVE REMARKS'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateStageAndRemarks(int step, String remarks, {required bool setAsCurrent}) async {
    setState(() {
      if (setAsCurrent) _currentStage = step;
      _stageRemarks[step] = remarks;
    });
    
    if (setAsCurrent) _extendedData['current_stage'] = step;
    
    final stringKeyMap = _stageRemarks.map((k, v) => MapEntry(k.toString(), v));
    _extendedData['stage_remarks'] = stringKeyMap;
    
    final newNotes = jsonEncode(_extendedData);
    widget.caseFile['notes'] = newNotes;
    
    if (_dbId.isNotEmpty) {
      await CaseService.updateCase(_dbId, {'notes': newNotes});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(setAsCurrent ? 'Stage updated and remarks saved!' : 'Remarks saved successfully!', 
          style: const TextStyle(color: AppTheme.successGreen))
        ));
      }
    }
  }

  String _getNotes() {
    if (_extendedData.containsKey('base_notes')) {
      final base = _extendedData['base_notes'].toString();
      return base.isEmpty ? 'No summary available.' : base;
    }
    return widget.caseFile['notes'] ?? 'No summary available.';
  }

  List<Widget> _buildExtendedDetails() {
    final data = _extendedData;
    if (data.isEmpty) return [];

    final Map<String, String> labelMap = {
      'court_case_number': 'Court Case No.',
      'court_name': 'Court Name',
      'opposing_party': 'Opposing Party',
      'opposing_counsel': 'Opposing Counsel',
      'total_fees': 'Total Fees',
      'per_day_fees': 'Per Day Fees',
      'initial_facts': 'Initial Facts',
      'conflicts_checked': 'Conflicts Checked',
      'retainer_signed': 'Retainer Signed',
      'drafting_status': 'Drafting Status',
      'drafting_notes': 'Drafting Notes',
      'filing_date': 'Filing Date',
      'diary_number': 'Diary Number',
      'cnr_number': 'CNR Number',
      'registry_defects': 'Registry Defects',
      'judge_name': 'Judge / Bench',
      'admission_order_date': 'Admission Date',
      'written_statement_deadline': 'WS Deadline',
      'rejoinder_deadline': 'Rejoinder Deadline',
      'interim_petition_counter': 'Interim Petition Counter',
      'pleadings_notes': 'Pleadings Notes',
      'framed_issues': 'Framed Issues',
      'date_of_framing_issues': 'Date Framed',
      'witnesses': 'Witnesses',
      'cross_exam_schedule': 'Cross Exam Dates',
      'evidence': 'Exhibits',
      'citations': 'Citations Relied',
      'written_arguments_filed': 'Written Args Filed',
      'judgment_date': 'Judgment Date',
      'judgment_outcome': 'Outcome',
      'judgment': 'Judgment Text',
      'billing_paid': 'Amount Paid',
      'billing_notes': 'Billing Notes',
      'invoice_generated': 'Invoice Sent',
      'invoice_no': 'Invoice No.',
      'closure_reason': 'Closure Reason',
      'execution_petition_required': 'Execution Req.',
      'appeal_expected': 'Appeal Expected',
      'final_bill_settled': 'Final Bill Settled',
      'asked_documents': 'Asked Documents',
    };

    List<Widget> rows = [
      const SizedBox(height: 10),
      const Divider(color: AppTheme.secondaryColor),
      const SizedBox(height: 10),
    ];

    for (var entry in labelMap.entries) {
      final key = entry.key;
      final label = entry.value;
      final val = data[key];

      if (key == 'asked_documents') {
        final listVal = data['asked_documents_list'];
        if (listVal != null && listVal is List && listVal.isNotEmpty) {
          final docWidgets = listVal.map<Widget>((doc) {
            final isReceived = doc['received'] == true;
            return Row(
              children: [
                Icon(isReceived ? Icons.check_box : Icons.check_box_outline_blank, color: isReceived ? AppTheme.accentColor : AppTheme.textSecondary, size: 16),
                const SizedBox(width: 8),
                Text(doc['name'] ?? '', style: TextStyle(color: isReceived ? AppTheme.textSecondary : AppTheme.textPrimary, decoration: isReceived ? TextDecoration.lineThrough : null, fontSize: 14)),
                if (isReceived && doc['type'] != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
                    ),
                    child: Text(doc['type'], style: const TextStyle(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            );
          }).toList();
          
          rows.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              const SizedBox(height: 6),
              ...docWidgets.map((w) => Padding(padding: const EdgeInsets.only(bottom: 4), child: w)),
            ],
          ));
          rows.add(const SizedBox(height: 10));
          continue;
        }
      }

      if (val != null) {
        String displayVal = val.toString();
        if (displayVal.isNotEmpty && displayVal != 'false') {
          if (val is bool) {
            displayVal = val ? 'Yes' : 'No';
          } else if (key.contains('date') || key.contains('deadline')) {
            if (displayVal.length > 10) displayVal = displayVal.substring(0, 10);
          } else if (key == 'total_fees' || key == 'per_day_fees' || key == 'billing_total' || key == 'billing_paid') {
            displayVal = '₹$displayVal';
          }
          
          rows.add(_buildDetailRow(label, displayVal));
          rows.add(const SizedBox(height: 10));
        }
      }
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ResponsiveScaffold(
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
                children: const [
                  Text(
                    'Case Details',
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
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppTheme.accentColor,
            labelColor: AppTheme.accentColor,
            unselectedLabelColor: AppTheme.textSecondary,
            labelStyle: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'OVERVIEW'),
              Tab(text: 'CASE VAULT'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(),
              _buildVaultTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.14), width: 1),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (widget.caseFile['caseId'] ?? 'Unknown ID').split(',').map((id) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            id.trim(),
                            style: const TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.accentColor),
                          ),
                        )).toList(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.caseFile['clientName'] ?? 'Unknown client',
                        style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.caseFile['caseTitle'] ?? 'Untitled Case',
                  style: const TextStyle(fontFamily: 'Montserrat', fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.caseFile['caseType'] ?? 'Case type unavailable',
                  style: const TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (widget.caseFile['status'] != null)
                      _buildStatusChip('Status', widget.caseFile['status']!),
                    if (widget.caseFile['hearingDate'] != null)
                      _buildStatusChip('Hearing', widget.caseFile['hearingDate']!),
                    if (widget.caseFile['assignedTo'] != null)
                      _buildStatusChip('Assigned', widget.caseFile['assignedTo']!),
                    if (widget.caseFile['advocates'] != null)
                      _buildStatusChip('Advocates', widget.caseFile['advocates']!),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: 'Case Timeline',
            child: CaseStagesWidget(
              currentStep: _currentStage,
              isEditable: true,
              stageRemarks: _stageRemarks,
              onStepTapped: (step) {
                _showStageDetailsDialog(step);
              },
            ),
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: 'Case Details',
            trailing: IconButton(
              icon: const Icon(Icons.edit, size: 16, color: AppTheme.accentColor),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => _showEditDetailsDialog(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDetailRow('Case ID', widget.caseFile['caseId'] ?? '-'),
                const SizedBox(height: 10),
                _buildDetailRow('Client Name', widget.caseFile['clientName'] ?? '-'),
                const SizedBox(height: 10),
                _buildDetailRow('Case Type', widget.caseFile['caseType'] ?? '-'),
                const SizedBox(height: 10),
                _buildDetailRow('Assigned To', widget.caseFile['assignedTo'] ?? '-'),
                const SizedBox(height: 10),
                _buildDetailRow('Hearing Date', widget.caseFile['hearingDate'] ?? '-'),
                const SizedBox(height: 10),
                _buildDetailRow('Status', widget.caseFile['status'] ?? '-'),
                const SizedBox(height: 10),
                _buildDetailRow('Advocates', widget.caseFile['advocates'] ?? '-'),
                ..._buildExtendedDetails(),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _buildSection(
            title: 'Case Summary & Instructions',
            child: Text(
              _getNotes(),
              style: const TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: AppTheme.textSecondary, height: 1.6),
            ),
          ),
          const SizedBox(height: 18),
          _buildSection(
            title: 'Reference Cases',
            child: _matchingReferenceCases.isEmpty
                ? const Text(
                    'No previous case references match this pattern yet.',
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: AppTheme.textSecondary, height: 1.6),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ..._matchingReferenceCases.map((reference) => _buildReferenceTile(reference)),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor,
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          _showReferenceDialog(context, _matchingReferenceCases);
                        },
                        icon: const Icon(Icons.history_edu_outlined, size: 18),
                        label: const Text('View all similar case references', style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 18),
          _buildSection(
            title: 'Billing Integration',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Create an invoice directly linked to this legal case. The invoice will track balances and payments associated with this specific case.',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: AppTheme.textSecondary, height: 1.6),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BillingScreen(
                          initialClientName: widget.caseFile['clientName'],
                          linkedCaseId: _dbId.isNotEmpty ? _dbId : widget.caseFile['caseId'],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.receipt_long_rounded, size: 18),
                  label: const Text('Create New Invoice', style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Case Destinations',
                style: TextStyle(fontFamily: 'Cinzel', fontSize: 18, color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _createNewDestination,
                icon: const Icon(Icons.create_new_folder, size: 18),
                label: const Text('New Folder', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_isUploading) ...[
            const LinearProgressIndicator(color: AppTheme.accentColor, backgroundColor: AppTheme.primaryColor),
            const SizedBox(height: 10),
            const Text('Uploading document...', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.accentColor, fontSize: 12)),
            const SizedBox(height: 20),
          ],
          if (_vaultDestinations.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.textSecondary.withOpacity(0.2)),
              ),
              child: const Center(
                child: Text('No destinations found. Create a new folder to start organizing case files.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, height: 1.5)),
              ),
            )
          else
            ..._vaultDestinations.entries.map((e) => _buildDestinationCard(e.key, e.value)).toList(),
        ],
      ),
    );
  }

  void _createNewDestination() {
    final tc = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('New Destination', style: TextStyle(color: AppTheme.textPrimary, fontFamily: 'Cinzel')),
        content: TextField(
          controller: tc,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'e.g. Evidence, Drafts, Court Orders',
            hintStyle: const TextStyle(color: AppTheme.textSecondary),
            filled: true,
            fillColor: AppTheme.backgroundColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: AppTheme.textSecondary))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor, foregroundColor: Colors.white),
            onPressed: () {
              final folderName = tc.text.trim();
              if (folderName.isNotEmpty) {
                setState(() {
                  _vaultDestinations[folderName] = [];
                });
                _saveVaultDestinations();
              }
              Navigator.pop(context);
            },
            child: const Text('CREATE'),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadFileToDestination(String destination) async {
    if (_clientEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Client email not found. Make sure client exists in the system.')));
      return;
    }

    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'doc', 'jpg', 'png', 'zip'],
      withData: true,
    );

    if (result != null) {
      setState(() => _isUploading = true);
      try {
        final pickedFile = result.files.first;
        final fileBytes = pickedFile.bytes;
        
        if (fileBytes == null) throw Exception("Failed to read file data");

        final now = DateTime.now();
        final dateStr = '${now.day}/${now.month}/${now.year}';
        final sizeStr = '${(pickedFile.size / (1024 * 1024)).toStringAsFixed(1)} MB';

        final caseTitle = widget.caseFile['caseTitle'] ?? 'Untitled';
        // Prefix folder to perfectly group in client vault
        final vaultFolderName = 'Case: $caseTitle - $destination';

        await VaultService.addFile(
          fileName: pickedFile.name,
          uploadDate: dateStr,
          fileSize: sizeStr,
          ownerEmail: _clientEmail!,
          folderName: vaultFolderName,
          fileBytes: fileBytes,
        );

        setState(() {
          _vaultDestinations[destination]!.add({
            'fileName': pickedFile.name,
            'uploadDate': dateStr,
            'fileSize': sizeStr,
            'ownerEmail': _clientEmail!,
          });
        });
        await _saveVaultDestinations();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File uploaded and synced to Client Vault!', style: TextStyle(color: AppTheme.successGreen))));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
        }
      } finally {
        if (mounted) {
          setState(() => _isUploading = false);
        }
      }
    }
  }

  Widget _buildDestinationCard(String destination, List<dynamic> files) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor.withOpacity(0.2)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedIconColor: AppTheme.accentColor,
          iconColor: AppTheme.accentColor,
          initiallyExpanded: true,
          leading: const Icon(Icons.folder_special, color: AppTheme.accentColor),
          title: Text(destination, style: const TextStyle(color: AppTheme.textPrimary, fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
          subtitle: Text('${files.length} files', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          children: [
            if (files.isEmpty)
              const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('No files yet.', style: TextStyle(color: AppTheme.textSecondary))),
            ...files.map((f) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.textSecondary.withOpacity(0.1)),
                ),
                child: ListTile(
                  leading: const Icon(Icons.description, color: AppTheme.textSecondary),
                  title: Text(f['fileName'] ?? '', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13)),
                  subtitle: Text('${f['uploadDate']} • ${f['fileSize']}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                ),
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.accentColor,
                    side: BorderSide(color: AppTheme.accentColor.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  onPressed: () => _uploadFileToDestination(destination),
                  icon: const Icon(Icons.upload_file, size: 16),
                  label: const Text('Upload File', style: TextStyle(fontFamily: 'Montserrat', fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child, Widget? trailing}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.accentColor),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.accentColor),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: AppTheme.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferenceTile(Map<String, String> reference) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            reference['caseId'] ?? 'Unknown',
            style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            reference['clientName'] ?? '-',
            style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            reference['summary'] ?? '-',
            style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: AppTheme.textPrimary, height: 1.4),
          ),
        ],
      ),
    );
  }

  void _showReferenceDialog(BuildContext context, List<Map<String, String>> references) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          title: const Text('Similar Case References', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: references.length,
              separatorBuilder: (context, index) => const Divider(color: AppTheme.secondaryColor),
              itemBuilder: (context, index) {
                final reference = references[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(reference['caseId'] ?? '-', style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                  subtitle: Text(reference['summary'] ?? '-', style: const TextStyle(fontFamily: 'Montserrat', color: AppTheme.textSecondary, height: 1.4)),
                  trailing: Text(reference['status'] ?? '-', style: const TextStyle(fontFamily: 'Montserrat', color: AppTheme.accentColor)),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(fontFamily: 'Montserrat', color: AppTheme.accentColor)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: AppTheme.textPrimary),
          ),
        ),
      ],
    );
  }

  void _showEditDetailsDialog() {
    final courtCaseNoCtrl = TextEditingController(text: _extendedData['court_case_number']?.toString() ?? '');
    final courtNameCtrl = TextEditingController(text: _extendedData['court_name']?.toString() ?? '');
    final oppPartyCtrl = TextEditingController(text: _extendedData['opposing_party']?.toString() ?? '');
    final oppCounselCtrl = TextEditingController(text: _extendedData['opposing_counsel']?.toString() ?? '');
    final feesCtrl = TextEditingController(text: _extendedData['total_fees']?.toString() ?? '');
    final perDayFeesCtrl = TextEditingController(text: _extendedData['per_day_fees']?.toString() ?? '');
    final evidenceCtrl = TextEditingController(text: _extendedData['evidence']?.toString() ?? '');
    final judgmentCtrl = TextEditingController(text: _extendedData['judgment']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          title: const Text('Edit Case Details', style: TextStyle(color: AppTheme.textPrimary, fontFamily: 'Montserrat')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: courtCaseNoCtrl, style: const TextStyle(color: AppTheme.textPrimary), decoration: const InputDecoration(labelText: 'Court Case No', labelStyle: TextStyle(color: AppTheme.textSecondary))),
                TextField(controller: courtNameCtrl, style: const TextStyle(color: AppTheme.textPrimary), decoration: const InputDecoration(labelText: 'Court Name', labelStyle: TextStyle(color: AppTheme.textSecondary))),
                TextField(controller: oppPartyCtrl, style: const TextStyle(color: AppTheme.textPrimary), decoration: const InputDecoration(labelText: 'Opposing Party', labelStyle: TextStyle(color: AppTheme.textSecondary))),
                TextField(controller: oppCounselCtrl, style: const TextStyle(color: AppTheme.textPrimary), decoration: const InputDecoration(labelText: 'Opposing Counsel', labelStyle: TextStyle(color: AppTheme.textSecondary))),
                TextField(controller: feesCtrl, style: const TextStyle(color: AppTheme.textPrimary), decoration: const InputDecoration(labelText: 'Total Fees', labelStyle: TextStyle(color: AppTheme.textSecondary))),
                TextField(controller: perDayFeesCtrl, style: const TextStyle(color: AppTheme.textPrimary), decoration: const InputDecoration(labelText: 'Per Day Fees', labelStyle: TextStyle(color: AppTheme.textSecondary))),
                TextField(controller: evidenceCtrl, style: const TextStyle(color: AppTheme.textPrimary), decoration: const InputDecoration(labelText: 'Evidence & Witnesses', labelStyle: TextStyle(color: AppTheme.textSecondary)), maxLines: 2),
                TextField(controller: judgmentCtrl, style: const TextStyle(color: AppTheme.textPrimary), decoration: const InputDecoration(labelText: 'Judgment', labelStyle: TextStyle(color: AppTheme.textSecondary)), maxLines: 2),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: AppTheme.textSecondary))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor, foregroundColor: Colors.white),
              onPressed: () async {
                setState(() {
                  _extendedData['court_case_number'] = courtCaseNoCtrl.text;
                  _extendedData['court_name'] = courtNameCtrl.text;
                  _extendedData['opposing_party'] = oppPartyCtrl.text;
                  _extendedData['opposing_counsel'] = oppCounselCtrl.text;
                  _extendedData['total_fees'] = feesCtrl.text;
                  _extendedData['per_day_fees'] = perDayFeesCtrl.text;
                  _extendedData['evidence'] = evidenceCtrl.text;
                  _extendedData['judgment'] = judgmentCtrl.text;
                });
                final newNotes = jsonEncode(_extendedData);
                widget.caseFile['notes'] = newNotes;
                if (_dbId.isNotEmpty) {
                  await CaseService.updateCase(_dbId, {'notes': newNotes});
                }
                if (mounted) Navigator.pop(context);
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }
}
