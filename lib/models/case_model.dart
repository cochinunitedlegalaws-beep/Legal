class CaseModel {
  final String id;
  CaseModel({required this.id});
}
class CaseFile {
  final String id;
  final String caseTitle;
  final String courtCaseNumber;
  final String caseStatus;
  final String courtName;
  final String opposingParty;
  final String opposingCounsel;
  
  CaseFile({
    required this.id,
    required this.caseTitle,
    this.courtCaseNumber = '',
    this.caseStatus = '',
    this.courtName = '',
    this.opposingParty = '',
    this.opposingCounsel = '',
  });

  factory CaseFile.fromJson(Map<String, dynamic> json) => CaseFile(
    id: json['id'] ?? '',
    caseTitle: json['caseTitle'] ?? json['case_title'] ?? '',
    courtCaseNumber: json['courtCaseNumber'] ?? json['court_case_number'] ?? '',
    caseStatus: json['caseStatus'] ?? json['case_status'] ?? '',
    courtName: json['courtName'] ?? json['court_name'] ?? '',
    opposingParty: json['opposingParty'] ?? json['opposing_party'] ?? '',
    opposingCounsel: json['opposingCounsel'] ?? json['opposing_counsel'] ?? '',
  );
}
