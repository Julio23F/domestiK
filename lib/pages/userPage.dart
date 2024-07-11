import 'package:domestik/pages/widgets/infoApp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../provider/home_provider.dart';
import '../services/user_service.dart';
import '../theme/theme_provider.dart';
import 'auth/login.dart';

class Userpage extends StatefulWidget {
  const Userpage({super.key});

  @override
  State<Userpage> createState() => _UserpageState();
}

class _UserpageState extends State<Userpage> {
  bool _switchValue = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Paramètre",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Image.asset(
                    "assets/images/logo.png",
                    width: 90,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "FARALAHY Julio",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  Text(
                    "juliofaralahy23@gmail.com",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.all(12)),
                        backgroundColor: MaterialStatePropertyAll(Color(0xff8463BE)),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Modifier",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(bottom: 7),
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 18),
                    child: Icon(
                      Icons.notifications_active_outlined,
                      size: 25,
                      color: Color(0xff8463BE),
                    ),
                  ),
                  Text(
                    "Notification",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Container(
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: InfoApp(),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 7),
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 18),
                      child: Icon(
                        Icons.info_outline,
                        size: 25,
                        color: Color(0xff8463BE),
                      ),
                    ),
                    Text(
                      "À propos",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 7),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 18),
                    child: Icon(
                      Icons.wb_sunny_outlined,
                      size: 25,
                      color: Color(0xff8463BE),
                    ),
                  ),
                  Text(
                    "Dark Mode",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Switch(
                    value: Provider.of<ThemeProvider>(context, listen: false).switchValue,
                    onChanged: (newValue) {
                      Provider.of<ThemeProvider>(context, listen: false).updateSwitchValue(newValue);
                    },
                    activeColor: Theme.of(context).colorScheme.secondary,
                    inactiveTrackColor: Colors.white.withOpacity(0.5),
                    inactiveThumbColor: Color(0xff8463BE),
                  )

                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Déconnexion'),
                      content: Text('Voulez-vous réellement vous déconnecter ?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                              'Annuler',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.surface.withOpacity(0.5)
                              ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Provider.of<HistoriqueProvider>(context,listen: false).reset();

                            logout();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => LoginPage()),
                                  (route) => false,
                            );
                          },
                          child: Text(
                              'Confirmer',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface.withOpacity(0.5)
                              ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 7),
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 18),
                      child: Icon(
                        Icons.logout_outlined,
                        size: 25,
                        color: Color(0xff8463BE),
                      ),
                    ),
                    Text(
                      "Déconnexion",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
