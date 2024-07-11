import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/api_response.dart';
import '../services/historique_service.dart';
import '../services/user_service.dart';

class HistoriqueProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isCheck = false;

  String _userName = "";
  String _foyerName = "";
  int _userId = 0;

  bool get isLoading => _isLoading;
  bool get isCheck => _isCheck;

  String get userName => _userName;
  String get foyerName => _foyerName;
  int get userId => _userId;

  HistoriqueProvider(){
    getUserDetail();
  }


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

  void getUserDetail() async {
    ApiResponse response = await getUserDetailSercice();
    if (response.data != null) {
      final data = jsonEncode(response.data);
      _userName = jsonDecode(data)["user"]["name"];
      _foyerName = jsonDecode(data)["user"]["foyer"]["name"];
      _userId = jsonDecode(data)["user"]["id"];
    }
    notifyListeners();
  }

  void reset() {
    _isCheck = false;
    _isLoading = false;
    _userName = "";
    _foyerName = "";
    _userId = 0;
    print("effacer");
    notifyListeners();
  }
}
