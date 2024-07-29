import 'package:domestik/provider/confirmation_provider.dart';
import 'package:domestik/provider/tache_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:domestik/provider/home_provider.dart';
import 'package:domestik/provider/user_provider.dart';
import 'package:domestik/theme/theme_provider.dart';
import 'package:domestik/pages/loadingPage.dart';

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
          create: (BuildContext context) => ConfirmationProvider() ,
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => TacheProvider(),
        ),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DomestiK',

      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      home: const LoadingPage(),
    );
  }
}
