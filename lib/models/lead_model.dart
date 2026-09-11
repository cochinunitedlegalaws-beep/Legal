class Lead {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String notes;
  final String source;
  final String inquiryType;
  final DateTime createdAt;
  String status;
  DateTime lastModifiedAt;

  Lead({
    required this.id,
    this.name = '',
    this.phone = '',
    this.email = '',
    this.notes = '',
    this.source = '',
    this.inquiryType = '',
    required this.createdAt,
    required this.status,
    required this.lastModifiedAt,
  });

  static String generateId() => DateTime.now().millisecondsSinceEpoch.toString();

  factory Lead.fromJson(Map<String, dynamic> json) => Lead(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    phone: json['phone'] ?? '',
    email: json['email'] ?? '',
    notes: json['notes'] ?? '',
    source: json['source'] ?? '',
    inquiryType: json['inquiryType'] ?? json['inquiry_type'] ?? '',
    createdAt: DateTime.tryParse(json['createdAt'] ?? json['created_at'] ?? '') ?? DateTime.now(),
    status: json['status'] ?? '',
    lastModifiedAt: DateTime.tryParse(json['lastModifiedAt'] ?? json['last_modified_at'] ?? '') ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'notes': notes,
    'source': source,
    'inquiryType': inquiryType,
    'status': status,
  };
}
