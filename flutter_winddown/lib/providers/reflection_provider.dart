import 'package:flutter/foundation.dart';
import 'package:winddown/services/storage_service.dart';

class ReflectionProvider extends ChangeNotifier {
  final StorageService _storageService;
  
  List<String> _calmItems = [];
  bool _trustMode = false;
  
  ReflectionProvider(this._storageService) {
    _loadData();
  }
  
  List<String> get calmItems => _calmItems;
  bool get trustMode => _trustMode;
  
  Future<void> _loadData() async {
    _calmItems = _storageService.getCalmItems();
    _trustMode = _storageService.getTrustMode();
    notifyListeners();
  }
  
  Future<void> updateCalmItem(int index, String newText) async {
    if (index >= 0 && index < _calmItems.length) {
      _calmItems[index] = newText;
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




