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
  
  // Check if 8 hours have passed since completion
  bool isWithin8HoursOfCompletion() {
    final completionTime = getCompletionTime();
    if (completionTime == null) return false;
    
    final now = DateTime.now();
    final difference = now.difference(completionTime);
    return difference.inHours < 8;
  }
  
  // Reset completion and calm items after 8 hours
  Future<void> checkAndResetAfter8Hours() async {
    final completionTime = getCompletionTime();
    if (completionTime == null) return;
    
    final now = DateTime.now();
    final difference = now.difference(completionTime);
    
    // If 8 hours have passed, reset completion and calm items
    if (difference.inHours >= 8) {
      await setCompletedToday(false);
      // Reset checked state of calm items
      await resetCalmItemsCheckedState();
    }
  }
  
  // Calm items checked state
  static const String _calmItemsCheckedKey = 'calm_items_checked';
  
  Future<void> setCalmItemsCheckedState(List<bool> checkedStates) async {
    final checkedList = checkedStates.map((b) => b ? '1' : '0').toList();
    await _prefs.setStringList(_calmItemsCheckedKey, checkedList);
  }
  
  List<bool> getCalmItemsCheckedState() {
    final checkedList = _prefs.getStringList(_calmItemsCheckedKey);
    if (checkedList != null && checkedList.isNotEmpty) {
      return checkedList.map((s) => s == '1').toList();
    }
    // Return all false if not set
    final items = getCalmItems();
    return List<bool>.filled(items.length, false);
  }
  
  Future<void> resetCalmItemsCheckedState() async {
    final items = getCalmItems();
    await setCalmItemsCheckedState(List<bool>.filled(items.length, false));
  }
  
  // Reset daily completion (call this at midnight or app start)
  Future<void> resetDailyCompletion() async {
    // Check if 8 hours have passed and reset if needed
    await checkAndResetAfter8Hours();
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

