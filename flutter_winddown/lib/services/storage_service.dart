import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _bedtimeHourKey = 'bedtime_hour';
  static const String _bedtimeMinuteKey = 'bedtime_minute';
  static const String _trustModeKey = 'trust_mode';
  static const String _calmItemsKey = 'calm_items';
  static const String _completedTodayKey = 'completed_today';
  static const String _completionTimeKey = 'completion_time';
  
  late SharedPreferences _prefs;
  
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Bedtime
  Future<void> setBedtime(int hour, int minute) async {
    await _prefs.setInt(_bedtimeHourKey, hour);
    await _prefs.setInt(_bedtimeMinuteKey, minute);
  }
  
  Bedtime? getBedtime() {
    final hour = _prefs.getInt(_bedtimeHourKey);
    final minute = _prefs.getInt(_bedtimeMinuteKey);
    if (hour != null && minute != null) {
      return Bedtime(hour, minute);
    }
    return null;
  }
  
  // Trust Mode
  Future<void> setTrustMode(bool enabled) async {
    await _prefs.setBool(_trustModeKey, enabled);
  }
  
  bool getTrustMode() {
    return _prefs.getBool(_trustModeKey) ?? false;
  }
  
  // Calm Items
  Future<void> setCalmItems(List<String> items) async {
    await _prefs.setStringList(_calmItemsKey, items);
  }
  
  List<String> getCalmItems() {
    final items = _prefs.getStringList(_calmItemsKey);
    if (items != null && items.isNotEmpty) {
      return items;
    }
    // Default items
    return [
      'Home feels safe.',
      'Kitchen is settled.',
      'Water\'s off, day\'s off.',
      'Mind ready for rest.',
    ];
  }
  
  // Completion
  Future<void> setCompletedToday(bool completed) async {
    await _prefs.setBool(_completedTodayKey, completed);
    if (completed) {
      await _prefs.setString(_completionTimeKey, DateTime.now().toIso8601String());
    }
  }
  
  bool getCompletedToday() {
    return _prefs.getBool(_completedTodayKey) ?? false;
  }
  
  DateTime? getCompletionTime() {
    final timeStr = _prefs.getString(_completionTimeKey);
    if (timeStr != null) {
      try {
        return DateTime.parse(timeStr);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
  
  // Reset daily completion (call this at midnight or app start)
  Future<void> resetDailyCompletion() async {
    final lastCompletion = getCompletionTime();
    if (lastCompletion != null) {
      final now = DateTime.now();
      if (now.day != lastCompletion.day ||
          now.month != lastCompletion.month ||
          now.year != lastCompletion.year) {
        await setCompletedToday(false);
      }
    }
  }
}

class Bedtime {
  final int hour;
  final int minute;
  
  Bedtime(this.hour, this.minute);
  
  @override
  String toString() {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }
}

