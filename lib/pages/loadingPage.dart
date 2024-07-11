import 'dart:convert';

import 'package:domestik/pages/auth/login.dart';
import 'package:domestik/pages/home.dart';
import 'package:domestik/pages/infoPage.dart';
import 'package:domestik/provider/home_provider.dart';
import 'package:domestik/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import '../services/myService.dart';
import '../services/user_service.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  @override
  void initState() {
    loadUserInfo(context);
    // Récupérer le mode choisi par l'utilsateur
    Provider.of<ThemeProvider>(context,listen: false).checkUserPrefernce();
    Provider.of<HistoriqueProvider>(context,listen: false).getUserDetail();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png", width: 90,),
            SizedBox(height: 10,),
            SpinKitThreeBounce(
              color: Color(0xff8463BE),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
