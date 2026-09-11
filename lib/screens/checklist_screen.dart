import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../models/checklist.dart';
import '../services/checklist_service.dart';
import '../services/auth_service.dart';
import '../services/case_service.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_app_bar.dart';
import '../widgets/responsive.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final _checklistService = ChecklistService();
  final _authService = AuthService();
  
  bool _isLoading = true;
  bool _isManager = false;
  String? _userId;
  List<Checklist> _checklists = [];
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _cases = [];
  
  // Create Checklist Form
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String? _selectedResponsibleId;
  String? _selectedCaseId;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    setState(() => _isLoading = true);
    _userId = await _authService.getUserEmail(); // Use email as user ID
    _isManager = await _authService.isManager() || await _authService.isAdmin();
    
    if (_isManager) {
      _users = await _checklistService.getAllUsers();
      _cases = await CaseService.getCases();
    }
    
    await _fetchChecklists();
    setState(() => _isLoading = false);
  }

  Future<void> _fetchChecklists() async {
    if (_userId == null) return;
    
    if (_isManager) {
      _checklists = await _checklistService.getAllChecklists();
    } else {
      _checklists = await _checklistService.getChecklistsForUser(_userId!);
    }
  }

  Future<void> _handleRefresh() async {
    await _fetchChecklists();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const ResponsiveScaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ResponsiveScaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const PremiumAppBar(
        title: Text("Today's Checklist"),
      ),
      body: _buildChecklistList(),
      floatingActionButton: _isManager ? FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setDialogState) => Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.all(24),
                child: _buildCreateForm(setDialogState),
              ),
            ),
          );
        },
        icon: const Icon(Icons.add_task_rounded, color: Color(0xFFD4AF37), size: 18),
        label: const Text('Create Task', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFD4AF37))),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ) : null,
    );
  }

  Widget _buildChecklistList() {
    if (_checklists.isEmpty) {
      return RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          children: const [
            SizedBox(height: 100),
            Center(child: Text("No checklists for today.", style: TextStyle(color: Colors.grey))),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _checklists.length,
        itemBuilder: (context, index) {
          final checklist = _checklists[index];
          return _buildChecklistCard(checklist);
        },
      ),
    );
  }

  Widget _buildChecklistCard(Checklist checklist) {
    Color statusColor = Colors.grey;
    switch (checklist.status) {
      case 'Completed': statusColor = Colors.green; break;
      case 'Not Completed': statusColor = Colors.red; break;
      case 'Postponed': statusColor = Colors.orange; break;
      case 'Pending': statusColor = Colors.blue; break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
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
                    checklist.title ?? '',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    checklist.status ?? 'Pending',
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            if (checklist.description != null && checklist.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(checklist.description!, style: const TextStyle(color: Colors.grey)),
            ],
            if (checklist.caseId != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.link, size: 14, color: AppTheme.primaryColor),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "Connected Case: ${checklist.caseName ?? checklist.caseId}",
                      style: const TextStyle(fontSize: 12, color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  _isManager ? "Responsible: ${checklist.responsibleName ?? 'Unassigned'}" : "Assigned by: ${checklist.managerName ?? 'System'}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            if (checklist.status != 'Pending') ...[
              const SizedBox(height: 8),
              Text(
                checklist.status == 'Completed' ? "Remarks: ${checklist.remarks ?? ''}" : "Reason: ${checklist.reason ?? ''}",
                style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
              ),
            ],
            if (!_isManager && checklist.status == 'Pending') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showStatusDialog(checklist, 'Completed'),
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text("Complete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showStatusDialog(checklist, 'Not Completed'),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text("Not Done"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showStatusDialog(checklist, 'Postponed'),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
                      child: const Text("Postpone"),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCreateForm(StateSetter setDialogState) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            elevation: 8,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.assignment_add, color: AppTheme.primaryColor, size: 28),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Create New Task", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              Text("Assign a daily checklist to a staff member", style: TextStyle(color: AppTheme.textSecondary)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 24,
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: "Task Title",
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
                        prefixIcon: const Icon(Icons.title, color: AppTheme.primaryColor),
                      ),
                      validator: (v) => v == null || v.isEmpty ? "Please enter a title" : null,
                    ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideX(begin: 0.05),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _descController,
                      decoration: InputDecoration(
                        labelText: "Description (Optional)",
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 48),
                          child: Icon(Icons.description, color: AppTheme.primaryColor),
                        ),
                      ),
                      maxLines: 3,
                    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideX(begin: 0.05),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Autocomplete<Map<String, dynamic>>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) return const Iterable<Map<String, dynamic>>.empty();
                            return _users.where((u) => "\ (\)".toLowerCase().contains(textEditingValue.text.toLowerCase()));
                          },
                          displayStringForOption: (u) => "\ (\)",
                          onSelected: (u) => setDialogState(() => _selectedResponsibleId = u['email']),
                          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                            return TextFormField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                labelText: "Search & Assign Staff",
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
                                prefixIcon: const Icon(Icons.person, color: AppTheme.primaryColor),
                                suffixIcon: const Icon(Icons.search, color: Colors.grey),
                              ),
                              onChanged: (val) {
                                if (val.isEmpty) setDialogState(() => _selectedResponsibleId = null);
                              },
                            );
                          },
                          optionsViewBuilder: (context, onSelected, options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(12),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: 250, maxWidth: constraints.maxWidth),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: options.length,
                                    itemBuilder: (context, index) {
                                      final option = options.elementAt(index);
                                      return ListTile(
                                        title: Text("\ (\)", style: const TextStyle(fontWeight: FontWeight.w500)),
                                        onTap: () => onSelected(option),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideX(begin: 0.05),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Autocomplete<Map<String, dynamic>>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) return const Iterable<Map<String, dynamic>>.empty();
                            return _cases.where((d) => (d['case_title'] as String? ?? '').toLowerCase().contains(textEditingValue.text.toLowerCase()));
                          },
                          displayStringForOption: (d) => d['case_title'] as String? ?? 'Unknown Case',
                          onSelected: (d) => setDialogState(() => _selectedCaseId = d['id']),
                          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                            return TextFormField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                labelText: "Search & Connect Case (Optional)",
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
                                prefixIcon: const Icon(Icons.link, color: AppTheme.primaryColor),
                                suffixIcon: const Icon(Icons.search, color: Colors.grey),
                              ),
                              onChanged: (val) {
                                if (val.isEmpty) setDialogState(() => _selectedCaseId = null);
                              },
                            );
                          },
                          optionsViewBuilder: (context, onSelected, options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(12),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: 250, maxWidth: constraints.maxWidth),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: options.length,
                                    itemBuilder: (context, index) {
                                      final option = options.elementAt(index);
                                      return ListTile(
                                        title: Text(option['case_title'] as String? ?? 'Unknown Case', style: const TextStyle(fontWeight: FontWeight.w500)),
                                        onTap: () => onSelected(option),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideX(begin: 0.05),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text("Assign Task to Staff", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ).animate().fadeIn(delay: 400.ms, duration: 400.ms).scale(begin: const Offset(0.95, 0.95)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedResponsibleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields and assign to a staff member.")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      String? caseName;
      if (_selectedCaseId != null) {
        caseName = _cases.firstWhere((d) => d['id'] == _selectedCaseId)['case_title'];
      }
      
      final checklist = Checklist(
        title: _titleController.text ?? '',
        description: _descController.text,
        responsibleId: _selectedResponsibleId,
        caseId: _selectedCaseId,
        caseName: caseName,
      );
      
      await _checklistService.createChecklist(checklist);
      
      _titleController.clear();
      _descController.clear();
      setState(() {
        _selectedResponsibleId = null;
        _selectedCaseId = null;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Checklist assigned successfully!")),
        );
        Navigator.pop(context); // Close the dialog
      }
      await _fetchChecklists();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showStatusDialog(Checklist checklist, String status) {
    final controller = TextEditingController();
    final isComplete = status == 'Completed';
    final isPostponed = status == 'Postponed';
    
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    bool giveToManager = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isComplete ? "Complete Task" : (isPostponed ? "Postpone Task" : "Report Issue")),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Are you sure you want to mark this as $status?"),
                const SizedBox(height: 16),
                if (isPostponed) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("New Due Date", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: Text(DateFormat('dd MMM yyyy').format(selectedDate)),
                    trailing: const Icon(Icons.calendar_today, size: 20, color: AppTheme.primaryColor),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setDialogState(() => selectedDate = picked);
                      }
                    },
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Give back to manager", style: TextStyle(fontSize: 14)),
                    value: giveToManager,
                    onChanged: (val) => setDialogState(() => giveToManager = val ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 8),
                ],
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: isComplete ? "Remarks" : "Reason",
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() => _isLoading = true);
                try {
                  await _checklistService.updateChecklistStatus(
                    checklist.id!,
                    status,
                    remarks: isComplete ? controller.text : null,
                    reason: !isComplete ? controller.text : null,
                    newDueDate: isPostponed ? DateFormat('yyyy-MM-dd').format(selectedDate) : null,
                    reassignToManager: isPostponed && giveToManager,
                  );
                  await _fetchChecklists();
                } catch (e) {
                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isComplete ? Colors.green : (isPostponed ? Colors.orange : Colors.red),
                foregroundColor: Colors.white,
              ),
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
