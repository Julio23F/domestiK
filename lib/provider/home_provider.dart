import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/api_response.dart';
import '../services/historique_service.dart';
import '../services/user_service.dart';

class HistoriqueProvider extends ChangeNotifier {

  bool _isCheck = false;

  String _userName = "";
  String _userEmail = "";
  String _foyerName = "";
  String _accountType = "";
  bool _active = true;
  int _userId = 0;


  bool get isCheck => _isCheck;

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get foyerName => _foyerName;
  bool get active => _active;
  String get accountType => _accountType;
  int get userId => _userId;



  Future<void> addHistorique(List tacheIds) async {

    print(tacheIds);
    await addHistoriqueService(tacheIds);
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));


    _isCheck = true;
    notifyListeners();
  }

  void getUserDetail() async {
    ApiResponse response = await getUserDetailSercice();
    if (response.data != null) {
      final data = jsonEncode(response.data);
      _userName = jsonDecode(data)["user"]["name"];
      _userEmail = jsonDecode(data)["user"]["email"];
      _foyerName = jsonDecode(data)["user"]["foyer"]["name"];
      _userId = jsonDecode(data)["user"]["id"];
      _active = jsonDecode(data)["user"]["active"]==1?true:false;
      _accountType = jsonDecode(data)["user"]["accountType"];


    }

    notifyListeners();
  }


  Future<void> reset() async{
    _isCheck = false;
    _userName = "";
    _foyerName = "";
    _userEmail = "";
    _userId = 0;
    print("effacer home");
    notifyListeners();
  }
}
