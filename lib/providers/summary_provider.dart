import 'package:flutter/foundation.dart';
import 'package:flutter_winddown/services/storage_service.dart';

class SummaryProvider extends ChangeNotifier {
  final StorageService _storageService;
  
  bool _completedToday = false;
  DateTime? _completionTime;
  
  SummaryProvider(this._storageService) {
    _loadCompletion();
  }
  
  bool get completedToday => _completedToday;
  DateTime? get completionTime => _completionTime;
  
  String get formattedCompletionTime {
    if (_completionTime == null) return '';
    final hour = _completionTime!.hour;
    final minute = _completionTime!.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 
        ? hour - 12 
        : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }
  
  Future<void> loadCompletion() async {
    // Check and reset if 8 hours have passed
    await _storageService.checkAndResetAfter8Hours();
    
    _completedToday = _storageService.getCompletedToday();
    _completionTime = _storageService.getCompletionTime();
    notifyListeners();
  }
  
  Future<void> _loadCompletion() async {
    await loadCompletion();
  }
  
  Future<void> markCompleted() async {
    _completedToday = true;
    _completionTime = DateTime.now();
    await _storageService.setCompletedToday(true);
    notifyListeners();
  }
}





