import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/api_response.dart';
import '../../services/user_service.dart';
import '../allUser.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  List<dynamic> allUser = [];
  Set<int> selectedUserIds = {};
  bool isLoading = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  int? editingUserId;
  TextEditingController _nameController = TextEditingController();
  bool isAdminSelected = false; // Ajout de l'état pour suivre l'administrateur sélectionné

  @override
  void initState() {
    _getAllUser();
    super.initState();
  }

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

  void _removeUser(int index, int userId) {
    final user = allUser.removeAt(index);
    removeUser(userId);
    _listKey.currentState?.removeItem(
      index,
          (context, animation) => _buildItem(user, animation,0),
      duration: Duration(milliseconds: 300),
    );
  }

  void _activeOrDisable(int userId) {
    setState(() {
      isLoading = true;
      final user = allUser.firstWhere((u) => u["id"] == userId);
      user["active"] = user["active"] == 1 ? 0 : 1;
    });
    activeOrDisable(userId).then((value) => setState(() {
      isLoading = false;
    }));
  }

  void _startEditing(int userId, String initialName) {
    setState(() {
      editingUserId = userId;
      _nameController.text = initialName;
    });
  }

  void _stopEditing() {
    setState(() {
      editingUserId = null;
    });
  }

  void _saveChanges(int userId) {
    setState(() {
      isLoading = true;

      final user = allUser.firstWhere((u) => u["id"] == userId);
      user["name"] = _nameController.text;
    });

    print("Résultat choisi : ${isAdminSelected ? 'Admin' : 'User'}");
    changeAdmin(userId).then((value) => setState(() {
      isLoading = false;
      _stopEditing();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: AnimatedList(
            key: _listKey,
            initialItemCount: allUser.length,
            itemBuilder: (BuildContext context, int index, Animation<double> animation) {
              final user = allUser[index];
              return _buildItem(user, animation, index);
            },
          ),
        ));
  }

  Widget _buildItem(dynamic user, Animation<double> animation, int index) {
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
            if (user["active"] != 1)
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
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade400,
                    child: Text(
                      user["name"].substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
                  trailing: editingUserId == user["id"]
                      ? InkWell(
                    onTap: () {
                      _saveChanges(user["id"]);
                    },
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Container(
                      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color(0xff21304f),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        'Enregistrer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                      : PopupMenuButton<String>(
                    onSelected: (String value) {
                      print("Option sélectionnée : $value");
                      if (value == "Désactiver") {
                        _activeOrDisable(user["id"]);
                        print(user["id"]);
                      } else if (value == "Modifier") {
                        _startEditing(user["id"], user["name"]);
                      } else if (value == "Supprimer") {
                        _removeUser(index, user["id"]);
                        print(user["id"]);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'Modifier',
                          child: Container(
                            width: 100,
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
                            width: 100,
                            child: Row(
                              children: [
                                Icon(Icons.block, color: Colors.black54),
                                SizedBox(width: 8),
                                Text(
                                  user["active"] != 1 ? 'Réactiver' : 'Désactiver',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Supprimer',
                          child: Container(
                            width: 100,
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
                editingUserId == user["id"]
                    ? Container(
                  padding: EdgeInsets.only(bottom: 10, left: 70),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: isAdminSelected ? Colors.lightGreen.shade400 : Colors.lightGreen,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isAdminSelected = false;
                            });
                          },
                          child: Row(
                            children: [
                              if (!isAdminSelected)
                                Container(
                                  margin: EdgeInsets.only(right: 7),
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isAdminSelected ? Colors.lightGreen.shade400 : Colors.lightGreen.shade400,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    size: 11,
                                    color: Colors.white,
                                  ),
                                ),
                              Text(
                                "User",
                                style: TextStyle(
                                  color: isAdminSelected ? Colors.white : Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: isAdminSelected ? Colors.deepOrange : Colors.deepOrange.shade400,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isAdminSelected = true;
                            });
                          },
                          child: Row(
                            children: [
                              if (isAdminSelected)
                                Container(
                                  margin: EdgeInsets.only(right: 7),
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isAdminSelected ? Colors.deepOrange.shade400 : Colors.deepOrange.shade400,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    size: 11,
                                    color: Colors.white,
                                  ),
                                ),
                              Text(
                                "Admin",
                                style: TextStyle(
                                  color: isAdminSelected ? Colors.black54 : Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
