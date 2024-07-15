import 'dart:convert';

import 'package:domestik/theme/dark_theme.dart';
import 'package:domestik/theme/light_theme.dart';
import 'package:flutter/material.dart';

import '../models/api_response.dart';
import '../services/user_service.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;
  bool _switchValue = false;

  //Pour charger le thème préféré de l'utilisateur durant l'initialisation de l'application
  ThemeProvider() {
    checkUserPrefernce();
  }
  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;

    notifyListeners();
  }
  // getUserMode();

  bool get switchValue => _switchValue;




  void updateSwitchValue(bool newValue) async{

    _switchValue = newValue;
    if (newValue) {
      _themeData = darkTheme;
    } else {
      _themeData = lightTheme;
    }
    await updateUserPreference(!newValue);
    notifyListeners();
  }

  void checkUserPrefernce() async {
    var mode = await getUserMode();
    print("mode");
    print(mode);
    if (mode) {
      _themeData = lightTheme;
      _switchValue = false;
    } else {
      _themeData = darkTheme;
      _switchValue = true;
    }
    notifyListeners();
  }

  Future<void> reset() async{
    print('Effacer Them');
    _themeData = lightTheme;

    notifyListeners();
  }
}
