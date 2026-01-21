import 'package:flutter/foundation.dart';
import 'package:flutter_winddown/services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  final StorageService _storageService;
  
  AppProvider(this._storageService) {
    _init();
  }
  
  Future<void> _init() async {
    // Check and reset if 8 hours have passed since completion
    await _storageService.checkAndResetAfter8Hours();
  }
}





