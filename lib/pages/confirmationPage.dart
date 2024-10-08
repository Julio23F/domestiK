import 'dart:convert';

import 'package:domestik/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/api_response.dart';
import '../models/historique.dart';
import '../provider/confirmation_provider.dart';
import '../services/user_service.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({super.key});

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int? _selectedIndex;
  int userId = 0;

  String? getUserNameById(List<dynamic> users, int? id) {
    for (var user in users) {
      if (user['id'] == id) {
        return user['name'];
      }
    }
    return null;
  }

  void getUserId() async {
    ApiResponse response = await getUserDetailSercice();

    if (response.data != null) {
      final data = jsonEncode(response.data);
      setState(() {
        userId = jsonDecode(data)["user"]["id"];
      });
    } else {
      print('Réponse inattendue');
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ConfirmationProvider>(context, listen: false).historiqueToConfirm();

    getUserId();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConfirmationProvider(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Validation",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                print("Ajouter");
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.watch_later_outlined,
                  color: Colors.grey,
                  size: 25,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Consumer<ConfirmationProvider>(
          builder: (context, provider, child) {
            return RefreshIndicator(
              color: Colors.grey,
              backgroundColor: Colors.white,
              onRefresh: () async {
                await provider.loadData();
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: provider.nbrConfirm == 0
                    ? ListView(
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 2/6),
                        height: MediaQuery.of(context).size.height * 3/4,
                        child: const Column(
                          children: [
                            Icon(
                              Icons.warning,
                              size: 60,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: Text(
                                "Aucune confirmation disponible.",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey),
                              ),
                            ),
                          ],
                        )
                    )

                  ],
                )
                    : ListView.builder(
                  itemCount: provider.nbrConfirm,
                  itemBuilder: (context, index) {
                    Historique confirm = provider.listConfirmation![index];
                    bool isConfirmed = provider.stateMap[confirm.id] ?? false;
                    bool isLoading = provider.loadingMap[confirm.id] ?? false;
                    String? userConfirmName = getUserNameById(Provider.of<UserProvider>(context, listen: false).allUser, confirm.userConfimId);
                    return Column(
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: 1.0,
                          curve: Curves.easeIn,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, -0.5),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(
                                  0.5 + index * 0.05,
                                  1.0,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = _selectedIndex == index ? null : index;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 7),
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 15,
                                    left: 20,
                                    right: 15),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.purple.withOpacity(0.1),
                                    width: 0.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 0.2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          confirm.user!.name.toString(),
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                        Text(
                                          confirm.user!.email.toString(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(right: 7),
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: (isConfirmed || confirm.state != null)
                                                      ? const Color(0xff8463BE)
                                                      : Colors.grey.shade400,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.check,
                                                  size: 11,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Wrap(
                                                children: List.generate(
                                                  confirm.taches!.length,
                                                      (i) {
                                                    return Container(
                                                      margin: const EdgeInsets.only(right: 7),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context).colorScheme.secondary,
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(
                                                          vertical: 4, horizontal: 10),
                                                      child: Text(
                                                        confirm.taches![i].name.toString(),
                                                        style: Theme.of(context).textTheme.bodySmall,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          height: _selectedIndex == index && userConfirmName != null ? 60 : 0,
                                          curve: Curves.easeInOut,
                                          child: Container(
                                            margin: const EdgeInsets.only(top: 20),
                                            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(7),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Confirmé par :',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                                                  ),
                                                ),
                                                Text(
                                                  ' $userConfirmName',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme.of(context).colorScheme.surface,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    (isConfirmed || confirm.state != null)
                                        ? Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets.only(right: 25),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xff8463BE),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.9),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    )
                                        : userId != confirm.user!.id
                                        ?InkWell(
                                          onTap: () {
                                            provider.confirm(confirm.id);
                                          },
                                          child: isLoading
                                              ? const CircularProgressIndicator()
                                              : Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 7, horizontal: 10),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff21304f),
                                              borderRadius: BorderRadius.circular(7),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.3),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: const Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: const Text(
                                              "Valider",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                        :const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    );
                  },
                  shrinkWrap: true,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
