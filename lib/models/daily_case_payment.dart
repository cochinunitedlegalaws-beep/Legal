class DailyCasePayment {
  final String id;
  final String eventId;
  final String caseId;
  final String clientName;
  final String caseType;
  final String amount;
  final String status;
  final String counsel;
  final DateTime dateRecorded;
  final DateTime lastUpdated;
  final String notes;
  final String paymentMethod;
  final String? chequeNumber;
  final DateTime? expectedPaymentDate;
  final String advanceAmount;
  final String balanceAmount;

  DailyCasePayment({
    required this.id,
    required this.eventId,
    required this.caseId,
    required this.clientName,
    required this.caseType,
    required this.amount,
    required this.status,
    required this.counsel,
    required this.dateRecorded,
    required this.lastUpdated,
    required this.notes,
    required this.paymentMethod,
    this.chequeNumber,
    this.expectedPaymentDate,
    required this.advanceAmount,
    required this.balanceAmount,
  });

  static String generateId() => DateTime.now().millisecondsSinceEpoch.toString();

  bool shouldShowReminder() => expectedPaymentDate != null && status != 'Paid';
  String getReminderStatus() => status;
  String getReminderText() => 'Payment due on \${expectedPaymentDate?.toString().split(' ')[0]}';

  factory DailyCasePayment.fromJson(Map<String, dynamic> json) {
    return DailyCasePayment(
      id: json['id']?.toString() ?? '',
      eventId: json['eventId']?.toString() ?? '',
      caseId: json['caseId']?.toString() ?? '',
      clientName: json['clientName']?.toString() ?? '',
      caseType: json['caseType']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '0.0',
      status: json['status']?.toString() ?? 'Pending',
      counsel: json['counsel']?.toString() ?? '',
      dateRecorded: json['dateRecorded'] != null ? DateTime.parse(json['dateRecorded'].toString()) : DateTime.now(),
      lastUpdated: json['lastUpdated'] != null ? DateTime.parse(json['lastUpdated'].toString()) : DateTime.now(),
      notes: json['notes']?.toString() ?? '',
      paymentMethod: json['paymentMethod']?.toString() ?? 'Cheque',
      chequeNumber: json['chequeNumber']?.toString(),
      expectedPaymentDate: json['expectedPaymentDate'] != null ? DateTime.tryParse(json['expectedPaymentDate'].toString()) : null,
      advanceAmount: json['advanceAmount']?.toString() ?? '0.0',
      balanceAmount: json['balanceAmount']?.toString() ?? '0.0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'caseId': caseId,
      'clientName': clientName,
      'caseType': caseType,
      'amount': amount,
      'status': status,
      'counsel': counsel,
      'dateRecorded': dateRecorded.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'notes': notes,
      'paymentMethod': paymentMethod,
      'chequeNumber': chequeNumber,
      if (expectedPaymentDate != null) 'expectedPaymentDate': expectedPaymentDate?.toIso8601String(),
      'advanceAmount': advanceAmount,
      'balanceAmount': balanceAmount,
    };
  }
}
