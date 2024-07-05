import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/api_response.dart';
import '../../services/user_service.dart';
import '../allUser.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  List<dynamic> allUser = [];
  Set<int> selectedUserIds = {};
  bool isLoading = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  Future<void> _getAllUser() async {
    ApiResponse response = await getMembre();
    if (response.data != null) {
      final data = jsonEncode(response.data);
      final users = jsonDecode(data)["users"];
      for (var user in users) {
        _addUser(user);
      }
    }
  }

  void _addUser(dynamic user) {
    final int index = allUser.length;
    allUser.add(user);
    _listKey.currentState?.insertItem(index);
  }

  @override
  void initState() {
    _getAllUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: AnimatedList(
        key: _listKey,
        initialItemCount: allUser.length,
        itemBuilder: (BuildContext context, int index, Animation<double> animation) {
          final user = allUser[index];
          return _buildItem(user, animation);
        },
      ),
    );
  }

  Widget _buildItem(dynamic user, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.vertical,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.purple.withOpacity(0.1),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0.5,
              blurRadius: 7,
              offset: Offset(0, 2),
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Stack(
          children: [
            user["active"]!=1?
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff8463BE),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
            )
            :SizedBox(),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade400,
                child: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                ),
              ),
              title: Text(
                '${user["name"]}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                '${user["email"]}',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (String value) {
                  print("Option sélectionnée : $value");
                  if (value == "Désactiver") {
                    activeOrDisable(user["id"]);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'Modifier',
                      child: Container(
                        width: 100, // Définir la largeur ici
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.black54),
                            SizedBox(width: 8),
                            Text('Modifier', style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Désactiver',
                      child: Container(
                        width: 100, // Définir la largeur ici
                        child: Row(
                          children: [
                            Icon(Icons.block, color: Colors.black54),
                            SizedBox(width: 8),
                            Text(
                                user["active"]!=1?'Réactiver':'Désactiver',
                                style: TextStyle(color: Colors.black54)
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Supprimer',
                      child: Container(
                        width: 100, // Définir la largeur ici
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.black54),
                            SizedBox(width: 8),
                            Text('Supprimer', style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),

    );
  }
}
