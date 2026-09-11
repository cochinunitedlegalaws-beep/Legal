import 'package:shared_preferences/shared_preferences.dart';

class CaseTimerService {
  static const String _activeCaseIdKey = 'active_case_id';
  static const String _activeCaseTitleKey = 'active_case_title';
  static const String _activeClientNameKey = 'active_client_name';
  static const String _startTimeKey = 'active_case_start_time';

  /// Starts a timer for a specific case
  static Future<void> startTimer({
    required String caseId,
    required String caseTitle,
    required String clientName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    // If there is already an active timer, we should ideally stop it first, 
    // but for simplicity we will just overwrite it for now or enforce manual stop.
    await prefs.setString(_activeCaseIdKey, caseId);
    await prefs.setString(_activeCaseTitleKey, caseTitle);
    await prefs.setString(_activeClientNameKey, clientName);
    await prefs.setString(_startTimeKey, DateTime.now().toIso8601String());
  }

  /// Stops the current timer and returns the session details
  /// Returns null if no timer is active
  static Future<CaseSessionResult?> stopTimer() async {
    final prefs = await SharedPreferences.getInstance();
    
    final caseId = prefs.getString(_activeCaseIdKey);
    final caseTitle = prefs.getString(_activeCaseTitleKey);
    final clientName = prefs.getString(_activeClientNameKey);
    final startTimeStr = prefs.getString(_startTimeKey);

    if (caseId == null || startTimeStr == null) {
      return null; // No active session
    }

    final startTime = DateTime.parse(startTimeStr);
    final now = DateTime.now();
    final durationSeconds = now.difference(startTime).inSeconds;

    // Clear the active timer
    await prefs.remove(_activeCaseIdKey);
    await prefs.remove(_activeCaseTitleKey);
    await prefs.remove(_activeClientNameKey);
    await prefs.remove(_startTimeKey);

    return CaseSessionResult(
      caseId: caseId,
      caseTitle: caseTitle ?? 'Unknown Case',
      clientName: clientName ?? 'Unknown Client',
      durationSeconds: durationSeconds,
      startTime: startTime,
      endTime: now,
    );
  }

  /// Gets the currently active case ID, or null if none is active
  static Future<String?> getActiveCaseId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeCaseIdKey);
  }

  /// Gets the duration of the currently active session in seconds
  static Future<int> getActiveSessionSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    final startTimeStr = prefs.getString(_startTimeKey);
    if (startTimeStr == null) return 0;
    
    final startTime = DateTime.parse(startTimeStr);
    return DateTime.now().difference(startTime).inSeconds;
  }

  /// Format seconds into a human-readable string like "2h 15m" or "45m 12s"
  static String formatDuration(int totalSeconds) {
    if (totalSeconds <= 0) return '0m';
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}

class CaseSessionResult {
  final String caseId;
  final String caseTitle;
  final String clientName;
  final int durationSeconds;
  final DateTime startTime;
  final DateTime endTime;

  CaseSessionResult({
    required this.caseId,
    required this.caseTitle,
    required this.clientName,
    required this.durationSeconds,
    required this.startTime,
    required this.endTime,
  });

  double get hours => durationSeconds / 3600.0;
}
