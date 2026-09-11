class Task {
  final String id;
  final String title;
  final String? remark;
  final String? caseId;
  final bool isRelatedToCase;
  final String priority;
  final String? assignedTo;
  final DateTime? deadline;
  final DateTime? createdAt;
  final DateTime? lastUpdated;
  final String? createdBy;
  final bool isCompleted;
  final DateTime? adjournedTo;
  final String? adjournReason;

  Task({
    required this.id,
    this.title = 'Untitled Task',
    this.remark,
    this.caseId,
    this.isRelatedToCase = false,
    this.priority = 'Medium',
    this.assignedTo,
    this.deadline,
    this.createdAt,
    this.lastUpdated,
    this.createdBy,
    this.isCompleted = false,
    this.adjournedTo,
    this.adjournReason,
  });

  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  bool isOverdue() {
    if (deadline == null || isCompleted) return false;
    return DateTime.now().isAfter(deadline!);
  }
  
  String getPriorityLevel() {
    return priority;
  }

  Task copyWith({
    String? id,
    String? title,
    String? remark,
    String? caseId,
    bool? isRelatedToCase,
    String? priority,
    String? assignedTo,
    DateTime? deadline,
    DateTime? createdAt,
    DateTime? lastUpdated,
    String? createdBy,
    bool? isCompleted,
    DateTime? adjournedTo,
    String? adjournReason,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      remark: remark ?? this.remark,
      caseId: caseId ?? this.caseId,
      isRelatedToCase: isRelatedToCase ?? this.isRelatedToCase,
      priority: priority ?? this.priority,
      assignedTo: assignedTo ?? this.assignedTo,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdBy: createdBy ?? this.createdBy,
      isCompleted: isCompleted ?? this.isCompleted,
      adjournedTo: adjournedTo ?? this.adjournedTo,
      adjournReason: adjournReason ?? this.adjournReason,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? 'Untitled Task',
      remark: json['remark'] as String?,
      caseId: json['case_id']?.toString(),
      isRelatedToCase: json['is_related_to_case'] as bool? ?? (json['case_id'] != null && json['case_id'].toString().isNotEmpty),
      priority: json['priority'] as String? ?? 'Medium',
      assignedTo: json['assigned_to']?.toString(),
      deadline: json['deadline'] != null ? DateTime.tryParse(json['deadline'].toString()) : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      lastUpdated: json['last_updated'] != null ? DateTime.tryParse(json['last_updated'].toString()) : null,
      createdBy: json['created_by'] as String?,
      isCompleted: json['is_completed'] == true,
      adjournedTo: json['adjourned_to'] != null ? DateTime.tryParse(json['adjourned_to'].toString()) : null,
      adjournReason: json['adjourn_reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'remark': remark,
      'case_id': caseId,
      'is_related_to_case': isRelatedToCase,
      'priority': priority,
      'assigned_to': assignedTo,
      'deadline': deadline?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'last_updated': lastUpdated?.toIso8601String(),
      'created_by': createdBy,
      'is_completed': isCompleted,
      'adjourned_to': adjournedTo?.toIso8601String(),
      'adjourn_reason': adjournReason,
    };
  }
}

