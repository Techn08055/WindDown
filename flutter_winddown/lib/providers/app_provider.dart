import 'package:flutter/foundation.dart';
import 'package:winddown/services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  final StorageService _storageService;
  
  AppProvider(this._storageService) {
    _init();
  }
  
  Future<void> _init() async {
    await _storageService.resetDailyCompletion();
  }
}




