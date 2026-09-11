class Billing {
  final String? id;
  final String? clientName;
  final String? invoiceNo;
  final String? date;
  final String? amount;
  final String? type;
  final String? category;
  final String? authorities;
  final String? status;
  final Map<String, dynamic>? data;
  final DateTime? createdAt;
  final String? userRole;

  Billing({
    this.id,
    this.clientName,
    this.invoiceNo,
    this.date,
    this.amount,
    this.type,
    this.category,
    this.authorities,
    this.status,
    this.data,
    this.createdAt,
    this.userRole,
  });

  List<Map<String, dynamic>> get items {
    try {
      final list = data?['items'] as List<dynamic>? ?? [];
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }
  double get grandTotal {
    try {
      return double.tryParse(data?['grandTotal']?.toString() ?? '0') ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }
  double get outstandingAmount {
    try {
      return double.tryParse(data?['outstandingAmount']?.toString() ?? '0') ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }
  String get amountInWords {
    try {
      return data?['amountInWords'] ?? '';
    } catch (e) {
      return '';
    }
  }

  Billing copyWith({
    String? id,
    String? clientName,
    String? invoiceNo,
    String? date,
    String? amount,
    String? type,
    String? category,
    String? authorities,
    String? status,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    String? userRole,
  }) {
    return Billing(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      invoiceNo: invoiceNo ?? this.invoiceNo,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      authorities: authorities ?? this.authorities,
      status: status ?? this.status,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      userRole: userRole ?? this.userRole,
    );
  }

  factory Billing.fromJson(Map<String, dynamic> json) {
    return Billing(
      id: json['id']?.toString(),
      clientName: json['client_name']?.toString(),
      invoiceNo: json['invoice_no']?.toString(),
      date: json['date']?.toString(),
      amount: json['amount']?.toString(),
      type: json['type']?.toString(),
      category: json['category']?.toString(),
      authorities: json['authorities']?.toString(),
      status: json['status']?.toString(),
      data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      userRole: json['user_role']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'client_name': clientName,
      'invoice_no': invoiceNo,
      'date': date,
      'amount': amount,
      'type': type,
      'category': category,
      'authorities': authorities,
      'status': status,
      'data': data,
      if (createdAt != null) 'created_at': createdAt?.toIso8601String(),
      'user_role': userRole,
    };
  }
}
