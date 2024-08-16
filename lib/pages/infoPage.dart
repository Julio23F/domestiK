import 'package:domestik/models/api_response.dart';
import 'package:domestik/pages/auth/login.dart';
import 'package:domestik/pages/home.dart';
import 'package:domestik/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/home_provider.dart';
import '../provider/user_provider.dart';
import '../services/foyer_service.dart';
import '../services/myService.dart';
import '../theme/theme_provider.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

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
        title: const Text("Nom du foyer"),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: "Entrer le nom du foyer"),
          controller: foyerController,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Annuler",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.surface
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              _creatFoyer();
            },
            child: Text(
              "Enregistrer",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.surface
              ),
            ),
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
        MaterialPageRoute(builder: (context) => const Home()),
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
    const textColor = Color(0xff192b54);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 35),
            child: Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 50),
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
                  const Text(
                    'Gérer & Organiser',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: textColor,
                      fontSize: 25,
                    ),
                  ),
                  const Text(
                    'Simplifiez Votre Quotidien en Quelques Clics',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Image.asset(
                    "assets/images/logo.png",
                    width: MediaQuery.of(context).size.width * 4 / 7,
                  ),
                  const SizedBox(height: 55),
                  const Text(
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
                      const Text(
                        "Ou attendez qu'on vous ajoute : ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isLoading = true;
                          });
                          loadUserInfo(context);
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        },
                        child: const Text(
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
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Déconnexion'),
                            content: const Text('Voulez-vous réellement vous déconnecter ?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Annuler',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withOpacity(0.5)),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  logout();
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const LoginPage()),
                                        (route) => false,
                                  );
                                  await Provider.of<HistoriqueProvider>(context, listen: false).reset();
                                  await Provider.of<UserProvider>(context, listen: false).reset();
                                  await Provider.of<ThemeProvider>(context, listen: false).reset();
                                },
                                child: Text(
                                  'Confirmer',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withOpacity(0.5)),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(
                        maxWidth: double.infinity,
                        minHeight: 50.0,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Icon(Icons.logout, color: Colors.white, size: 25,)
                    ),
                  ),
                  const SizedBox(width: 10), // Add spacing between buttons
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        openDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        constraints: const BoxConstraints(
                          minHeight: 50.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
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
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
