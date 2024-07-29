
import 'package:flutter/material.dart';
import '../constant.dart';
import '../models/api_response.dart';
import '../models/historique.dart';
import '../services/historique_service.dart';

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

  Future confirm(int foyerId) async {

    if (loadingMap[foyerId] == true) {
      return;
    }
    loadingMap[foyerId] = true;
    notifyListeners();

    ApiResponse response = await confirmService(foyerId);

    if (response.error == null) {
      stateMap[foyerId] = true;
    } else if (response.error == unauthorized) {
      // Handle unauthorized error
    } else {
      // Handle other errors
    }

    loadingMap[foyerId] = false;
    notifyListeners();
  }
}
