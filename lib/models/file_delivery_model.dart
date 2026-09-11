enum DeliveryType { delivery, pickup }

enum DeliveryStatus { pending, inTransit, completed, cancelled }

class FileDeliveryModel {
  final String id;
  final DeliveryType type;
  final String? caseId;
  final String? caseName;
  final String clientName;
  final String address;
  final String documents;
  final String assignedStaffName;
  final DeliveryStatus status;
  final DateTime scheduledDate;
  final DateTime? completedDate;
  final String? remarks;

  FileDeliveryModel({
    required this.id,
    required this.type,
    this.caseId,
    this.caseName,
    required this.clientName,
    required this.address,
    required this.documents,
    required this.assignedStaffName,
    required this.status,
    required this.scheduledDate,
    this.completedDate,
    this.remarks,
  });

  FileDeliveryModel copyWith({
    String? id,
    DeliveryType? type,
    String? caseId,
    String? caseName,
    String? clientName,
    String? address,
    String? documents,
    String? assignedStaffName,
    DeliveryStatus? status,
    DateTime? scheduledDate,
    DateTime? completedDate,
    String? remarks,
  }) {
    return FileDeliveryModel(
      id: id ?? this.id,
      type: type ?? this.type,
      caseId: caseId ?? this.caseId,
      caseName: caseName ?? this.caseName,
      clientName: clientName ?? this.clientName,
      address: address ?? this.address,
      documents: documents ?? this.documents,
      assignedStaffName: assignedStaffName ?? this.assignedStaffName,
      status: status ?? this.status,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      completedDate: completedDate ?? this.completedDate,
      remarks: remarks ?? this.remarks,
    );
  }

  factory FileDeliveryModel.fromJson(Map<String, dynamic> json) {
    return FileDeliveryModel(
      id: json['id']?.toString() ?? '',
      type: DeliveryType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => DeliveryType.delivery,
      ),
      caseId: json['caseId']?.toString(),
      caseName: json['caseName']?.toString(),
      clientName: json['clientName']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      documents: json['documents']?.toString() ?? '',
      assignedStaffName: json['assignedStaffName']?.toString() ?? '',
      status: DeliveryStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => DeliveryStatus.pending,
      ),
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'].toString())
          : DateTime.now(),
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'].toString())
          : null,
      remarks: json['remarks']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      if (caseId != null) 'caseId': caseId,
      if (caseName != null) 'caseName': caseName,
      'clientName': clientName,
      'address': address,
      'documents': documents,
      'assignedStaffName': assignedStaffName,
      'status': status.toString().split('.').last,
      'scheduledDate': scheduledDate.toIso8601String(),
      if (completedDate != null)
        'completedDate': completedDate?.toIso8601String(),
      if (remarks != null) 'remarks': remarks,
    };
  }
}
