import 'package:domestik/provider/tache_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:domestik/provider/home_provider.dart';
import 'package:domestik/provider/user_provider.dart';
import 'package:domestik/theme/theme_provider.dart';
import 'package:domestik/theme/dark_theme.dart';
import 'package:domestik/theme/light_theme.dart';
import 'package:domestik/pages/loadingPage.dart';
import 'package:domestik/pages/homePage.dart';

void main() async {
  // Initialize locale data
  await initializeDateFormatting('fr');

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (BuildContext context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => HistoriqueProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => TacheProvider(),
        ),

      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DomestiK',
      
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      home: LoadingPage(),
    );
  }
}
