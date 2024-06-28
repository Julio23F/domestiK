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
            for(int i=0; i<allTache.length; i++)
              _buildItem(allTache[i])
          ],
        )
      ],
    );
  }

  Widget _buildItem(tache) {
    return Container(
      height: 130,
      width: (MediaQuery.of(context).size.width/2) - 20,
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
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white.withOpacity(0.9),),
                onPressed: () {
                  print('action');
                },
              ),
            ],
          ),
          Center(
              child: Text(
                  tache["name"],
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
              )
          ),
        ],
      ),
    );
  }
}
