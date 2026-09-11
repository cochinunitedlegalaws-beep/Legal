class ChamberDocument {
  final String id;
  final String title;
  final String encryptedContent;
  final String createdBy;
  final DateTime createdAt;
  final String lastEditedBy;
  final DateTime lastEditedAt;
  final String category;

  ChamberDocument({
    required this.id,
    required this.title,
    required this.encryptedContent,
    required this.createdBy,
    required this.createdAt,
    required this.lastEditedBy,
    required this.lastEditedAt,
    required this.category,
  });

  static String generateId() => DateTime.now().millisecondsSinceEpoch.toString();
  
  factory ChamberDocument.fromJson(Map<String, dynamic> json) => ChamberDocument(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    encryptedContent: json['encrypted_content'] ?? '',
    createdBy: json['created_by'] ?? '',
    createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    lastEditedBy: json['last_edited_by'] ?? '',
    lastEditedAt: DateTime.tryParse(json['last_edited_at'] ?? '') ?? DateTime.now(),
    category: json['category'] ?? '',
  );
}
