import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks user sessions with check-in/check-out times, active hours,
/// and daily history using SharedPreferences for persistence.
class SessionTrackingService {
  // Keys for SharedPreferences
  static String _checkInKey(String email) => 'session_checkin_$email';
  static String _checkOutKey(String email) => 'session_checkout_$email';
  static String _totalSecondsKey(String email, String dateStr) => 'session_total_${email}_$dateStr';
  static String _dailyCheckInKey(String email, String dateStr) => 'session_daily_checkin_${email}_$dateStr';
  static String _dailyCheckOutKey(String email, String dateStr) => 'session_daily_checkout_${email}_$dateStr';
  static String _historyDatesKey(String email) => 'session_history_dates_$email';

  static String _todayStr() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  static String _formatTime(DateTime dt) {
    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:$minute $period';
  }

  /// Record check-in at login time. Saves exact timestamp.
  static Future<void> checkIn(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final todayStr = _todayStr();

    // Store exact check-in ISO timestamp (for calculating duration later)
    await prefs.setString(_checkInKey(email), now.toIso8601String());

    // ONLY store the human-readable check-in time for today if it is the first login of the day!
    if (!prefs.containsKey(_dailyCheckInKey(email, todayStr))) {
      await prefs.setString(_dailyCheckInKey(email, todayStr), _formatTime(now));
    }

    // Clear checkout for today (user is now active)
    await prefs.remove(_dailyCheckOutKey(email, todayStr));

    // Track this date in the history
    await _addDateToHistory(email, todayStr);
  }

  /// Record check-out at logout time. Calculates session duration and adds to daily total.
  static Future<void> checkOut(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final todayStr = _todayStr();

    // Get the check-in timestamp
    final checkInStr = prefs.getString(_checkInKey(email));
    if (checkInStr != null) {
      final checkInTime = DateTime.parse(checkInStr);
      final sessionSeconds = now.difference(checkInTime).inSeconds;

      // Add session duration to today's total
      final existingTotal = prefs.getInt(_totalSecondsKey(email, todayStr)) ?? 0;
      await prefs.setInt(_totalSecondsKey(email, todayStr), existingTotal + sessionSeconds);
    }

    // Store checkout time
    await prefs.setString(_checkOutKey(email), now.toIso8601String());
    await prefs.setString(_dailyCheckOutKey(email, todayStr), _formatTime(now));

    // Clear the active check-in marker
    await prefs.remove(_checkInKey(email));
  }

  /// Get the current active session stats for a user.
  static Future<SessionStats> getStats(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final todayStr = _todayStr();

    final checkInTimeStr = prefs.getString(_dailyCheckInKey(email, todayStr)) ?? '--';
    final checkOutTimeStr = prefs.getString(_dailyCheckOutKey(email, todayStr)) ?? '--';
    final totalSecondsToday = prefs.getInt(_totalSecondsKey(email, todayStr)) ?? 0;

    // Check if there's an active session right now
    final activeCheckInStr = prefs.getString(_checkInKey(email));
    int currentSessionSeconds = 0;
    bool isActive = false;

    if (activeCheckInStr != null) {
      final checkInTime = DateTime.parse(activeCheckInStr);
      currentSessionSeconds = DateTime.now().difference(checkInTime).inSeconds;
      isActive = true;
    }

    final totalActiveSeconds = totalSecondsToday + currentSessionSeconds;

    return SessionStats(
      checkInTime: checkInTimeStr,
      checkOutTime: isActive ? 'Active Now' : checkOutTimeStr,
      totalActiveSeconds: totalActiveSeconds,
      currentSessionSeconds: currentSessionSeconds,
      isActive: isActive,
    );
  }

  /// Get a list of daily attendance records for the user (history).
  static Future<List<DailyRecord>> getDailyHistory(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final datesStr = prefs.getStringList(_historyDatesKey(email)) ?? [];

    final records = <DailyRecord>[];
    for (final dateStr in datesStr.reversed) {
      final checkIn = prefs.getString(_dailyCheckInKey(email, dateStr)) ?? '--';
      final checkOut = prefs.getString(_dailyCheckOutKey(email, dateStr)) ?? '--';
      final totalSeconds = prefs.getInt(_totalSecondsKey(email, dateStr)) ?? 0;

      // If today and still active, add current session
      int adjustedSeconds = totalSeconds;
      if (dateStr == _todayStr()) {
        final activeCheckInStr = prefs.getString(_checkInKey(email));
        if (activeCheckInStr != null) {
          final checkInTime = DateTime.parse(activeCheckInStr);
          adjustedSeconds += DateTime.now().difference(checkInTime).inSeconds;
        }
      }

      records.add(DailyRecord(
        date: dateStr,
        checkInTime: checkIn,
        checkOutTime: checkOut,
        totalActiveSeconds: adjustedSeconds,
      ));
    }

    return records;
  }

  static Future<void> _addDateToHistory(String email, String dateStr) async {
    final prefs = await SharedPreferences.getInstance();
    final dates = prefs.getStringList(_historyDatesKey(email)) ?? [];
    if (!dates.contains(dateStr)) {
      dates.add(dateStr);
      await prefs.setStringList(_historyDatesKey(email), dates);
    }
  }

  /// Add extra explicit seconds to today's active time (e.g. from case timers)
  static Future<void> addExtraTime(String email, int additionalSeconds) async {
    final prefs = await SharedPreferences.getInstance();
    final todayStr = _todayStr();

    final existingTotal = prefs.getInt(_totalSecondsKey(email, todayStr)) ?? 0;
    await prefs.setInt(_totalSecondsKey(email, todayStr), existingTotal + additionalSeconds);
    
    // Track this date in the history if not already there
    await _addDateToHistory(email, todayStr);
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

  /// Calculate payment from total seconds and an hourly rate.
  static double calculatePayment(int totalSeconds, double hourlyRate) {
    return (totalSeconds / 3600.0) * hourlyRate;
  }
}

/// Data class for current session stats
class SessionStats {
  final String checkInTime;
  final String checkOutTime;
  final int totalActiveSeconds;
  final int currentSessionSeconds;
  final bool isActive;

  SessionStats({
    required this.checkInTime,
    required this.checkOutTime,
    required this.totalActiveSeconds,
    required this.currentSessionSeconds,
    required this.isActive,
  });
}

/// Data class for a single day's attendance record
class DailyRecord {
  final String date;
  final String checkInTime;
  final String checkOutTime;
  final int totalActiveSeconds;

  DailyRecord({
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.totalActiveSeconds,
  });
}
