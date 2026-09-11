import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../services/task_service.dart';
import '../widgets/responsive.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final bool isMyTask;
  final VoidCallback onStatusUpdate;

  const TaskDetailScreen({
    super.key,
    required this.task,
    this.isMyTask = false,
    required this.onStatusUpdate,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task _task;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  Future<void> _updateStatus(bool isCompleted) async {
    setState(() => _isLoading = true);
    try {
      await TaskService.updateTaskStatus(_task.id, isCompleted);
      
      setState(() {
        _task = _task.copyWith(isCompleted: isCompleted);
      });
      
      widget.onStatusUpdate();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  Future<void> _adjournTask(String reason, DateTime postponedDate) async {
    setState(() => _isLoading = true);
    try {
      final updatedTask = _task.copyWith(
        adjournReason: reason,
        adjournedTo: postponedDate,
      );
      
      await TaskService.updateTask(_task.id, updatedTask);
      
      setState(() {
        _task = updatedTask;
      });
      
      widget.onStatusUpdate();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to adjourn: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = _task.isCompleted;
    final isAdjourned = _task.adjournedTo != null && !isCompleted;
    final statusText = isCompleted ? 'Completed' : (isAdjourned ? 'Adjourned' : 'Pending');
    final statusColor = isCompleted 
        ? Colors.green 
        : (isAdjourned ? Colors.amber.shade700 : AppTheme.primaryColor);
    
    final isOverdue = _task.isOverdue();

    return ResponsiveScaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            stretch: true,
            backgroundColor: statusColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [statusColor, statusColor.withOpacity(0.7)],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Icon(Icons.assignment_rounded, size: 200, color: Colors.white.withOpacity(0.1)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            statusText.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _task.title,
                          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isOverdue)
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade100),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
                          const SizedBox(width: 12),
                          const Text('This task is past its due date!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ).animate().shake(),

                  Row(
                    children: [
                      Expanded(child: _buildQuickInfo(Icons.person_outline, 'Assigned To', _task.assignedTo ?? 'Unassigned')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildQuickInfo(Icons.flag_rounded, 'Priority', _task.priority)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildQuickInfo(Icons.calendar_today_rounded, 'Due Date', _task.deadline != null ? DateFormat('MMM dd, yyyy').format(_task.deadline!) : 'No Date')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildQuickInfo(Icons.access_time_rounded, 'Due Time', _task.deadline != null ? DateFormat('hh:mm a').format(_task.deadline!) : 'No Time')),
                    ],
                  ),
                  const SizedBox(height: 32),

                  const Text('REMARK / DESCRIPTION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Text(
                      _task.remark == null || _task.remark!.isEmpty ? 'No description provided.' : _task.remark!,
                      style: const TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF334155)),
                    ),
                  ),
                  
                  if (isAdjourned) ...[
                    const SizedBox(height: 32),
                    const Text('ADJOURNMENT DETAILS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary, letterSpacing: 1)),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.amber.shade200),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline_rounded, color: Colors.amber.shade900),
                              const SizedBox(width: 8),
                              const Text(
                                'TASK ADJOURNED',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Reason: ${_task.adjournReason}',
                            style: const TextStyle(fontSize: 15, color: Color(0xFF78350F), height: 1.5),
                          ),
                          if (_task.adjournedTo != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Postponed Date: ${DateFormat('dd MMM yyyy').format(_task.adjournedTo!)}',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF78350F)),
                            ),
                          ],
                        ],
                      ),
                    ).animate().fadeIn().scale(),
                  ],
                  
                  const SizedBox(height: 32),

                  const Text('ADDITIONAL DETAILS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  
                  if (_task.caseId != null)
                    _buildDetailTile(Icons.folder_open_rounded, 'Linked Case ID', _task.caseId!),
                    
                  _buildDetailTile(Icons.history_rounded, 'Created On', DateFormat('dd MMM yyyy, hh:mm a').format(_task.createdAt ?? DateTime.now())),
                  _buildDetailTile(Icons.verified_user_outlined, 'Assigned By', _task.createdBy ?? 'System'),
                  
                  const SizedBox(height: 40),

                  if (!isCompleted)
                    Center(
                      child: Column(
                        children: [
                          const Text('ACTION REQUIRED', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textSecondary, letterSpacing: 2)),
                          const SizedBox(height: 16),
                          _isLoading 
                            ? const CircularProgressIndicator()
                            : Column(
                                children: [
                                  _SlideAction(
                                    key: ValueKey(isCompleted),
                                    label: isAdjourned ? 'SLIDE TO COMPLETE ANYWAY' : 'SLIDE TO COMPLETE',
                                    baseColor: Colors.green,
                                    onSlide: () => _updateStatus(true),
                                  ),
                                  if (!isAdjourned) ...[
                                    const SizedBox(height: 16),
                                    OutlinedButton.icon(
                                      onPressed: () async {
                                        final reasonController = TextEditingController();
                                        DateTime? postponedDate;
                                        
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (c) => StatefulBuilder(
                                            builder: (context, setStateModal) {
                                              return AlertDialog(
                                                title: const Text('Adjourn Task'),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller: reasonController,
                                                      decoration: const InputDecoration(
                                                        labelText: 'Reason for Adjournment',
                                                        border: OutlineInputBorder(),
                                                      ),
                                                      maxLines: 2,
                                                    ),
                                                    const SizedBox(height: 16),
                                                    ListTile(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        side: BorderSide(color: Colors.grey.shade300),
                                                      ),
                                                      title: Text(postponedDate == null 
                                                          ? 'Select Postponed Date' 
                                                          : 'Postponed to: ${DateFormat('dd MMM yyyy').format(postponedDate!)}'),
                                                      trailing: const Icon(Icons.calendar_today),
                                                      onTap: () async {
                                                        final picked = await showDatePicker(
                                                          context: context,
                                                          initialDate: DateTime.now().add(const Duration(days: 1)),
                                                          firstDate: DateTime.now(),
                                                          lastDate: DateTime.now().add(const Duration(days: 365)),
                                                        );
                                                        if (picked != null) {
                                                          setStateModal(() => postponedDate = picked);
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(c, false),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      if (reasonController.text.isEmpty || postponedDate == null) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text('Please fill all fields')),
                                                        );
                                                        return;
                                                      }
                                                      Navigator.pop(c, true);
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.amber.shade800,
                                                      foregroundColor: Colors.white,
                                                    ),
                                                    child: const Text('Adjourn'),
                                                  ),
                                                ],
                                              );
                                            }
                                          ),
                                        );
                                        
                                        if (confirm == true) {
                                          _adjournTask(reasonController.text, postponedDate!);
                                        }
                                      },
                                      icon: const Icon(Icons.pause_circle_outline_rounded),
                                      label: const Text('ADJOURN TASK', style: TextStyle(fontWeight: FontWeight.bold)),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.amber.shade800,
                                        side: BorderSide(color: Colors.amber.shade800, width: 2),
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 300.ms),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfo(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value, 
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), height: 1.2),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: onTap != null ? [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.05), shape: BoxShape.circle),
                child: Icon(icon, size: 18, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                    Text(
                      value, 
                      style: TextStyle(
                        fontSize: 14, 
                        fontWeight: FontWeight.w600, 
                        color: const Color(0xFF1E293B),
                        decoration: onTap != null ? TextDecoration.underline : null,
                        decorationColor: AppTheme.primaryColor.withOpacity(0.3),
                      )
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.open_in_new_rounded, size: 14, color: AppTheme.primaryColor.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlideAction extends StatefulWidget {
  final String label;
  final VoidCallback onSlide;
  final Color baseColor;

  const _SlideAction({super.key, required this.label, required this.onSlide, required this.baseColor});

  @override
  State<_SlideAction> createState() => _SlideActionState();
}

class _SlideActionState extends State<_SlideAction> {
  double _position = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        return Container(
          width: maxWidth,
          height: 64,
          decoration: BoxDecoration(
            color: widget.baseColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(widget.label, style: TextStyle(color: widget.baseColor, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
              ),
              Positioned(
                left: _position + 4,
                top: 4,
                bottom: 4,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _position += details.delta.dx;
                      if (_position < 0) _position = 0;
                      if (_position > maxWidth - 60) _position = maxWidth - 60;
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_position > maxWidth - 80) {
                      setState(() => _position = maxWidth - 60);
                      widget.onSlide();
                    } else {
                      setState(() => _position = 0);
                    }
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: widget.baseColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: widget.baseColor.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))
                      ],
                    ),
                    child: const Icon(Icons.double_arrow_rounded, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
