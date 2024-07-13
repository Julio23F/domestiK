import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/api_response.dart';
import '../services/tache_service.dart';
import '../services/user_service.dart';

class TacheProvider extends ChangeNotifier {
  List<dynamic> _allTache = [];
  bool isLoading = false;
  String _profil = "assets/images/logo.png";

  String get profil => _profil;
  List get allTache => _allTache;

  TacheProvider() {
    getAllTache();
  }

  Future<void> getAllTache() async {
    isLoading = true;
    ApiResponse response = await getTache();
    if (response.data != null) {
      final data = jsonEncode(response.data);
      final tache = jsonDecode(data)["taches"];
      _allTache.clear();
      _allTache.addAll(tache);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTache(int tacheId) async {
    // Appelez votre service de suppression de tâche ici
    await deleteTacheService(tacheId);

    _allTache.removeWhere((tache) => tache["id"] == tacheId);

    notifyListeners();
  }

  Future<void> addTache(BuildContext context, String name, String color) async {
    ApiResponse response = await addTacheService(name, color);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
    else {
      _allTache.insert(0, response.data);
    }

    notifyListeners();
  }

  Future<void> reset() async{
    _profil = "assets/images/logo.png";
    _allTache.clear();

    notifyListeners();
  }
}
