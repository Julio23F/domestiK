import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart'; // Correct path to UserProvider
import '../../models/api_response.dart'; // Correct path to ApiResponse
import '../../services/user_service.dart';
import '../allUser.dart'; // Adjust as per your structure

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  Set<int> selectedUserIds = {};
  int? editingUserId;
  TextEditingController _nameController = TextEditingController();
  bool isAdminSelected = false;
  String accountType = "user";
  //Obtenir le type de compte
  Future<void> getUserAccountType() async {
    ApiResponse response = await getUserDetailSercice();
    final data = jsonEncode(response.data);
    final type = jsonDecode(data)["user"]["accountType"];
    setState(() {
      accountType = type;
    });
    print(accountType);

  }

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getAllUser();
    getUserAccountType();
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

  void _saveChanges(int userId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      final user = userProvider.allUser.firstWhere((u) => u["id"] == userId);
      user["name"] = _nameController.text;
    });

    if (isAdminSelected) {
      // await userProvider.changeAdmin(userId);
    }

    _stopEditing();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            if (userProvider.isLoading) {
              return Center(
                child: CircularProgressIndicator(color: Theme.of(context).colorScheme.surface,),
              );
            }

            return RefreshIndicator(
              color: Colors.grey,
              backgroundColor: Colors.white,
              onRefresh: () async {
                await userProvider.getAllUser();
              },
              child: ListView.builder(
                itemCount: userProvider.allUser.length,
                itemBuilder: (BuildContext context, int index) {
                  final user = userProvider.allUser[index];
                  return _buildItem(user, userProvider, index);
                },
              ),

            );
          },
        ),
      ),
    );
  }

  Widget _buildItem(dynamic user, UserProvider userProvider, index) {
    return Container(
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
            spreadRadius: 0.3,
            blurRadius: 5,
            offset: Offset(0, 1),
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
                leading: (user["profil"] == null)?CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    child: Text(
                      user["name"].substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                ):Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 2, horizontal: 2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xff8463BE),
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
                      user["profil"],
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                title: Text(
                    '${user["name"]}',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .surface,
                    )
                ),
                subtitle: Text(
                  '${user["email"]}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                  ),
                ),
                trailing: editingUserId == user["id"]
                    ? InkWell(
                  onTap: () {
                    _saveChanges(user["id"]);
                  },
                  child: userProvider.isLoading
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
                    : accountType == "admin"?PopupMenuButton<String>(
                  onSelected: (String value) {
                    if(accountType == "admin"){
                      if (value == "Désactiver") {
                        userProvider.activeOrDisable(user["id"]);
                      } else if (value == "Modifier") {
                        _startEditing(user["id"], user["name"]);
                      } else if (value == "Supprimer") {
                        userProvider.removeUser(index, user["id"]);
                      }
                    }
                    else{
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Accès Refusé',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
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
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'Modifier',
                        child: Container(
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
                ):Text(""),
                onTap: () {},
              ),
              if (editingUserId == user["id"])
                Container(
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
                ),
            ],
          ),
        ],
      ),
    );
  }
}
