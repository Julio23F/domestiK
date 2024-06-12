import 'package:domestik/pages/auth/login.dart';
import 'package:domestik/pages/homePage.dart';
import 'package:domestik/pages/infoPage.dart';
import 'package:domestik/pages/userPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: InfoPage(),
    );
  }
}


