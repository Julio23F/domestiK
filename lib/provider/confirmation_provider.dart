import 'dart:convert';

import 'package:flutter/material.dart';
import '../constant.dart';
import '../models/api_response.dart';
import '../models/historique.dart';
import '../services/historique_service.dart';
import '../services/user_service.dart';
import '../services/tache_service.dart';

class ConfirmationProvider with ChangeNotifier {
  bool isLoading = true;
  int nbrConfirm=0;
  List<Historique>? listConfirmation;
  Map<int, bool> stateMap = {};
  Map<int, bool> loadingMap = {};

  ConfirmationProvider() {
    historiqueToConfirm();
  }

  Future<void> loadData() async {
    try {
      await historiqueToConfirm();
    } catch (e) {
      print(e);
    }
    notifyListeners();

  }

  Future<void> historiqueToConfirm() async {
    ApiResponse response = await historiqueToConfirmService();

    if (response.error == null) {
      nbrConfirm = (response.data as List).length;
      listConfirmation = response.data as List<Historique>;
    } else if (response.error == unauthorized) {
      // Handle unauthorized error
    } else {
      // Handle other errors
    }
    isLoading = false;
    notifyListeners();
  }

  Future confirm(int foyer_id) async {

    if (loadingMap[foyer_id] == true) {
      return;
    }
    loadingMap[foyer_id] = true;
    notifyListeners();

    ApiResponse response = await confirmService(foyer_id);

    if (response.error == null) {
      stateMap[foyer_id] = true;
    } else if (response.error == unauthorized) {
      // Handle unauthorized error
    } else {
      // Handle other errors
    }

    loadingMap[foyer_id] = false;
    notifyListeners();
  }
}
