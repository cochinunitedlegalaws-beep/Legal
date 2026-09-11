import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/client_service.dart';
import '../services/case_service.dart';
import '../services/vault_service.dart';
import '../models/deal.dart';
import '../services/deal_service.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkfileWizardScreen extends StatefulWidget {
  const WorkfileWizardScreen({super.key});

  @override
  State<WorkfileWizardScreen> createState() => _WorkfileWizardScreenState();
}

class _WorkfileWizardScreenState extends State<WorkfileWizardScreen> {
  bool _isLoading = false;

  final _fileNoController = TextEditingController();
  final _caseNameController = TextEditingController();
  final _caseTypeController = TextEditingController(text: 'Civil');
  final _customCaseTypeController = TextEditingController();
  String _selectedCaseTypeDropdown = 'Civil';

  List<Map<String, dynamic>> _clients = [];
  Map<String, dynamic>? _selectedClient;
  bool _isLoadingClients = true;

  final List<PlatformFile> _newFilesToUpload = [];
  final List<Map<String, dynamic>> _existingVaultFiles = [];
  final List<Map<String, dynamic>> _selectedVaultFiles = [];
  bool _isLoadingVaultFiles = false;

  final List<String> _selectedStaffEmails = [];

  @override
  void initState() {
    super.initState();
    _loadClients();
    _loadStaff();
  }

  @override
  void dispose() {
    _fileNoController.dispose();
    _caseNameController.dispose();
    _caseTypeController.dispose();
    _customCaseTypeController.dispose();
    super.dispose();
  }

  String _loggedInStaffName = '';

  Future<void> _loadStaff() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email') ?? '';
      final name = prefs.getString('user_name') ?? '';
      if (mounted) {
        setState(() {
          _loggedInStaffName = name.isNotEmpty ? name : email;
          _selectedStaffEmails.clear();
          if (email.isNotEmpty) {
            _selectedStaffEmails.add(email);
          }
        });
      }
    } catch (e) {
      // Ignored
    }
  }

  Future<void> _loadClients() async {
    try {
      final clients = await ClientService().getAllClients();
      if (mounted) {
        setState(() {
          _clients = clients;
          _isLoadingClients = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingClients = false);
    }
  }

  Future<void> _loadClientVaultFiles() async {
    if (_selectedClient == null || _selectedClient!['email'] == null) return;
    setState(() => _isLoadingVaultFiles = true);
    try {
      final files = await VaultService.getFiles(_selectedClient!['email']);
      if (mounted) {
        setState(() {
          _existingVaultFiles.clear();
          _existingVaultFiles.addAll(files);
          _isLoadingVaultFiles = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingVaultFiles = false);
    }
  }

  Future<void> _pickNewFiles() async {
    try {
      final result = await FilePicker.pickFiles(allowMultiple: true);
      if (result != null && mounted) {
        setState(() {
          _newFilesToUpload.addAll(result.files);
        });
      }
    } catch (e) {
      _msg('Failed to pick files: $e', false);
    }
  }

  Future<void> _submitWorkfile() async {
    if (_fileNoController.text.trim().isEmpty || _caseNameController.text.trim().isEmpty || _selectedClient == null) {
      _msg('Please enter File No, Case Title, and select a Client.', false);
      return;
    }

    setState(() => _isLoading = true);

    try {
      List<Map<String, dynamic>> uploadedDocsData = [];
      final clientEmail = _selectedClient!['email'] ?? 'unknown@client.com';

      for (var file in _newFilesToUpload) {
        if (file.bytes != null) {
          final uploadDate = DateTime.now().toIso8601String();
          final sizeKb = (file.size / 1024).toStringAsFixed(2);
          await VaultService.addFile(
            fileName: file.name,
            uploadDate: uploadDate,
            fileSize: '$sizeKb KB',
            ownerEmail: clientEmail,
            folderName: 'Case Files',
            fileBytes: file.bytes,
          );
          uploadedDocsData.add({
            'file_name': file.name,
            'upload_date': uploadDate,
            'source': 'Vault (New)',
          });
        }
      }

      for (var f in _selectedVaultFiles) {
        uploadedDocsData.add({
          'file_name': f['file_name'] ?? 'Unknown File',
          'upload_date': f['upload_date'] ?? '',
          'source': 'Vault (Existing)',
        });
      }

      final caseIdStr = _fileNoController.text.trim();
      final creatorName = await AuthService().getUserName();
      final caseData = {
        'case_title': _caseNameController.text.trim(),
        'client_name': _selectedClient!['name'] ?? '',
        'case_type': _caseTypeController.text.trim().isEmpty ? 'General' : _caseTypeController.text.trim(),
        'case_status': 'Open',
        'court_case_number': caseIdStr,
        'responsible_staff': _selectedStaffEmails,
        'created_by': (creatorName != null && creatorName.isNotEmpty) ? creatorName : 'System',
        'case_description': jsonEncode({
          'client_email': clientEmail,
          'workfile_no': caseIdStr,
          'vault_documents': uploadedDocsData,
        }),
      };

      await CaseService.addCase(caseData);

      try {
        final deal = Deal(
          name: _caseNameController.text.trim(),
          clientId: _selectedClient!['id'],
          clientName: _selectedClient!['name'],
          stage: Deal.stages.first,
          pipeline: 'Case Management',
          description: 'Created from Workfile Manager',
        );
        await DealService().createDeal(deal);
      } catch (dealError) {
        debugPrint('Error creating deal for workfile: $dealError');
      }

      _msg('Workfile successfully created!', true);
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      _msg('Error creating workfile: $e', false);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _msg(String t, bool ok) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(t, style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
      backgroundColor: ok ? AppTheme.successGreen : AppTheme.errorRed,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.folder_special_rounded, color: Color(0xFFD4AF37), size: 18),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create New Workfile',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0F172A),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const Text(
                      'Enter case details, select client, and assign legal team',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8), size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Form Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SECTION 1: Case Details
                  const Text(
                    'CASE DETAILS',
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 0.6),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(_fileNoController, 'File / Case No. *', Icons.tag_rounded, hint: 'e.g. CU-WF-2026-001'),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        flex: 2,
                        child: _buildFormField(_caseNameController, 'Case Title *', Icons.title_rounded, hint: 'e.g. Property Registration & Deed'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Case Type Selection
                  _buildDropdownField<String>(
                    value: _selectedCaseTypeDropdown,
                    label: 'Case Type',
                    icon: Icons.category_rounded,
                    items: ['Civil', 'Criminal', 'Corporate', 'Family', 'Property', 'Tax', 'Agreement', 'General', 'Other']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedCaseTypeDropdown = val;
                          if (val == 'Other') {
                            _caseTypeController.text = _customCaseTypeController.text.trim().isEmpty ? 'Other' : _customCaseTypeController.text.trim();
                          } else {
                            _caseTypeController.text = val;
                          }
                        });
                      }
                    },
                  ),
                  if (_selectedCaseTypeDropdown == 'Other') ...[
                    const SizedBox(height: 12),
                    _buildFormField(
                      _customCaseTypeController,
                      'Specify Case Type',
                      Icons.edit_note_rounded,
                      onChanged: (val) => _caseTypeController.text = val.trim().isEmpty ? 'Other' : val.trim(),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // SECTION 2: Client Assignment
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'CLIENT ASSIGNMENT',
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 0.6),
                      ),
                      InkWell(
                        onTap: _showCreateClientDialog,
                        borderRadius: BorderRadius.circular(6),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          child: Row(
                            children: [
                              Icon(Icons.person_add_rounded, size: 14, color: Color(0xFF0F172A)),
                              SizedBox(width: 4),
                              Text(
                                '+ New Client',
                                style: TextStyle(fontFamily: 'Montserrat', fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  _isLoadingClients
                      ? const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0F172A))))
                      : DropdownButtonFormField<Map<String, dynamic>>(
                          value: _selectedClient,
                          dropdownColor: Colors.white,
                          style: const TextStyle(color: Color(0xFF0F172A), fontFamily: 'Montserrat', fontSize: 13.5),
                          decoration: InputDecoration(
                            labelText: 'Select Client *',
                            labelStyle: const TextStyle(color: Color(0xFF64748B), fontFamily: 'Montserrat', fontSize: 12.5),
                            prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF64748B), size: 18),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1.2)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          hint: const Text('Choose client from roster...', style: TextStyle(color: Color(0xFF94A3B8), fontFamily: 'Montserrat', fontSize: 13)),
                          items: _clients.map((c) {
                            return DropdownMenuItem(
                              value: c,
                              child: Text('${c['name'] ?? 'Unnamed Client'} (${c['email'] ?? 'No Email'})'),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedClient = val;
                            });
                            _loadClientVaultFiles();
                          },
                        ),
                  const SizedBox(height: 24),

                  // SECTION 3: Staff Assignment (Auto-assigned to logged-in user)
                  const Text(
                    'ASSIGNED LEGAL TEAM',
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 0.6),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person_rounded, size: 20, color: Color(0xFF0F172A)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _loggedInStaffName.isNotEmpty 
                                ? _loggedInStaffName 
                                : (_selectedStaffEmails.isNotEmpty ? _selectedStaffEmails.first : 'Logged-in Staff'),
                            style: const TextStyle(fontFamily: 'Montserrat', fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Logged In Staff',
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF047857)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // SECTION 4: Documents & Vault Files (Optional)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'DOCUMENTS & VAULT (OPTIONAL)',
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 0.6),
                      ),
                      OutlinedButton.icon(
                        onPressed: _pickNewFiles,
                        icon: const Icon(Icons.attach_file_rounded, size: 14, color: Color(0xFF0F172A)),
                        label: Text(
                          _newFilesToUpload.isEmpty ? '+ Upload Files' : '${_newFilesToUpload.length} Files Added',
                          style: const TextStyle(fontFamily: 'Montserrat', fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                        ),
                      ),
                    ],
                  ),
                  if (_newFilesToUpload.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: _newFilesToUpload.map((f) {
                        return Chip(
                          backgroundColor: const Color(0xFFF1F5F9),
                          side: BorderSide.none,
                          label: Text(f.name, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: Color(0xFF0F172A))),
                          deleteIcon: const Icon(Icons.close_rounded, size: 14, color: Color(0xFF64748B)),
                          onDeleted: () {
                            setState(() {
                              _newFilesToUpload.remove(f);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],

                  if (_isLoadingVaultFiles) ...[
                    const SizedBox(height: 10),
                    const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0F172A))),
                  ] else if (_existingVaultFiles.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text('Link Client Vault Files:', style: TextStyle(fontFamily: 'Montserrat', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
                    const SizedBox(height: 6),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 140),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _existingVaultFiles.length,
                        separatorBuilder: (_, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        itemBuilder: (ctx, idx) {
                          final f = _existingVaultFiles[idx];
                          final isSelected = _selectedVaultFiles.contains(f);
                          return CheckboxListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            title: Text(f['file_name'] ?? 'Unknown', style: TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF475569), fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
                            value: isSelected,
                            activeColor: const Color(0xFF0F172A),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _selectedVaultFiles.add(f);
                                } else {
                                  _selectedVaultFiles.remove(f);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel', style: TextStyle(fontFamily: 'Montserrat', color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 14),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitWorkfile,
                  icon: _isLoading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFD4AF37)))
                      : const Icon(Icons.check_rounded, size: 18, color: Color(0xFFD4AF37)),
                  label: Text(
                    _isLoading ? 'Creating Workfile...' : 'Create Workfile',
                    style: const TextStyle(fontFamily: 'Montserrat', color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(TextEditingController controller, String label, IconData icon, {String? hint, void Function(String)? onChanged}) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: Color(0xFF0F172A), fontFamily: 'Montserrat', fontSize: 13.5),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF64748B), fontFamily: 'Montserrat', fontSize: 12.5),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontFamily: 'Montserrat', fontSize: 12.5),
        prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 18),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1.2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _buildDropdownField<T>({required T? value, required String label, required IconData icon, required List<DropdownMenuItem<T>> items, required void Function(T?) onChanged}) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      dropdownColor: Colors.white,
      style: const TextStyle(color: Color(0xFF0F172A), fontFamily: 'Montserrat', fontSize: 13.5),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF64748B), fontFamily: 'Montserrat', fontSize: 12.5),
        prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 18),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1.2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  void _showCreateClientDialog() {
    final nameCtrl = TextEditingController();
    final careOfCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final clientTypeCtrl = TextEditingController(text: 'Individual');
    final workCtrl = TextEditingController(text: 'Civil');
    final caseNoCtrl = TextEditingController();
    final courtCtrl = TextEditingController();
    final statusCtrl = TextEditingController(text: 'Active');
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 540),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.person_add_rounded, color: Color(0xFFD4AF37), size: 18),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Add New Client',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8), size: 20),
                        onPressed: () => Navigator.pop(dialogCtx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(nameCtrl, 'Full Name *', Icons.person_rounded),
                  const SizedBox(height: 12),
                  _buildFormField(careOfCtrl, 'Care Of (C/O)', Icons.person_pin_rounded),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildFormField(emailCtrl, 'Email Address', Icons.email_rounded)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildFormField(phoneCtrl, 'Phone Number', Icons.phone_rounded)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField<String>(
                          value: clientTypeCtrl.text,
                          label: 'Client Type',
                          icon: Icons.business_rounded,
                          items: ['Individual', 'Company', 'Firm', 'Trust', 'Other']
                              .map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                          onChanged: (val) { if (val != null) clientTypeCtrl.text = val; },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownField<String>(
                          value: workCtrl.text,
                          label: 'Case Area',
                          icon: Icons.work_rounded,
                          items: ['Civil', 'Criminal', 'Corporate', 'Family', 'Property', 'Tax', 'Constitutional', 'Other']
                              .map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                          onChanged: (val) { if (val != null) workCtrl.text = val; },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogCtx),
                        child: const Text('Cancel', style: TextStyle(fontFamily: 'Montserrat', color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: isSaving
                            ? null
                            : () async {
                                final name = nameCtrl.text.trim();
                                if (name.isEmpty) {
                                  _msg('Client Full Name is required', false);
                                  return;
                                }
                                setDialogState(() => isSaving = true);
                                try {
                                  final clientData = {
                                    'name': name,
                                    'care_of': careOfCtrl.text.trim(),
                                    'email': emailCtrl.text.trim(),
                                    'phone': phoneCtrl.text.trim(),
                                    'client_type': clientTypeCtrl.text.trim().isEmpty ? 'Individual' : clientTypeCtrl.text.trim(),
                                    'type_of_work': workCtrl.text.trim().isEmpty ? 'Civil' : workCtrl.text.trim(),
                                    'case_number': caseNoCtrl.text.trim(),
                                    'court_name': courtCtrl.text.trim(),
                                    'case_status': statusCtrl.text.trim().isEmpty ? 'Active' : statusCtrl.text.trim(),
                                  };
                                  final newClient = await ClientService().addClientFull(clientData);
                                  if (dialogCtx.mounted) {
                                    Navigator.pop(dialogCtx);
                                  }
                                  if (newClient != null && mounted) {
                                    setState(() {
                                      _clients.insert(0, newClient);
                                      _selectedClient = newClient;
                                    });
                                    _msg('Client "$name" created and selected successfully!', true);
                                  }
                                } catch (e) {
                                  setDialogState(() => isSaving = false);
                                  _msg('Failed to create client: $e', false);
                                }
                              },
                        icon: isSaving
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFD4AF37)))
                            : const Icon(Icons.check_rounded, size: 16, color: Color(0xFFD4AF37)),
                        label: Text(
                          isSaving ? 'Saving...' : 'Save & Select Client',
                          style: const TextStyle(fontFamily: 'Montserrat', color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
