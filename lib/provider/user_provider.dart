import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/api_response.dart';
import '../../services/user_service.dart';

class UserProvider with ChangeNotifier {
  List<dynamic> allUser = [];
  bool isLoading = false;

  Future<void> getAllUser() async {
    isLoading = true;

    ApiResponse response = await getMembre();
    if (response.data != null) {
      final data = jsonEncode(response.data);
      final users = jsonDecode(data)["users"];
      allUser.clear(); // Clear the existing list before adding new users
      allUser.addAll(users);
    }

    isLoading = false;
    notifyListeners();
  }

  //Ajouter des utilisateurs à partir de AllUser Page
  void addUser(List<dynamic> userIds) {
    print(userIds);
    allUser.addAll(userIds);
    notifyListeners();
  }


  void removeUser(int index, int userId) {
    allUser.removeAt(index);
    removeUserService(userId);
    notifyListeners();
  }

  void activeOrDisable(int userId) async {
    isLoading = true;
    notifyListeners();

    final user = allUser.firstWhere((u) => u["id"] == userId);
    user["active"] = user["active"] == 1 ? 0 : 1;

    await activeOrDisableService(userId);

    isLoading = false;
    notifyListeners();
  }
}