class Client {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? typeOfWork;
  final String? caseNumber;
  final String? fileDate;
  final String? fileNo;
  final bool? isContacted;
  final String? balanceDue;
  final DateTime? createdAt;
  final String? courtName;
  final String? opposingParty;
  final String? opposingCounsel;
  final String? caseStatus;
  final String? nextHearingDate;
  final String? clientType;
  final String? careOf;

  Client({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.typeOfWork,
    this.caseNumber,
    this.fileDate,
    this.fileNo,
    this.isContacted,
    this.balanceDue,
    this.createdAt,
    this.courtName,
    this.opposingParty,
    this.opposingCounsel,
    this.caseStatus,
    this.nextHearingDate,
    this.clientType,
    this.careOf,
  });

  Client copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? typeOfWork,
    String? caseNumber,
    String? fileDate,
    String? fileNo,
    bool? isContacted,
    String? balanceDue,
    DateTime? createdAt,
    String? courtName,
    String? opposingParty,
    String? opposingCounsel,
    String? caseStatus,
    String? nextHearingDate,
    String? clientType,
    String? careOf,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      typeOfWork: typeOfWork ?? this.typeOfWork,
      caseNumber: caseNumber ?? this.caseNumber,
      fileDate: fileDate ?? this.fileDate,
      fileNo: fileNo ?? this.fileNo,
      isContacted: isContacted ?? this.isContacted,
      balanceDue: balanceDue ?? this.balanceDue,
      createdAt: createdAt ?? this.createdAt,
      courtName: courtName ?? this.courtName,
      opposingParty: opposingParty ?? this.opposingParty,
      opposingCounsel: opposingCounsel ?? this.opposingCounsel,
      caseStatus: caseStatus ?? this.caseStatus,
      nextHearingDate: nextHearingDate ?? this.nextHearingDate,
      clientType: clientType ?? this.clientType,
      careOf: careOf ?? this.careOf,
    );
  }

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client.fromMap(json);
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id']?.toString(),
      name: map['name'] as String?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      address: map['address'] as String?,
      typeOfWork: map['type_of_work'] as String?,
      caseNumber: map['case_number'] as String?,
      fileDate: map['file_date'] as String?,
      fileNo: map['file_no'] as String?,
      isContacted: map['isContacted'] ?? map['is_contacted'],
      balanceDue: map['balanceDue'] ?? map['balance_due'],
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt'].toString()) : null,
      courtName: map['courtName'] ?? map['court_name'],
      opposingParty: map['opposingParty'] ?? map['opposing_party'],
      opposingCounsel: map['opposingCounsel'] ?? map['opposing_counsel'],
      caseStatus: map['caseStatus'] ?? map['case_status'],
      nextHearingDate: map['nextHearingDate'] ?? map['next_hearing_date'],
      clientType: map['clientType'] ?? map['client_type'],
      careOf: map['careOf'] ?? map['care_of'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'type_of_work': typeOfWork,
      'case_number': caseNumber,
      'file_date': fileDate,
      'file_no': fileNo,
      'isContacted': isContacted,
      'balanceDue': balanceDue,
      'createdAt': createdAt?.toIso8601String(),
      'courtName': courtName,
      'opposingParty': opposingParty,
      'opposingCounsel': opposingCounsel,
      'caseStatus': caseStatus,
      'nextHearingDate': nextHearingDate,
      'clientType': clientType,
      'careOf': careOf,
    };
  }
}
