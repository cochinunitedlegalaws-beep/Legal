import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/lead_model.dart';
import '../services/lead_service.dart';
import '../widgets/responsive.dart';

class LeadManagementScreen extends StatefulWidget {
  const LeadManagementScreen({super.key});

  @override
  State<LeadManagementScreen> createState() => _LeadManagementScreenState();
}

class _LeadManagementScreenState extends State<LeadManagementScreen> {
  List<Lead> _leads = [];
  bool _isLoading = true;

  final List<String> _stages = ['New', 'Contacted', 'Consultation', 'Hired', 'Lost'];

  @override
  void initState() {
    super.initState();
    _loadLeads();
  }

  Future<void> _loadLeads() async {
    setState(() => _isLoading = true);
    final leads = await LeadService.getLeads();
    if (mounted) {
      setState(() {
        _leads = leads;
        _isLoading = false;
      });
    }
  }

  void _showAddLeadDialog([Lead? existingLead]) {
    final nameController = TextEditingController(text: existingLead?.name ?? '');
    final phoneController = TextEditingController(text: existingLead?.phone ?? '');
    final emailController = TextEditingController(text: existingLead?.email ?? '');
    final notesController = TextEditingController(text: existingLead?.notes ?? '');
    String selectedSource = existingLead?.source ?? 'Website';
    String selectedType = existingLead?.inquiryType ?? 'General Inquiry';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: AppTheme.surfaceColor,
              title: Text(
                existingLead == null ? 'Add New Lead' : 'Edit Lead',
                style: const TextStyle(color: AppTheme.accentColor, fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(nameController, 'Lead Name'),
                    const SizedBox(height: 12),
                    _buildTextField(phoneController, 'Phone Number'),
                    const SizedBox(height: 12),
                    _buildTextField(emailController, 'Email Address'),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedSource,
                      dropdownColor: AppTheme.primaryColor,
                      style: const TextStyle(color: AppTheme.textPrimary, fontFamily: 'Montserrat'),
                      decoration: InputDecoration(
                        labelText: 'Source',
                        labelStyle: const TextStyle(color: AppTheme.textSecondary),
                        filled: true,
                        fillColor: AppTheme.secondaryColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      items: ['Website', 'Referral', 'Walk-in', 'Direct', 'Social Media']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setStateDialog(() => selectedSource = val!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      dropdownColor: AppTheme.primaryColor,
                      style: const TextStyle(color: AppTheme.textPrimary, fontFamily: 'Montserrat'),
                      decoration: InputDecoration(
                        labelText: 'Inquiry Type',
                        labelStyle: const TextStyle(color: AppTheme.textSecondary),
                        filled: true,
                        fillColor: AppTheme.secondaryColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      items: ['General Inquiry', 'Civil', 'Criminal', 'Corporate', 'Family']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setStateDialog(() => selectedType = val!),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(notesController, 'Notes', maxLines: 3),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL', style: TextStyle(color: AppTheme.textSecondary, fontFamily: 'Montserrat')),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty) return;
                    
                    if (existingLead == null) {
                      final newLead = Lead(
                        id: Lead.generateId(),
                        name: nameController.text.trim(),
                        phone: phoneController.text.trim(),
                        email: emailController.text.trim(),
                        source: selectedSource,
                        inquiryType: selectedType,
                        notes: notesController.text.trim(),
                        status: 'New',
                        createdAt: DateTime.now(),
                        lastModifiedAt: DateTime.now(),
                      );
                      await LeadService.addLead(newLead);
                    } else {
                      existingLead.lastModifiedAt = DateTime.now();
                      final updatedLead = Lead(
                        id: existingLead.id,
                        name: nameController.text.trim(),
                        phone: phoneController.text.trim(),
                        email: emailController.text.trim(),
                        source: selectedSource,
                        inquiryType: selectedType,
                        notes: notesController.text.trim(),
                        status: existingLead.status,
                        createdAt: existingLead.createdAt,
                        lastModifiedAt: DateTime.now(),
                      );
                      await LeadService.updateLead(updatedLead);
                    }
                    Navigator.pop(context);
                    _loadLeads();
                  },
                  child: Text(existingLead == null ? 'SAVE' : 'UPDATE', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
                ),
              ],
            );
          }
        );
      }
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: AppTheme.textPrimary, fontFamily: 'Montserrat'),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.textSecondary),
        filled: true,
        fillColor: AppTheme.secondaryColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  void _changeLeadStatus(Lead lead, String newStatus) async {
    lead.status = newStatus;
    lead.lastModifiedAt = DateTime.now();
    setState(() {}); // Optimistic UI update
    await LeadService.updateLead(lead);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: const Text(
          'Lead Management (CRM)',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: AppTheme.accentColor),
        ),
        iconTheme: const IconThemeData(color: AppTheme.accentColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppTheme.accentColor),
            tooltip: 'Add New Lead',
            onPressed: () => _showAddLeadDialog(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.accentColor))
          : _buildKanbanBoard(),
    );
  }

  Widget _buildKanbanBoard() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _stages.map((stage) {
          final stageLeads = _leads.where((l) => l.status == stage).toList();
          return Container(
            width: 320,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stage.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${stageLeads.length}',
                          style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: stageLeads.length,
                    itemBuilder: (context, index) {
                      final lead = stageLeads[index];
                      return _buildLeadCard(lead).animate().fadeIn(delay: Duration(milliseconds: 50 * index)).slideX();
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLeadCard(Lead lead) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.textSecondary.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showAddLeadDialog(lead),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        lead.name,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppTheme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz, color: AppTheme.textSecondary, size: 20),
                      color: AppTheme.surfaceColor,
                      onSelected: (newStatus) {
                        if (newStatus == 'Delete') {
                          LeadService.deleteLead(lead.id).then((_) => _loadLeads());
                        } else {
                          _changeLeadStatus(lead, newStatus);
                        }
                      },
                      itemBuilder: (context) {
                        final items = _stages.where((s) => s != lead.status).map((s) => PopupMenuItem(
                          value: s,
                          child: Text('Move to $s', style: const TextStyle(color: AppTheme.textPrimary)),
                        )).toList();
                        items.add(const PopupMenuItem(
                          value: 'Delete',
                          child: Text('Delete Lead', style: TextStyle(color: AppTheme.errorRed)),
                        ));
                        return items;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      lead.phone.isNotEmpty ? lead.phone : 'No Phone',
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.category, size: 14, color: AppTheme.accentColor),
                    const SizedBox(width: 4),
                    Text(
                      lead.inquiryType,
                      style: const TextStyle(color: AppTheme.accentColor, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
