import 'dart:convert';
import 'package:domestik/models/groupe.dart';
import 'package:flutter/material.dart';
import '../../models/api_response.dart';
import '../../services/user_service.dart';

class UserProvider with ChangeNotifier {
  List<dynamic> allUser = [];
  List<dynamic> allGroupe = [];
  bool isLoading = false;
  String _profil = "assets/images/logo.png";
  String _accountType = "";
  int? _userId;
  int? _foyerId;

  String get profil => _profil;
  String get accountType => _accountType;
  int? get userId => _userId;

  int? get foyerId => _foyerId;

  UserProvider(){
    getUserDetail();
    getUserProfil();
    getUserAccountType();
  }

  Future<void> getAllUser() async {
    isLoading = true;

    ApiResponse response = await getMembre();
    if (response.data != null) {
      final data = jsonEncode(response.data);
      final users = jsonDecode(data)["users"];
      allUser.clear();
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
  void createGroupe(List<dynamic> users, String groupeName) {
    Set<int> selectedUserIds = users.map((user) => user["id"] as int).toSet();
    allUser.removeWhere((user) => selectedUserIds.contains(user["id"]));

    List<String> images = users
        .where((user) => user["profil"] != null)
        .map((user) => user["profil"] as String)
        .toList();

    Groupe groupe = Groupe(
        name: groupeName,
        image: images,
        nbrMembres: users.length > 0 ? users.length : 0,
    );
    allGroupe.add(groupe);
    allGroupe = allGroupe.reversed.toList();
    notifyListeners();
  }

  //Mise à jour du profil
  void updateUser(String path) async{
    await updateUserService(path);
    _profil = path;
    notifyListeners();

  }
  Future<void> getUserDetail() async {
    print("sans interet");

    ApiResponse response = await getUserDetailSercice();
    final data = jsonEncode(response.data);
    final id = jsonDecode(data)["user"]["id"];
    final foyerId = jsonDecode(data)["user"]["foyer_id"];
    _userId = id;
    _foyerId = foyerId;

    notifyListeners();
  }

  //Obtenir le profil du compte utilisateur
  Future<void> getUserProfil() async {
    ApiResponse response = await getUserDetailSercice();
    if (response.data != null) {
      final data = jsonEncode(response.data);
      _profil = (jsonDecode(data)["user"]["profil"] != null) ? jsonDecode(data)["user"]["profil"] : "assets/images/logo.png";
    }
    notifyListeners();

  }
  Future<void> getUserAccountType() async {
    print("recheche2");

    ApiResponse response = await getUserDetailSercice();
    final data = jsonEncode(response.data);
    final type = jsonDecode(data)["user"]["accountType"];
    _accountType = type;
    print("type");
    print(type);
    notifyListeners();
  }


  //Changer l'admin du foyer
  Future<void> changeAdmin(int userId) async{
    print(userId);
    await changeAdminService(userId);
    getUserAccountType();
    notifyListeners();
  }

  void removeUser(int index, int userId) {
    allUser.removeAt(index);
    removeUserService(userId);
    notifyListeners();
  }


  void activeOrDisable(int userId) async {
    notifyListeners();

    await activeOrDisableService(userId).then((value) {

      final user = allUser.firstWhere((u) => u["id"] == userId);
      user["active"] = user["active"] == 1 ? 0 : 1;
    });

    notifyListeners();
  }



  Future<void> reset() async{
    print('Effacer user');
    _profil = "assets/images/logo.png";
    _userId = null;
    notifyListeners();
  }
}
