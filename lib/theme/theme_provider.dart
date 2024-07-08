import 'package:domestik/theme/dark_theme.dart';
import 'package:domestik/theme/light_theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if(_themeData == lightTheme) {
      _themeData = darkTheme;
    }
    else{
      _themeData = lightTheme;
    }
    notifyListeners();

  }


}