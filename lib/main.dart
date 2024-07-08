import 'package:domestik/pages/auth/login.dart';
import 'package:domestik/pages/homePage.dart';
import 'package:domestik/pages/infoPage.dart';
import 'package:domestik/pages/loadingPage.dart';
import 'package:domestik/pages/userPage.dart';
import 'package:domestik/theme/dark_theme.dart';
import 'package:domestik/theme/light_theme.dart';
import 'package:domestik/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DomestiK',
      theme: Provider.of<ThemeProvider>(context).themeData,
      // darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: LoadingPage(),
    );
  }
}
