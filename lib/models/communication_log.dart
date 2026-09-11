class CommunicationLog {
  final String id;
  final String relatedToId;
  final String relatedToType;
  final String contactName;
  final String type;
  final String direction;
  final String summary;
  final String staffName;
  final DateTime timestamp;

  CommunicationLog({
    required this.id,
    this.relatedToId = '',
    this.relatedToType = '',
    this.contactName = '',
    this.type = '',
    this.direction = '',
    this.summary = '',
    this.staffName = '',
    required this.timestamp,
  });

  static String generateId() => DateTime.now().millisecondsSinceEpoch.toString();

  factory CommunicationLog.fromJson(Map<String, dynamic> json) => CommunicationLog(
    id: json['id'] ?? '',
    relatedToId: json['relatedToId'] ?? json['related_to_id'] ?? '',
    relatedToType: json['relatedToType'] ?? json['related_to_type'] ?? '',
    contactName: json['contactName'] ?? json['contact_name'] ?? '',
    type: json['type'] ?? '',
    direction: json['direction'] ?? '',
    summary: json['summary'] ?? '',
    staffName: json['staffName'] ?? json['staff_name'] ?? '',
    timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {'id': id};
}
