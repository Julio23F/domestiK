import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: const Color(0xfffcfcfc),
      secondary: Colors.grey.shade100,
      tertiary: Colors.grey.shade400,
      surface: const Color(0xff0c3141)
        // Colors.grey.shade100
    ),

    textTheme: const TextTheme(
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
