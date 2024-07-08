import 'package:flutter/material.dart';


ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,

    colorScheme: ColorScheme.dark(
        background: Color(0xff212127),
        //Primary Color(0xfff9f9f9)
        primary: Color(0xff28282e)!,
        secondary: Colors.grey[800]!,
        tertiary: Colors.grey.shade400,
        surface: Colors.white
      // Colors.grey.shade100
    ),

    textTheme: TextTheme(
        displayLarge: TextStyle(color: Color(0xff192b54)),
        bodySmall: TextStyle(
          color: Colors.grey[100]!,
          fontSize: 8,
        ),
        bodyMedium: TextStyle(
            color: Colors.white
        )
    )
);