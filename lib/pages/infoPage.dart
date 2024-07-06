import 'package:domestik/models/api_response.dart';
import 'package:domestik/pages/auth/login.dart';
import 'package:domestik/pages/home.dart';
import 'package:domestik/services/user_service.dart';
import 'package:flutter/material.dart';

import '../services/foyer_service.dart';
import '../services/myService.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final foyerController = TextEditingController();
  bool _isLoading = false;

  Future<void> openDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Nom du foyer"),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: "Entrer le nom du foyer"),
          controller: foyerController,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              _creatFoyer();
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _creatFoyer() async {
    setState(() {
      _isLoading = true;
    });

    ApiResponse response = await createFoyer(foyerController.text);

    setState(() {
      _isLoading = false;
    });

    if (response.error == null) {
      setState(() {
        foyerController.text = '';
      });
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    foyerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xff192b54);

    return Scaffold(
      //Pour qu'il n'y pas de problème quand le clavier s'affiche
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 35),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 50),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Domesti-',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            'K',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'Gérer & Organiser',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: textColor,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    'Simplifiez Votre Quotidien en Un Clic',
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 50),
                  Image.asset(
                    "assets/images/logo.png",
                    width: MediaQuery.of(context).size.width * 4 / 7,
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Créer un foyer',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Ou attendez qu'on vous ajoute : ",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isLoading = true;
                          });
                          loadUserInfo(context);
                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        },
                        child: Text(
                          "Actualiser",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 45,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  openDialog();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff40719D),
                        Color(0xff40499D),
                        Color(0xff2A3D64),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      openDialog();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                        maxWidth: double.infinity,
                        minHeight: 50.0,
                      ),
                      child: Text(
                        'Créer un foyer',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
