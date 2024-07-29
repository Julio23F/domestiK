import 'dart:convert';
import 'package:domestik/provider/tache_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/api_response.dart';
import '../../services/user_service.dart';

class AddTache extends StatefulWidget {
  const AddTache({super.key});

  @override
  State<AddTache> createState() => _AddTacheState();
}

class _AddTacheState extends State<AddTache> {
  Set<int> selectedUserIds = {};
  bool isLoading = false;
  String accountType = "user";



  //Obtenir le type de compte
  Future<void> getUserAccountType() async {
    ApiResponse response = await getUserDetailSercice();
    final data = jsonEncode(response.data);
    final type = jsonDecode(data)["user"]["accountType"];
    setState(() {
      accountType = type;
    });
  }

  @override
  void initState() {
    // _getAllTache();
    getUserAccountType();
    Provider.of<TacheProvider>(context, listen: false).getAllTache();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TacheProvider>(
      builder: (context, tacheProvider, child){

        return RefreshIndicator(
          color: Colors.grey,
          backgroundColor: Colors.white,
          onRefresh: () async {
            await tacheProvider.getAllTache();
          },
          child: ListView.builder(
            itemCount: tacheProvider.allTache.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildItem(tacheProvider.allTache[index], tacheProvider);

            },
          ),
        );
      }

    );
  }

  Widget _buildItem(tache, tacheProvider) {
    return Container(
      height: 110,
      // width: (MediaQuery.of(context).size.width / 2) - 20,
      decoration: BoxDecoration(
        color: Color(int.parse(tache["color"])).withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white.withOpacity(0.9)),
                onSelected: (String result) {
                  if(accountType == "admin") {
                    if (result == 'delete') {
                      print("sup");
                      tacheProvider.deleteTache(tache["id"]);
                    }
                  }
                  else{
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Accès Refusé',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: const Text(
                            "Seul l'admin de ce foyer peut accéder à cette section.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Fermer',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.surface.withOpacity(0.5)
                                ),
                              ),
                            ),
                          ],
                        );

                      },
                    );
                  }

                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'delete',
                    height: 35,
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              color: (accountType == "user")?Colors.red:Colors.transparent,
                              width: 2
                          ),
                        ),
                      ),
                      width: 105,
                      child: const Row(
                        children: [
                          Icon(Icons.delete, color: Colors.black54),
                          SizedBox(width: 5),
                          Text('Supprimer', style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                ],
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
              ),
            ],
          ),
          Center(
            child: Text(
              tache["name"],
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
