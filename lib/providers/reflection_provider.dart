import 'package:flutter/foundation.dart';
import 'package:flutter_winddown/services/storage_service.dart';

class ReflectionProvider extends ChangeNotifier {
  final StorageService _storageService;
  
  List<String> _calmItems = [];
  List<bool> _checkedStates = [];
  bool _trustMode = false;
  
  ReflectionProvider(this._storageService) {
    _loadData();
  }
  
  List<String> get calmItems => _calmItems;
  List<bool> get checkedStates => _checkedStates;
  bool get trustMode => _trustMode;
  
  bool isItemChecked(int index) {
    if (index >= 0 && index < _checkedStates.length) {
      return _checkedStates[index];
    }
    return false;
  }
  
  bool get allItemsCompleted {
    if (_calmItems.isEmpty) return false;
    return _checkedStates.every((checked) => checked);
  }
  
  Future<void> _loadData() async {
    // Check and reset if 8 hours have passed
    await _storageService.checkAndResetAfter8Hours();
    
    _calmItems = _storageService.getCalmItems();
    _checkedStates = _storageService.getCalmItemsCheckedState();
    
    // Ensure checked states match calm items length
    if (_checkedStates.length != _calmItems.length) {
      _checkedStates = List<bool>.filled(_calmItems.length, false);
      await _storageService.setCalmItemsCheckedState(_checkedStates);
    }
    
    _trustMode = _storageService.getTrustMode();
    notifyListeners();
  }
  
  Future<void> toggleItemChecked(int index) async {
    if (index >= 0 && index < _checkedStates.length) {
      _checkedStates[index] = !_checkedStates[index];
      await _storageService.setCalmItemsCheckedState(_checkedStates);
      notifyListeners();
    }
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
    _checkedStates.add(false);
    await _storageService.setCalmItems(_calmItems);
    await _storageService.setCalmItemsCheckedState(_checkedStates);
    notifyListeners();
  }
  
  Future<void> removeCalmItem(int index) async {
    if (index >= 0 && index < _calmItems.length) {
      _calmItems.removeAt(index);
      if (index < _checkedStates.length) {
        _checkedStates.removeAt(index);
      }
      await _storageService.setCalmItems(_calmItems);
      await _storageService.setCalmItemsCheckedState(_checkedStates);
      notifyListeners();
    }
  }
  
  Future<void> resetCheckedStates() async {
    _checkedStates = List<bool>.filled(_calmItems.length, false);
    await _storageService.setCalmItemsCheckedState(_checkedStates);
    notifyListeners();
  }
}





