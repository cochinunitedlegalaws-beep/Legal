class ClientDocument {
  final String id;
  final String clientId;
  final String documentName;
  final String storagePath;
  final String remarks;
  final DateTime createdAt;
  final String clientName;
  final String ogCopy;
  final String uploadedBy;

  ClientDocument({
    required this.id,
    this.clientId = '',
    this.documentName = '',
    this.storagePath = '',
    this.remarks = '',
    required this.createdAt,
    this.clientName = '',
    this.ogCopy = 'Copy',
    this.uploadedBy = 'Unknown',
  });

  factory ClientDocument.fromJson(Map<String, dynamic> json) => ClientDocument(
    id: json['id'] ?? '',
    clientId: json['clientId'] ?? json['client_id'] ?? '',
    documentName: json['documentName'] ?? json['document_name'] ?? '',
    storagePath: json['storagePath'] ?? json['storage_path'] ?? '',
    remarks: json['remarks'] ?? '',
    createdAt: DateTime.tryParse(json['createdAt'] ?? json['created_at'] ?? '') ?? DateTime.now(),
    clientName: json['clientName'] ?? json['client_name'] ?? '',
    ogCopy: json['ogCopy']?.toString() ?? json['og_copy']?.toString() ?? 'Copy',
    uploadedBy: json['uploadedBy'] ?? json['uploaded_by'] ?? 'Unknown',
  );
  
  factory ClientDocument.fromMap(Map<String, dynamic> map) => ClientDocument.fromJson(map);
}

