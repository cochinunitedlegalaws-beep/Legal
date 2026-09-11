import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/service_item.dart';
import '../models/ServiceItems.dart' as AmplifyModels;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../widgets/responsive.dart';
class ServiceManagementScreen extends StatefulWidget {
  const ServiceManagementScreen({super.key});

  @override
  State<ServiceManagementScreen> createState() => _ServiceManagementScreenState();
}

class _ServiceManagementScreenState extends State<ServiceManagementScreen> {
  List<ServiceItem> _services = [];
  bool _isLoading = true;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final request = ModelQueries.list(AmplifyModels.ServiceItems.classType);
      final response = await Amplify.API.query(request: request).response;
      final items = response.data?.items.whereType<AmplifyModels.ServiceItems>().toList() ?? [];

      final List<ServiceItem> parsed = [];
      for (final item in items) {
        try {
          Map<String, dynamic> dataMap = {};
          if (item.data != null) {
            try { dataMap = jsonDecode(item.data!); } catch (_) {}
          }
          parsed.add(ServiceItem(
            id: item.id,
            title: item.name ?? '',
            category: item.category ?? '',
            description: dataMap['description'] ?? '',
            details: dataMap['details'] ?? '',
          ));
        } catch (e) {
          debugPrint('ServiceMgmt: Failed to parse row: $e');
        }
      }
      
      parsed.sort((a, b) => a.title.compareTo(b.title));
      
      if (mounted) {
        setState(() {
          _services = parsed;
        });
      }
    } catch (e) {
      debugPrint('ServiceMgmt: Query failed: $e');
      _showError('Failed to fetch services: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showEditForm(ServiceItem service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditServiceForm(
        service: service,
        onSaved: () {
          if (mounted) Navigator.pop(context);
          _fetchServices();
          _showSuccess('Service updated successfully');
        },
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: AppTheme.primaryColor),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
          ),
        ),
      ],
    );
  }

  void _showAddForm() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('Create New Service', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildFormField('Service Title', titleController, Icons.add_business_rounded),
                    const SizedBox(height: 20),
                    _buildFormField('Short Description', descController, Icons.info_outline_rounded, maxLines: 3),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (titleController.text.trim().isEmpty) {
                            _showError('Please enter a service title');
                            return;
                          }
                          try {
                            final newItem = AmplifyModels.ServiceItems(
                              name: titleController.text.trim(),
                              data: jsonEncode({
                                'description': descController.text.trim(),
                                'details': {},
                              }),
                            );
                            final request = ModelMutations.create(newItem);
                            await Amplify.API.mutate(request: request).response;
                            
                            if (mounted) Navigator.pop(context);
                            _fetchServices();
                            _showSuccess('Service created successfully');
                          } catch (e) {
                            _showError('Failed to add service: $e');
                          }
                        },
                        icon: const Icon(Icons.check_rounded, size: 20),
                        label: const Text('Add Service', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));
  }

  void _showSuccess(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 900;
        final filtered = _services.where((s) => 
          s.title.toLowerCase().contains(_searchTerm.toLowerCase())
        ).toList();

        return ResponsiveScaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _showAddForm,
            backgroundColor: AppTheme.primaryColor,
            elevation: 8,
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: const Text('New Service', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ).animate().scale(delay: 400.ms),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCompactHeader(isWide),
              _buildSlimSearchArea(isWide),
              Expanded(
                child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                    ? _buildEmptyState()
                    : isWide 
                      ? GridView.builder(
                          padding: const EdgeInsets.all(24),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            mainAxisExtent: 200,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) => _buildManagerServiceCard(filtered[index], index, true),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const Divider(height: 1, indent: 70),
                          itemBuilder: (context, index) => _buildServiceListTile(filtered[index], index),
                        ),
              ),
            ],
          ).animate().fadeIn(),
        );
      },
    );
  }

  Widget _headerAction(IconData icon, VoidCallback onTap) {
    return IconButton.filled(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: AppTheme.primaryColor.withOpacity(0.08),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildCompactHeader(bool isWide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 32 : 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A), size: 18),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Service Catalog',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_services.length} Services',
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: Color(0xFF475569),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _showAddForm,
            icon: const Icon(Icons.add_rounded, size: 18, color: Color(0xFFD4AF37)),
            label: const Text('New Service', style: TextStyle(fontFamily: 'Montserrat', color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlimSearchArea(bool isWide) {
    return Padding(
      padding: EdgeInsets.fromLTRB(isWide ? 32 : 20, 24, isWide ? 32 : 20, 8),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: TextField(
          onChanged: (val) => setState(() => _searchTerm = val),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: 'Search within catalog...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryColor, size: 22),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.layers_clear_rounded, size: 60, color: Colors.grey.shade200),
          const SizedBox(height: 12),
          const Text('No services match your search', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildServiceListTile(ServiceItem service, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showEditForm(service),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.1),
                      AppTheme.primaryColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(_getServiceIcon(service.title), color: AppTheme.primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: -0.3),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service.description,
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 40).ms).slideX(begin: 0.05, curve: Curves.easeOutCubic);
  }

  Widget _buildManagerServiceCard(ServiceItem service, int index, bool isWide) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(Icons.business_center_rounded, size: 100, color: AppTheme.primaryColor.withOpacity(0.03)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_getServiceIcon(service.title), color: AppTheme.primaryColor, size: 20),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _showEditForm(service),
                          icon: const Icon(Icons.edit_note_rounded, color: AppTheme.primaryColor),
                          tooltip: 'Edit Service',
                        ),
                        IconButton(
                          onPressed: () => _confirmDelete(service),
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  service.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    service.description.isNotEmpty ? service.description : 'System optimized consultancy service.',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                  child: const Text('ACTIVE SERVICE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1);
  }

  void _confirmDelete(ServiceItem service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to remove "${service.title}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                final request = ModelMutations.delete(AmplifyModels.ServiceItems(id: service.id));
                await Amplify.API.mutate(request: request).response;
                if (mounted) Navigator.pop(context);
                _fetchServices();
                _showSuccess('Service deleted');
              } catch (e) {
                _showError('Delete failed: $e');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String title) {
    final t = title.toLowerCase();
    if (t.contains('gst')) return Icons.account_balance_rounded;
    if (t.contains('registration')) return Icons.app_registration_rounded;
    if (t.contains('tax')) return Icons.money_rounded;
    if (t.contains('license')) return Icons.verified_user_rounded;
    if (t.contains('digital')) return Icons.vpn_key_rounded;
    if (t.contains('billing')) return Icons.receipt_long_rounded;
    return Icons.business_center_rounded;
  }
}

class _EditServiceForm extends StatefulWidget {
  final ServiceItem service;
  final VoidCallback onSaved;

  const _EditServiceForm({required this.service, required this.onSaved});

  @override
  State<_EditServiceForm> createState() => _EditServiceFormState();
}

class _EditServiceFormState extends State<_EditServiceForm> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late Map<String, dynamic> _details;
  late List<Map<String, dynamic>> _faqs;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.service.title);
    _descController = TextEditingController(text: widget.service.description);
    
    _details = Map<String, dynamic>.from((widget.service.details as Map?) ?? {});
    final faqsRaw = _details['faqs'] as List<dynamic>? ?? [];
    
    _faqs = faqsRaw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Widget _buildFormField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: maxLines == 1 ? Icon(icon, size: 20, color: AppTheme.primaryColor) : null,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
          ),
        ),
      ],
    );
  }

  void _addFaq() {
    setState(() {
      _faqs.add({'q': '', 'a': ''});
    });
  }

  void _removeFaq(int index) {
    setState(() {
      _faqs.removeAt(index);
    });
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      _details['faqs'] = _faqs;
      
      final getReq = ModelQueries.get(AmplifyModels.ServiceItems.classType, AmplifyModels.ServiceItemsModelIdentifier(id: widget.service.id));
      final getRes = await Amplify.API.query(request: getReq).response;
      
      final existing = getRes.data;
      if (existing != null) {
        Map<String, dynamic> dataMap = {};
        if (existing.data != null) {
          try { dataMap = jsonDecode(existing.data!); } catch (_) {}
        }
        dataMap['description'] = _descController.text.trim();
        dataMap['details'] = _details;
        
        final updated = existing.copyWith(
          name: _titleController.text.trim(),
          data: jsonEncode(dataMap),
        );
        
        final updateReq = ModelMutations.update(updated);
        await Amplify.API.mutate(request: updateReq).response;
      }
      
      widget.onSaved();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save: $e'), backgroundColor: Colors.redAccent));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Edit Service', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(widget.service.title, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(backgroundColor: Colors.grey.shade100),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormField('Display Title', _titleController, Icons.title_rounded),
                  const SizedBox(height: 20),
                  _buildFormField('Description', _descController, Icons.description_rounded, maxLines: 3),
                  const SizedBox(height: 32),
                  
                  // FAQs Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.help_outline_rounded, size: 20, color: AppTheme.primaryColor),
                          SizedBox(width: 8),
                          Text('Frequently Asked Questions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: _addFaq,
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Add FAQ'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_faqs.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                      child: const Center(child: Text('No FAQs added yet.', style: TextStyle(color: AppTheme.textSecondary))),
                    )
                  else
                    ...List.generate(_faqs.length, (index) {
                      final faq = _faqs[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Question ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textSecondary, fontSize: 12)),
                                IconButton(
                                  onPressed: () => _removeFaq(index),
                                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              initialValue: faq['q'],
                              onChanged: (v) => faq['q'] = v,
                              decoration: InputDecoration(
                                hintText: 'Enter question...',
                                isDense: true,
                                contentPadding: const EdgeInsets.all(12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              initialValue: faq['a'],
                              onChanged: (v) => faq['a'] = v,
                              maxLines: 2,
                              decoration: InputDecoration(
                                hintText: 'Enter answer...',
                                isDense: true,
                                contentPadding: const EdgeInsets.all(12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 8,
                        shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                      ),
                      child: _isLoading 
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Update Service', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

