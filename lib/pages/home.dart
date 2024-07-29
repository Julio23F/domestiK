import 'package:domestik/pages/addPage.dart';
import 'package:domestik/pages/confirmationPage.dart';
import 'package:domestik/pages/homePage.dart';
import 'package:domestik/pages/userPage.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  void setCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: [
            HomePage(setCurrentIndex: setCurrentIndex),
            const ConfirmationPage(),
            const AddPage(),
            const Userpage(),
          ][currentIndex],
        ),
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) => setCurrentIndex(index),
          selectedItemColor: const Color(0xff8463BE),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time_outlined),
              label: 'Validation',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Ajout',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Paramètre',
            ),
          ],
        ),
      ],
    );
  }
}

