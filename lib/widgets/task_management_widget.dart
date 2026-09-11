import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

String _formatDeadline(DateTime deadline) {
  final dateString = '${deadline.year.toString().padLeft(4, '0')}-'
      '${deadline.month.toString().padLeft(2, '0')}-'
      '${deadline.day.toString().padLeft(2, '0')}';
  final timeString = '${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}';
  return '$dateString $timeString';
}

class TaskManagementWidget extends StatefulWidget {
  final String? caseId;
  final String? assignedTo;
  final bool showCompletedTasks;

  const TaskManagementWidget({
    Key? key,
    this.caseId,
    this.assignedTo,
    this.showCompletedTasks = false,
  }) : super(key: key);

  @override
  State<TaskManagementWidget> createState() => _TaskManagementWidgetState();
}

class _TaskManagementWidgetState extends State<TaskManagementWidget> {
  late Future<List<Task>> tasksFuture;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    if (widget.caseId != null) {
      tasksFuture = TaskService.getTasksByCase(widget.caseId!);
    } else if (widget.assignedTo != null) {
      tasksFuture = TaskService.getTasksByAssignee(widget.assignedTo!);
    } else {
      tasksFuture = TaskService.getTasks();
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.yellow.shade700;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return Icons.priority_high;
      case 'high':
        return Icons.arrow_upward;
      case 'medium':
        return Icons.remove;
      case 'low':
        return Icons.arrow_downward;
      default:
        return Icons.help;
    }
  }

  void _showTaskDialog(BuildContext context, {Task? task}) {
    showDialog(
      context: context,
      builder: (context) => TaskDialogWidget(
        task: task,
        caseId: widget.caseId,
        onSave: (updatedTask) {
          _loadTasks();
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: tasksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)),
            ),
          );
        }

        var tasks = snapshot.data ?? [];

        if (!widget.showCompletedTasks) {
          tasks = tasks.where((t) => !t.isCompleted).toList();
        }

        // Sort by priority and deadline
        tasks.sort((a, b) {
          final priorityCompare = b.getPriorityLevel().compareTo(a.getPriorityLevel());
          if (priorityCompare != 0) return priorityCompare;
          
          if (a.deadline == null && b.deadline == null) return 0;
          if (a.deadline == null) return 1;
          if (b.deadline == null) return -1;
          return a.deadline!.compareTo(b.deadline!);
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tasks (${tasks.length})',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showTaskDialog(context),
                    icon: Icon(Icons.add),
                    label: Text('New Task'),
                  ),
                ],
              ),
            ),
            if (tasks.isEmpty)
              Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text('No tasks', style: TextStyle(color: Colors.grey)),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final isOverdue = task.isOverdue();
                  
                  return ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) async {
                        await TaskService.updateTaskStatus(task.id, value ?? false);
                        _loadTasks();
                        setState(() {});
                      },
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                                        if (task.deadline != null)
                          Text(
                            'Deadline: ${_formatDeadline(task.deadline!)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isOverdue ? Colors.red : Colors.grey,
                              fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        if (task.isRelatedToCase)
                          Text(
                            'Related to case',
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                      ],
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(task.priority).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getPriorityIcon(task.priority),
                            size: 14,
                            color: _getPriorityColor(task.priority),
                          ),
                          SizedBox(width: 4),
                          Text(
                            task.priority,
                            style: TextStyle(
                              fontSize: 11,
                              color: _getPriorityColor(task.priority),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => _showTaskDialog(context, task: task),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

/// Dialog widget for creating/editing tasks
class TaskDialogWidget extends StatefulWidget {
  final Task? task;
  final String? caseId;
  final Function(Task) onSave;

  const TaskDialogWidget({
    Key? key,
    this.task,
    this.caseId,
    required this.onSave,
  }) : super(key: key);

  @override
  State<TaskDialogWidget> createState() => _TaskDialogWidgetState();
}

class _TaskDialogWidgetState extends State<TaskDialogWidget> {
  late TextEditingController titleController;
  late TextEditingController remarkController;
  late String selectedPriority;
  DateTime? selectedDeadline;
  TimeOfDay? selectedDeadlineTime;
  bool isRelatedToCase = false;
  String? relatedCaseId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task?.title ?? '');
    remarkController = TextEditingController(text: widget.task?.remark ?? '');
    selectedPriority = widget.task?.priority ?? 'Medium';
    selectedDeadline = widget.task?.deadline;
    selectedDeadlineTime = widget.task?.deadline != null
        ? TimeOfDay.fromDateTime(widget.task!.deadline!)
        : null;
    isRelatedToCase = widget.task?.isRelatedToCase ?? (widget.caseId != null);
    relatedCaseId = widget.task?.caseId ?? widget.caseId;
  }

  @override
  void dispose() {
    titleController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      final existingTime = selectedDeadlineTime ?? TimeOfDay(hour: 9, minute: 0);
      setState(() {
        selectedDeadline = DateTime(
          picked.year,
          picked.month,
          picked.day,
          existingTime.hour,
          existingTime.minute,
        );
      });
      Future.delayed(Duration.zero, _selectTime);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedDeadlineTime ?? TimeOfDay(hour: 9, minute: 0),
    );

    if (picked != null) {
      setState(() {
        selectedDeadlineTime = picked;
        final deadlineDate = selectedDeadline ?? DateTime.now();
        selectedDeadline = DateTime(
          deadlineDate.year,
          deadlineDate.month,
          deadlineDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _saveTask() async {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      Task taskToSave;

      if (widget.task != null) {
        taskToSave = widget.task!.copyWith(
          title: titleController.text,
          remark: remarkController.text,
          priority: selectedPriority,
          deadline: selectedDeadline,
          isRelatedToCase: isRelatedToCase,
          caseId: isRelatedToCase ? relatedCaseId : null,
        );
        await TaskService.updateTask(widget.task!.id, taskToSave);
      } else {
        taskToSave = Task(
          id: Task.generateId(),
          title: titleController.text,
          remark: remarkController.text.isEmpty ? null : remarkController.text,
          priority: selectedPriority,
          deadline: selectedDeadline,
          isRelatedToCase: isRelatedToCase,
          caseId: isRelatedToCase ? relatedCaseId : null,
          createdAt: DateTime.now(),
          lastUpdated: DateTime.now(),
        );
        await TaskService.addTask(taskToSave);
      }

      widget.onSave(taskToSave);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving task: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Create Task' : 'Edit Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: remarkController,
              decoration: InputDecoration(labelText: 'Remarks'),
              maxLines: 2,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedPriority,
              decoration: InputDecoration(labelText: 'Priority'),
              items: ['Low', 'Medium', 'High', 'Critical']
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (value) => setState(() => selectedPriority = value ?? 'Medium'),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Deadline Date'),
              subtitle: Text(
                selectedDeadline == null
                    ? 'No deadline set'
                    : '${selectedDeadline!.toString().split(' ')[0]}',
              ),
              onTap: _selectDate,
            ),
            ListTile(
              title: Text('Deadline Time'),
              subtitle: Text(
                selectedDeadlineTime == null
                    ? 'No time set'
                    : selectedDeadlineTime!.format(context),
              ),
              onTap: _selectTime,
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Related to Case'),
              value: isRelatedToCase,
              onChanged: (value) => setState(() => isRelatedToCase = value ?? false),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : _saveTask,
          child: Text(isLoading ? 'Saving...' : 'Save'),
        ),
      ],
    );
  }
}

/// Compact task list widget for dashboard
class CompactTaskListWidget extends StatefulWidget {
  final String? assignedTo;
  final int maxTasks;

  const CompactTaskListWidget({
    Key? key,
    this.assignedTo,
    this.maxTasks = 5,
  }) : super(key: key);

  @override
  State<CompactTaskListWidget> createState() => _CompactTaskListWidgetState();
}

class _CompactTaskListWidgetState extends State<CompactTaskListWidget> {
  late Future<List<Task>> tasksFuture;

  @override
  void initState() {
    super.initState();
    if (widget.assignedTo != null) {
      tasksFuture = TaskService.getTasksByAssignee(widget.assignedTo!);
    } else {
      tasksFuture = TaskService.getUrgentTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: tasksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        var tasks = snapshot.data ?? [];
        tasks = tasks.where((t) => !t.isCompleted).take(widget.maxTasks).toList();

        if (tasks.isEmpty) {
          return Text('No pending tasks', style: TextStyle(color: Colors.grey));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            tasks.length,
            (index) {
              final task = tasks[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.check_box_outline_blank, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    if (task.priority == 'Critical')
                      Icon(Icons.priority_high, size: 14, color: Colors.red),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
