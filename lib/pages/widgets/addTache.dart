import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/api_response.dart';
import '../../services/tache_service.dart';
import '../../services/user_service.dart';
import '../allUser.dart';

class AddTache extends StatefulWidget {
  const AddTache({super.key});

  @override
  State<AddTache> createState() => _AddTacheState();
}

class _AddTacheState extends State<AddTache> {
  List<dynamic> allTache = [];
  Set<int> selectedUserIds = {};
  bool isLoading = false;

  Future<void> _getAllTache() async {
    ApiResponse response = await getTache();
    if (response.data != null) {
      final data = jsonEncode(response.data);
      setState(() {
        allTache = jsonDecode(data)["taches"];
      });
    }
  }

  Future<void> _deleteTache(int tacheId) async {
    // Appelez votre service de suppression de tâche ici
    await deleteTache(tacheId);
    setState(() {
      allTache.removeWhere((tache) => tache["id"] == tacheId);
    });
  }

  @override
  void initState() {
    _getAllTache();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Wrap(
          spacing: 8, // Espace horizontal entre les containers
          runSpacing: 8.0,
          children: [
            for (int i = 0; i < allTache.length; i++)
              _buildItem(allTache[i])
          ],
        )
      ],
    );
  }

  Widget _buildItem(tache) {
    return Container(
      height: 130,
      width: (MediaQuery.of(context).size.width / 2) - 20,
      decoration: BoxDecoration(
        color: Color(int.parse(tache["color"])).withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white.withOpacity(0.9)),
                onSelected: (String result) {
                  if (result == 'delete') {
                    _deleteTache(tache["id"]);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'delete',
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                    child: Container(

                      width: 105,
                      child: Row(
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
              style: TextStyle(
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
