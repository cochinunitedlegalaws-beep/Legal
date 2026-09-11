import 'client_service.dart';
import 'case_service.dart';

class ConflictCheckService {
  final ClientService _clientService = ClientService();

  Future<List<Map<String, dynamic>>> performConflictCheck(String query) async {
    if (query.trim().isEmpty) return [];

    List<Map<String, dynamic>> results = [];
    final lowerQuery = query.toLowerCase();

    // 1. Search Clients
    try {
      final clients = await _clientService.searchClients(query);
      for (var client in clients) {
        results.add({
          'type': 'Client Record',
          'match': client['name'],
          'details': 'Phone: ${client['phone'] ?? 'N/A'} | Email: ${client['email'] ?? 'N/A'}',
          'data': client,
        });
      }
    } catch (e) {
      print('Error searching clients for conflict check: $e');
    }

    // 2. Search Cases
    try {
      final cases = await CaseService.getCases();
      for (var c in cases) {
        bool matched = false;
        String matchField = '';
        
        final clientName = (c['client_name'] ?? '').toString();
        final opposingParty = (c['opposing_party'] ?? c['company_details'] ?? '').toString();
        final opposingCounsel = (c['opposing_counsel'] ?? '').toString();
        final caseTitle = (c['case_title'] ?? c['deal_name'] ?? '').toString();

        if (clientName.toLowerCase().contains(lowerQuery)) {
          matched = true;
          matchField = 'Client in Case: $clientName';
        } else if (opposingParty.toLowerCase().contains(lowerQuery)) {
          matched = true;
          matchField = 'Opposing Party: $opposingParty';
        } else if (opposingCounsel.toLowerCase().contains(lowerQuery)) {
          matched = true;
          matchField = 'Opposing Counsel: $opposingCounsel';
        } else if (caseTitle.toLowerCase().contains(lowerQuery)) {
          matched = true;
          matchField = 'Case Title Match: $caseTitle';
        }

        if (matched) {
          results.add({
            'type': 'Case Record',
            'match': matchField,
            'details': 'Case Title: $caseTitle | Status: ${c['status'] ?? 'N/A'}',
            'data': c,
          });
        }
      }
    } catch (e) {
      print('Error searching cases for conflict check: $e');
    }

    return results;
  }
}
