import 'package:domestik/theme/dark_theme.dart';
import 'package:domestik/theme/light_theme.dart';
import 'package:flutter/material.dart';

import '../services/user_service.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = darkTheme;  // Par défaut thème sombre
  bool _switchValue = true;           // Switch activé = thème sombre

  // Pour charger le thème préféré de l'utilisateur durant l'initialisation de l'application
  ThemeProvider() {
    checkUserPrefernce();
  }

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  bool get switchValue => _switchValue;

  void updateSwitchValue(bool newValue) async {
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
    if (mode == null) {
      // Si pas de préférence, mettre thème sombre par défaut
      _themeData = darkTheme;
      _switchValue = true;
    } else if (mode) {
      _themeData = lightTheme;
      _switchValue = false;
    } else {
      _themeData = darkTheme;
      _switchValue = true;
    }
    notifyListeners();
  }

  Future<void> reset() async {
    _themeData = darkTheme; // reset vers thème sombre
    _switchValue = true;
    notifyListeners();
  }
}
