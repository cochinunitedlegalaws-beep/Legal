class Checklist {
  final String? id;
  final String? title;
  final String? description;
  final String? responsibleId;
  final String? responsibleName;
  final String? managerId;
  final String? managerName;
  final String? caseId;
  final String? caseName;
  final String? dueDate;
  final String? status;
  final String? remarks;
  final String? reason;
  final DateTime? createdAt;

  Checklist({
    this.id,
    this.title,
    this.description,
    this.responsibleId,
    this.responsibleName,
    this.managerId,
    this.managerName,
    this.caseId,
    this.caseName,
    this.dueDate,
    this.status = 'Pending',
    this.remarks,
    this.reason,
    this.createdAt,
  });

  factory Checklist.fromMap(Map<String, dynamic> map) {
    return Checklist(
      id: map['id']?.toString(),
      title: map['title'] as String?,
      description: map['description'] as String?,
      responsibleId: map['responsible_id']?.toString(),
      responsibleName: map['responsible_name'] as String?,
      managerId: map['manager_id']?.toString(),
      managerName: map['manager_name'] as String?,
      caseId: map['case_id']?.toString(),
      caseName: map['case_name'] as String?,
      dueDate: map['due_date'] as String?,
      status: map['status'] as String? ?? 'Pending',
      remarks: map['remarks'] as String?,
      reason: map['reason'] as String?,
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'responsible_id': responsibleId,
      'responsible_name': responsibleName,
      'manager_id': managerId,
      'manager_name': managerName,
      'case_id': caseId,
      'case_name': caseName,
      'due_date': dueDate,
      'status': status,
      'remarks': remarks,
      'reason': reason,
      if (createdAt != null) 'created_at': createdAt?.toIso8601String(),
    };
  }
}
