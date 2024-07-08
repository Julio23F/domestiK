import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Color(0xffFeFeFe),
        //Primary Color(0xfff9f9f9)
      primary: Color(0xfffcfcfc)!,
      secondary: Colors.grey.shade100,
      tertiary: Colors.grey.shade400,
      surface: Color(0xff0c3141)
        // Colors.grey.shade100
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(color: Color(0xff192b54)),
      bodySmall: TextStyle(
        color: Color(0xff192b54),
        fontSize: 8,
      ),
      bodyMedium: TextStyle(
        color: Colors.black54
      )
    )
);
