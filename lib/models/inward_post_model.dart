enum PostStatus {
  pendingConfirmation,
  confirmed,
  actionRequired,
  completed
}

class InwardPost {
  final String id;
  final String senderName;
  final String recipientName;
  final String receivedBy;
  final DateTime receivedDate;
  final PostStatus status;
  final String description;

  InwardPost({
    required this.id,
    required this.senderName,
    required this.recipientName,
    required this.receivedBy,
    required this.receivedDate,
    required this.status,
    required this.description,
  });

  InwardPost copyWith({
    String? id,
    String? senderName,
    String? recipientName,
    String? receivedBy,
    DateTime? receivedDate,
    PostStatus? status,
    String? description,
  }) {
    return InwardPost(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      recipientName: recipientName ?? this.recipientName,
      receivedBy: receivedBy ?? this.receivedBy,
      receivedDate: receivedDate ?? this.receivedDate,
      status: status ?? this.status,
      description: description ?? this.description,
    );
  }

  factory InwardPost.fromJson(Map<String, dynamic> json) {
    return InwardPost(
      id: json['id']?.toString() ?? '',
      senderName: json['sender_name']?.toString() ?? '',
      recipientName: json['recipient_name']?.toString() ?? '',
      receivedBy: json['received_by']?.toString() ?? '',
      receivedDate: json['received_date'] != null ? DateTime.parse(json['received_date'].toString()) : DateTime.now(),
      status: PostStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => PostStatus.pendingConfirmation,
      ),
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_name': senderName,
      'recipient_name': recipientName,
      'received_by': receivedBy,
      'received_date': receivedDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'description': description,
    };
  }
}
