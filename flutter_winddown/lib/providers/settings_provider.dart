import 'package:flutter/foundation.dart';
import 'package:winddown/services/storage_service.dart';
import 'package:winddown/services/notification_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService;
  final NotificationService _notificationService;
  
  int _bedtimeHour = 22;
  int _bedtimeMinute = 30;
  bool _trustMode = false;
  List<String> _calmItems = [];
  
  SettingsProvider(this._storageService, this._notificationService) {
    _loadSettings();
  }
  
  int get bedtimeHour => _bedtimeHour;
  int get bedtimeMinute => _bedtimeMinute;
  bool get trustMode => _trustMode;
  List<String> get calmItems => _calmItems;
  
  String get formattedBedtime {
    final period = _bedtimeHour >= 12 ? 'PM' : 'AM';
    final displayHour = _bedtimeHour > 12 
        ? _bedtimeHour - 12 
        : (_bedtimeHour == 0 ? 12 : _bedtimeHour);
    return '$displayHour:${_bedtimeMinute.toString().padLeft(2, '0')} $period';
  }
  
  Future<void> _loadSettings() async {
    final bedtime = _storageService.getBedtime();
    if (bedtime != null) {
      _bedtimeHour = bedtime.hour;
      _bedtimeMinute = bedtime.minute;
    }
    _trustMode = _storageService.getTrustMode();
    _calmItems = _storageService.getCalmItems();
    notifyListeners();
  }
  
  Future<void> updateBedtime(int hour, int minute) async {
    _bedtimeHour = hour;
    _bedtimeMinute = minute;
    await _storageService.setBedtime(hour, minute);
    await _notificationService.scheduleBedtimeNotification(hour, minute);
    notifyListeners();
  }
  
  Future<void> toggleTrustMode() async {
    _trustMode = !_trustMode;
    await _storageService.setTrustMode(_trustMode);
    notifyListeners();
  }
  
  Future<void> updateCalmItem(int index, String text) async {
    if (index >= 0 && index < _calmItems.length) {
      _calmItems[index] = text;
      await _storageService.setCalmItems(_calmItems);
      notifyListeners();
    }
  }
  
  Future<void> addCalmItem(String text) async {
    _calmItems.add(text);
    await _storageService.setCalmItems(_calmItems);
    notifyListeners();
  }
  
  Future<void> removeCalmItem(int index) async {
    if (index >= 0 && index < _calmItems.length) {
      _calmItems.removeAt(index);
      await _storageService.setCalmItems(_calmItems);
      notifyListeners();
    }
  }
}




