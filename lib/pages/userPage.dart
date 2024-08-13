
import 'package:domestik/pages/widgets/imageProfil.dart';
import 'package:domestik/pages/widgets/infoApp.dart';
import 'package:domestik/provider/user_provider.dart';
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
  final bool _switchValue = false;
  String? _selectedImage;

  List<String> listImage = [
    "assets/images/profils/ai-generated-8361907_1280.jpg",
    "assets/images/profils/bald-eagle-550804_640.jpg",
    "assets/images/profils/bird-4078_1280.jpg",
    "assets/images/profils/horse-5625922_1280.jpg",
    "assets/images/profils/rabbit-6485072_1280.jpg",
    "assets/images/profils/rhodesian-ridgeback-2727035_1280.jpg",
    "assets/images/profils/snowman-2995146_1280.png",
    "assets/images/profils/banana-2449019_1280.jpg",
    "assets/images/profils/drop-5269146_1280.jpg",
    "assets/images/profils/fire-2777580_1280.jpg",
    "assets/images/profils/illistration-7236397_1280.jpg",
    "assets/images/profils/thunder-953118_1280.jpg",
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getUserProfil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Paramètre",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const ImageProfil(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 2),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff8463BE),
                          width: 2.0,
                        ),
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                          return ClipOval(
                            child: Image.asset(
                              (userProvider.profil != null) ? userProvider.profil : "asstets/images/logo.png",
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    Provider.of<HistoriqueProvider>(context).userName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  Text(
                    Provider.of<HistoriqueProvider>(context).userEmail,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.all(12)),
                        backgroundColor: WidgetStatePropertyAll(Color(0xff8463BE)),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String? localSelectedImage = _selectedImage;
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: const Text('Choisir un profil'),
                                  content: Wrap(
                                    spacing: 10.0,
                                    runSpacing: 12.0,
                                    children: listImage.map((image) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            localSelectedImage = image;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 2),
                                          decoration: BoxDecoration(
                                            border: localSelectedImage == image
                                                ? Border.all(
                                              color: Colors.red,
                                              width: 2.0,
                                            )
                                                : Border.all(
                                              color: Colors.transparent,
                                              width: 2.0,
                                            ),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface
                                                .withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: ClipOval(
                                            child: Image.asset(
                                              image,
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
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
                                      onPressed: () {
                                        setState(() {
                                          _selectedImage = localSelectedImage;
                                        });
                                        Provider.of<UserProvider>(context, listen: false).updateUser(_selectedImage!);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Enregistrer',
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
                        ).then((selectedIcon) {
                          if (selectedIcon != null) {
                            print('Profil sélectionné : $selectedIcon');
                          }
                        });
                      },
                      child: const Text(
                        "Modifier profil",
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
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(bottom: 7),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 18),
                    child: const Icon(
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
                  const Spacer(),
                  Container(
                    child: const Icon(
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
                    child: const InfoApp(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 7),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 18),
                      child: const Icon(
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
                    const Spacer(),
                    Container(
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 7),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 18),
                    child: const Icon(
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
                  const Spacer(),
                  Switch(
                    value: Provider.of<ThemeProvider>(context, listen: false)
                        .switchValue,
                    onChanged: (newValue) {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .updateSwitchValue(newValue);
                    },
                    activeColor: Theme.of(context).colorScheme.secondary,
                    inactiveTrackColor: Colors.white.withOpacity(0.5),
                    inactiveThumbColor: const Color(0xff8463BE),
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
                          onPressed: () async{

                            logout();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                                  (route) => false,
                            );
                            // await context.read<HistoriqueProvider>().reset();
                            // await context.read<UserProvider>().reset();
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
                margin: const EdgeInsets.only(bottom: 7),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 18),
                      child: const Icon(
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
                    const Spacer(),
                    Container(
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Other widgets remain unchanged
          ],
        ),
      ),
    );
  }
}
