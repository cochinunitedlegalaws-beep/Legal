import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/file_delivery_model.dart';
import '../services/file_delivery_service.dart';
import '../models/deal.dart';
import '../services/deal_service.dart';
import '../widgets/responsive.dart';

class FileDeliveryScreen extends StatefulWidget {
  const FileDeliveryScreen({super.key});

  @override
  State<FileDeliveryScreen> createState() => _FileDeliveryScreenState();
}

class _FileDeliveryScreenState extends State<FileDeliveryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<FileDeliveryModel> _deliveries = [];
  bool _isLoading = true;
  List<Deal> _deals = [];

  // Form Controllers
  final _clientController = TextEditingController();
  final _addressController = TextEditingController();
  final _documentsController = TextEditingController();
  final _staffController = TextEditingController();
  final _remarksController = TextEditingController();
  DeliveryType _formType = DeliveryType.delivery;
  Deal? _selectedDeal;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _clientController.dispose();
    _addressController.dispose();
    _documentsController.dispose();
    _staffController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      _deliveries = await FileDeliveryService.getDeliveries();
      _deals = await DealService().getAllDeals();
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showCreateDialog() {
    _clientController.clear();
    _addressController.clear();
    _documentsController.clear();
    _staffController.clear();
    _remarksController.clear();
    _formType = _tabController.index == 0
        ? DeliveryType.delivery
        : DeliveryType.pickup;
    _selectedDeal = null;
    _selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: AppTheme.surfaceColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                  maxHeight: 800,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'CREATE REQUEST',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentColor,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<DeliveryType>(
                                title: const Text(
                                  'Delivery',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                value: DeliveryType.delivery,
                                groupValue: _formType,
                                activeColor: AppTheme.accentColor,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (val) =>
                                    setDialogState(() => _formType = val!),
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<DeliveryType>(
                                title: const Text(
                                  'Pickup',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                value: DeliveryType.pickup,
                                groupValue: _formType,
                                activeColor: AppTheme.accentColor,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (val) =>
                                    setDialogState(() => _formType = val!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildDealAutocomplete(setDialogState),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: _clientController,
                          hint: 'Client Name',
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: _addressController,
                          hint: 'Address',
                          icon: Icons.location_on,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: _documentsController,
                          hint: 'Documents Description',
                          icon: Icons.description,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: _staffController,
                          hint: 'Assigned Staff Name',
                          icon: Icons.badge,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputField(
                                controller: _remarksController,
                                hint: 'Remarks (Optional)',
                                icon: Icons.note,
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.calendar_today, size: 16),
                              label: Text(
                                DateFormat('MMM dd').format(_selectedDate),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.backgroundColor,
                                foregroundColor: AppTheme.textPrimary,
                              ),
                              onPressed: () async {
                                final d = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate,
                                  firstDate: DateTime.now().subtract(
                                    const Duration(days: 30),
                                  ),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                );
                                if (d != null) {
                                  setDialogState(() => _selectedDate = d);
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'CANCEL',
                                style: TextStyle(color: AppTheme.textSecondary),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentColor,
                                foregroundColor: AppTheme.backgroundColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                if (_clientController.text.isEmpty ||
                                    _addressController.text.isEmpty ||
                                    _documentsController.text.isEmpty ||
                                    _staffController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please fill all required fields',
                                      ),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }
                                final newReq = FileDeliveryModel(
                                  id: DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                                  type: _formType,
                                  caseId: _selectedDeal?.id,
                                  caseName: _selectedDeal?.name,
                                  clientName: _clientController.text.trim(),
                                  address: _addressController.text.trim(),
                                  documents: _documentsController.text.trim(),
                                  assignedStaffName: _staffController.text
                                      .trim(),
                                  status: DeliveryStatus.pending,
                                  scheduledDate: _selectedDate,
                                  remarks: _remarksController.text.trim(),
                                );
                                await FileDeliveryService.createDelivery(
                                  newReq,
                                );
                                if (mounted) {
                                  Navigator.pop(context);
                                  _loadData();
                                }
                              },
                              child: const Text(
                                'SAVE REQUEST',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDealAutocomplete(StateSetter setDialogState) {
    return Autocomplete<Deal>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Deal>.empty();
        }
        return _deals.where((Deal deal) {
          final dealName = deal.name.toLowerCase();
          final clientName = (deal.clientName ?? '').toLowerCase();
          final query = textEditingValue.text.toLowerCase();
          return dealName.contains(query) || clientName.contains(query);
        });
      },
      displayStringForOption: (Deal option) =>
          '${option.name} (${option.clientName ?? 'No Client'})',
      onSelected: (Deal selection) {
        setDialogState(() {
          _selectedDeal = selection;
          if (_clientController.text.isEmpty && selection.clientName != null) {
            _clientController.text = selection.clientName!;
          }
        });
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        if (_selectedDeal != null && controller.text.isEmpty) {
          controller.text =
              '${_selectedDeal!.name} (${_selectedDeal!.clientName ?? 'No Client'})';
        }
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Link to a Work / Deal (Optional)',
            hintStyle: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
            prefixIcon: const Icon(
              Icons.business_center,
              color: AppTheme.accentColor,
            ),
            suffixIcon: _selectedDeal != null
                ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      size: 20,
                      color: AppTheme.textSecondary,
                    ),
                    onPressed: () {
                      controller.clear();
                      setDialogState(() => _selectedDeal = null);
                    },
                  )
                : null,
            filled: true,
            fillColor: AppTheme.backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.textSecondary.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.textSecondary.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.accentColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.textSecondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 20),
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _updateStatus(FileDeliveryModel d, DeliveryStatus newStatus) async {
    final updated = d.copyWith(
      status: newStatus,
      completedDate: newStatus == DeliveryStatus.completed
          ? DateTime.now()
          : null,
    );
    await FileDeliveryService.updateDelivery(updated);
    _loadData();
  }

  Color _getStatusColor(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.pending:
        return Colors.orange;
      case DeliveryStatus.inTransit:
        return Colors.blue;
      case DeliveryStatus.completed:
        return Colors.green;
      case DeliveryStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.pending:
        return 'Pending';
      case DeliveryStatus.inTransit:
        return 'In Transit';
      case DeliveryStatus.completed:
        return 'Completed';
      case DeliveryStatus.cancelled:
        return 'Cancelled';
    }
  }

  Widget _buildList(DeliveryType type) {
    final list = _deliveries.where((e) => e.type == type).toList();
    if (list.isEmpty) {
      return Center(
        child: Text(
          'No ${type == DeliveryType.delivery ? 'deliveries' : 'pickups'} found.',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final d = list[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.textSecondary.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      d.clientName,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(d.status).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getStatusText(d.status),
                      style: TextStyle(
                        color: _getStatusColor(d.status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (d.caseName != null) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.business_center,
                      size: 14,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      d.caseName!,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 14,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      d.address,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.description,
                    size: 14,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      d.documents,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white10),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Assigned To',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        d.assignedStaffName,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Scheduled',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy').format(d.scheduledDate),
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (d.status != DeliveryStatus.completed &&
                  d.status != DeliveryStatus.cancelled) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (d.status == DeliveryStatus.pending)
                      ElevatedButton(
                        onPressed: () =>
                            _updateStatus(d, DeliveryStatus.inTransit),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Mark In Transit',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    if (d.status == DeliveryStatus.inTransit)
                      ElevatedButton(
                        onPressed: () =>
                            _updateStatus(d, DeliveryStatus.completed),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Mark Completed',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'File Delivery',
          style: TextStyle(fontFamily: 'Cinzel', color: AppTheme.textPrimary),
        ),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.accentColor,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.accentColor,
          tabs: const [
            Tab(text: 'Deliveries'),
            Tab(text: 'Pickups'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateDialog,
        backgroundColor: AppTheme.accentColor,
        foregroundColor: AppTheme.backgroundColor,
        icon: const Icon(Icons.add),
        label: const Text(
          'Create Request',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildList(DeliveryType.delivery),
                _buildList(DeliveryType.pickup),
              ],
            ),
    );
  }
}
