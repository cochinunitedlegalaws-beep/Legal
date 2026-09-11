enum DocumentAction { created, viewed, edited, exported, imported, delete }

class DocumentAuditLog {
  final String documentId;
  final String documentTitle;
  final DocumentAction action;
  final String performedBy;
  final DateTime performedAt;
  final String details;

  DocumentAuditLog({
    required this.documentId,
    required this.documentTitle,
    required this.action,
    required this.performedBy,
    required this.performedAt,
    required this.details,
  });

  factory DocumentAuditLog.fromJson(Map<String, dynamic> json) {
    return DocumentAuditLog(
      documentId: json['documentId'] ?? json['document_id'] ?? '',
      documentTitle: json['documentTitle'] ?? json['document_title'] ?? '',
      action: DocumentAction.values.firstWhere((e) => e.name == json['action'], orElse: () => DocumentAction.viewed),
      performedBy: json['performedBy'] ?? json['performed_by'] ?? '',
      performedAt: DateTime.tryParse(json['performedAt'] ?? json['performed_at'] ?? '') ?? DateTime.now(),
      details: json['details'] ?? '',
    );
  }
}
