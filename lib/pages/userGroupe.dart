import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart'; // Correct path to UserProvider

class Usergroupe extends StatefulWidget {
  final String title;
  final int groupeId;

  const Usergroupe({super.key, required this.title, required this.groupeId});

  @override
  State<Usergroupe> createState() => _UsergroupeState();
}

class _UsergroupeState extends State<Usergroupe> with TickerProviderStateMixin {
  List<dynamic> selectedUser = [];
  int? editingUserId;
  final TextEditingController _nameController = TextEditingController();
  bool isAdminSelected = false;
  bool isLoad = false;
  bool isGrouping = false;
  final nomGroupeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getAllUserInGroupe(widget.groupeId);
    Provider.of<UserProvider>(context, listen: false).getUserAccountType();
  }

  void _startEditing(int userId, String initialName) {
    setState(() {
      editingUserId = userId;
      _nameController.text = initialName;
    });
  }

  void _stopEditing() {
    setState(() {
      isAdminSelected = false;
      editingUserId = null;
    });
  }

  void _saveChanges(int userId) async {
    setState(() {
      isLoad = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      final user = userProvider.allUserInGroupe.firstWhere((u) => u["id"] == userId);
      user["name"] = _nameController.text;
    });
    if (isAdminSelected) {
      await userProvider.changeAdmin(userId);
    } else {
      print("user choisi");
    }
    setState(() {
      isLoad = false;
    });
    _stopEditing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {

            return RefreshIndicator(
              color: Colors.grey,
              backgroundColor: Colors.white,
              onRefresh: () async {
                await userProvider.getAllUserInGroupe(widget.groupeId);
                await userProvider.getUserAccountType();
              },
              child: ListView(
                children: [
                  userProvider.isLoading?Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.surface,
                        )
                    ),
                  )
                      :ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: userProvider.allUserInGroupe.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = userProvider.allUserInGroupe[index];
                      return _buildItem(user, userProvider, index);
                    },
                  )
                ],
              )
            );
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _buildItem(dynamic user, UserProvider userProvider, int index) {
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
            offset: const Offset(0, 1),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Stack(
        children: [
          if (user["active"] != 1)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: 5,
              child: Container(
                decoration: const BoxDecoration(
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
                leading: (user["profil"] == null)
                    ? CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  child: Text(
                    user["name"].substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                    : Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
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
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                subtitle: Text(
                  '${user["email"]}',
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.5),
                      fontSize: 10
                  ),
                ),
                trailing: (editingUserId == user["id"]
                    ? _buildEditingActions(user)
                    : userProvider.accountType == "admin"
                    ? _buildPopupMenu(userProvider, user, index)
                    : const Text("")),
                onTap: () {
                  if (editingUserId != null) {
                    _stopEditing();
                  } else if (!isGrouping) {
                    _showUserProfile(user);
                  }
                },
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: (editingUserId == user["id"])
                    ? Container(
                  padding: const EdgeInsets.only(bottom: 10, left: 70),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        margin: const EdgeInsets.only(right: 5),
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
                                  margin: const EdgeInsets.only(right: 7),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isAdminSelected ? Colors.lightGreen.shade400 : Colors.lightGreen.shade400,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
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
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        margin: const EdgeInsets.only(right: 5),
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
                                  margin: const EdgeInsets.only(right: 7),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isAdminSelected ? Colors.deepOrange.shade400 : Colors.deepOrange.shade400,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
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
                    : const SizedBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditingActions(dynamic user) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () => _saveChanges(user["id"]),
        ),
        IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: _stopEditing,
        ),
      ],
    );
  }

  Widget _buildPopupMenu(UserProvider userProvider, dynamic user, int index) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        if (userProvider.accountType == "admin") {
          if (value == "Désactiver") {
            userProvider.activeOrDisable(user["id"], "groupe");
          } else if (value == "Modifier") {
            _startEditing(user["id"], user["name"]);
          } else if (value == "Supprimer") {
            userProvider.removeUser(index, user["id"], "groupe");
          }
          else if (value == "Retirer") {
            userProvider.removeFromGroupe(index, user["id"]);


          }

        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'Retirer',
            child: Row(
              children: [
                Icon(Icons.group_remove, color: Colors.black54),
                SizedBox(width: 8),
                Text('Retirer', style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          if (user["id"] != userProvider.userId)
            PopupMenuItem<String>(
              value: 'Modifier',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.black54),
                  SizedBox(width: 8),
                  Text('Modifier', style: TextStyle(color: Colors.black54)),
                ],
              ),
            ),

          PopupMenuItem<String>(
            value: 'Désactiver',
            child: Row(
              children: [
                const Icon(Icons.block, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  user["active"] != 1 ? 'Réactiver' : 'Désactiver',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          if (user["id"] != userProvider.userId)
            const PopupMenuItem<String>(
              value: 'Supprimer',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.black54),
                  SizedBox(width: 8),
                  Text('Supprimer', style: TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          // PopupMenuItem<String>(
          //   value: 'Supprimer',
          //   child: Row(
          //     children: [
          //       Icon(Icons.delete, color: Colors.black54),
          //       SizedBox(width: 8),
          //       Text('Supprimer', style: TextStyle(color: Colors.black54)),
          //     ],
          //   ),
          // ),
        ];
      },
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
    );
  }


  void _showUserProfile(dynamic user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 25,),
              Container(
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
                  child: ClipOval(
                    child: (user["profil"] == null)
                        ? SizedBox(
                      width: 130,
                      height: 130,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        child: Text(
                          user["name"].substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 80
                          ),
                        ),
                      ),
                    ):Image.asset(
                      user["profil"],
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  )
              ),
              const SizedBox(height: 20,),
              Text(
                user["name"],
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.surface
                ),
              ),
              Text(
                user["email"],
                style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.6)
                ),
              ),
              const SizedBox(height: 25,),

            ],
          ),
        );
      },
    );
  }


}
