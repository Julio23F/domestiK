import 'package:domestik/theme/dark_theme.dart';
import 'package:domestik/theme/light_theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;
  bool _switchValue = false;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  bool get switchValue => _switchValue;

  void updateSwitchValue(bool newValue) {
    _switchValue = newValue;
    if (newValue) {
      _themeData = darkTheme;
    } else {
      _themeData = lightTheme;
    }
    notifyListeners();
  }

  // void toggleTheme() {
  //   _switchValue = !_switchValue;
  //   if (_switchValue) {
  //     _themeData = darkTheme;
  //   } else {
  //     _themeData = lightTheme;
  //   }
  //   notifyListeners();
  // }
}
