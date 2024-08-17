import 'dart:convert';
import 'package:domestik/models/groupe.dart';
import 'package:flutter/material.dart';
import '../../models/api_response.dart';
import '../../services/user_service.dart';

class UserProvider with ChangeNotifier {
  List<dynamic> allUser = [];
  List<dynamic> allUserInGroupe = [];
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

    ApiResponse response = await getMembre(null);

    if (response.data != null) {
      final data = jsonEncode(response.data);
      final users = jsonDecode(data)["users"];
      allUser.clear();
      allUser.addAll(users);
    }

    isLoading = false;
    notifyListeners();
  }
  Future<void> getAllUserInGroupe(groupeId) async {
    isLoading = true;

    ApiResponse response = await getMembre(groupeId);

    if (response.data != null) {
      final data = jsonEncode(response.data);
      final users = jsonDecode(data)["users"];
      allUserInGroupe.clear();
      allUserInGroupe.addAll(users);
    }

    isLoading = false;
    notifyListeners();
  }


  //Ajouter des utilisateurs à partir de AllUser Page
  void addUser(List<dynamic> userIds) {
    allUser.addAll(userIds);
    notifyListeners();
  }
  Future<void> createGroupe(List<dynamic> users, String groupeName) async{

    List<String> images = users
        .where((user) => user["profil"] != null)
        .map((user) => user["profil"] as String)
        .toList();

    Set<int> selectedUserIds = users.map((user) => user["id"] as int).toSet();
    allUser.removeWhere((user) => selectedUserIds.contains(user["id"]));

    ApiResponse response = await createGroupeService(groupeName, selectedUserIds.toList());
    if (response.data != null) {
      final data = jsonEncode(response.data);
      final groupeData = jsonDecode(data);

      Groupe groupe = Groupe(
        id: groupeData['id'],
        name: groupeData['name'] ?? 'Nom indisponible',
        image: List<String>.from(groupeData['profil'] ?? []),
        nbrMembres: groupeData['nbrMembres'] ?? 0,
      );
      allGroupe.insert(0, groupe);
    }

    notifyListeners();
  }

  Future<void> getListGroupe() async {
    try {
      ApiResponse response = await getListGroupeService();
      if (response.data != null) {
        final data = jsonEncode(response.data);
        final List<dynamic> groupesData = jsonDecode(data);

        allGroupe.clear();
        for (var groupeData in groupesData) {
          Groupe groupe = Groupe(
            id: groupeData['id'],
            name: groupeData['name'] ?? 'Nom indisponible',
            image: List<String>.from(groupeData['profil'] ?? []),
            nbrMembres: groupeData['nbrMembres'] ?? 0,
          );
          allGroupe.add(groupe);
        }

        allGroupe = allGroupe.reversed.toList();
      }
    } catch (e) {
      print("Erreur lors de la récupération des groupes : $e");
    }
  }



  void updateUser(String path) async{
    await updateUserService(path);
    _profil = path;
    notifyListeners();

  }
  Future<void> getUserDetail() async {
    ApiResponse response = await getUserDetailSercice();
    final data = jsonEncode(response.data);
    if(response.error != null){
      final id = jsonDecode(data)["user"]["id"];
      final foyerId = jsonDecode(data)["user"]["foyer_id"];
      _userId = id;
      _foyerId = foyerId;
    }
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
    ApiResponse response = await getUserDetailSercice();
    final data = jsonEncode(response.data);
    final type = jsonDecode(data)["user"]["accountType"];
    _accountType = type;
    notifyListeners();
  }


  //Changer l'admin du foyer
  Future<void> changeAdmin(int userId) async{
    await changeAdminService(userId);
    getUserAccountType();
    notifyListeners();
  }

  void removeUser(int index, int userId, String type) async{
    await removeUserService(userId);
    if(type == "groupe"){
      allUserInGroupe.removeAt(index);
    }
    else{
      allUser.removeAt(index);
    }
    notifyListeners();
  }

  void removeFromGroupe(int index, int userId) async{
    await removeFromGroupeService(userId);
    final currentUser = allUserInGroupe[index];
    allUser.add(currentUser);
    allUserInGroupe.removeAt(index);
    notifyListeners();
  }
  void deleteGroupe(int groupeId) async {
    await deleteGroupeService(groupeId);
    print(allGroupe.toList());

    allGroupe.removeWhere((groupe) => groupe.id == groupeId);

    notifyListeners();
  }


  void activeOrDisable(int userId, String type) async {
    notifyListeners();
    print("active or");
    print(userId);
    await activeOrDisableService(userId).then((value) {
      final user;
      if(type == "groupe"){
        user = allUserInGroupe.firstWhere((u) => u["id"] == userId);
      }
      else{
        user = allUser.firstWhere((u) => u["id"] == userId);
      }

      user["active"] = user["active"] == 1 ? 0 : 1;
    });

    notifyListeners();
  }



  Future<void> reset() async{
    _profil = "assets/images/logo.png";
    _userId = null;
    notifyListeners();
  }
}
