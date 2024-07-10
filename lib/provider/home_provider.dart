import 'package:flutter/material.dart';

import '../services/historique_service.dart';

class HistoriqueProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isCheck = false;

  bool get isLoading => _isLoading;
  bool get isCheck => _isCheck;

  Future<void> addHistorique(List tacheIds) async {
    _isLoading = true;
    print(tacheIds);
    await addHistoriqueService(tacheIds);
    notifyListeners();

    await Future.delayed(Duration(seconds: 2)); // Placeholder for async operation

    _isLoading = false;
    _isCheck = true;
    notifyListeners();
  }
}
