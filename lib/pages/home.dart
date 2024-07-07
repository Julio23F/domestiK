import 'package:domestik/pages/addPage.dart';
import 'package:domestik/pages/auth/historiquePage.dart';
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
  setCurrentIndex(int index) {
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
            HomePage(),
            ConfirmationPage(),
            AddPage(),
            Userpage(),
          ][currentIndex],
        ),
        BottomNavigationBar(
          //C'est pour éviter que les autres éléments du BottomNavigationBarItem ne s'affiche pas quand il y a 4 item
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) => setCurrentIndex(index),
          selectedItemColor: Color(0xff8463BE),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time_outlined),
              label: 'Conf',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add',
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
