import 'dart:convert';
import 'package:domestik/models/api_response.dart';
import 'package:domestik/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/confirmation_provider.dart';
import '../services/user_service.dart';
import '../theme/theme_provider.dart';

class AllUser extends StatefulWidget {
  const AllUser({super.key});

  @override
  State<AllUser> createState() => _AllUserState();
}

class _AllUserState extends State<AllUser> {
  List<dynamic> allUser = [];
  Set<int> selectedUserIds = {};
  List<dynamic> selectedListUser = [];

  bool isLoading = false;

  Future<void> _getAllUser() async {
    ApiResponse response = await getAllUser();
    if (response.data != null) {
      final data = jsonEncode(response.data);
      final users = jsonDecode(data)["users"];
      setState(() {
        allUser = users;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getAllUser();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xff192b54);

    return ChangeNotifierProvider(
      create: (BuildContext context) => UserProvider(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'All User',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Consumer<UserProvider>(
            builder: (context, userProvider, child){
              return Stack(
                children: <Widget>[
                  Container(
                    color: Theme.of(context).colorScheme.background,
                    padding: EdgeInsets.only(top: 35),
                    child: allUser.isEmpty
                        ? Center(child: Image.asset(
                      "assets/images/emptyUser.png",
                      width: MediaQuery.of(context).size.width / 2,
                    )
                    )
                        : ListView.builder(
                        itemCount: allUser.length,
                        itemBuilder: (BuildContext context, int index) {
                          final user = allUser[index];
                          final userId = user['id'];
                          return _buildUserTile(
                            user,
                            user['name'] ?? 'No Name',
                            user['email'] ?? 'No Email',
                            userId,
                            selectedUserIds.contains(userId),
                          );
                        }),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _addUserToFoyer,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff74ABED),
                                  Color(0xff9771F4),
                                  Color(0xff8463BE),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              constraints: BoxConstraints(
                                maxWidth: double.infinity,
                                minHeight: 50.0,
                              ),
                              child: isLoading
                                  ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                                  : Text(
                                'Ajouter au foyer',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

        ),
      ),
    );
  }

  Widget _buildUserTile(user, String name, String email, int userId, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Theme.of(context).colorScheme.primary,
      ),
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[400],
          child: Icon(
            Icons.person_outline_outlined,
            color: Colors.white,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(email),
        trailing: isSelected
            ? Icon(
          Icons.check_circle,
          color: Colors.purple[500],
        )
            : Icon(
          Icons.check_circle_outline,
          color: Colors.grey,
        ),
        onTap: () {
          setState(() {
            if (selectedUserIds.contains(userId)) {
              selectedUserIds.remove(userId);
            } else {
              selectedUserIds.add(userId);
              selectedListUser.add(user);
            }
          });
        },
      ),
    );
  }

  Future<void> _addUserToFoyer() async {
    setState(() {
      isLoading = true;
    });
    await addUser(selectedUserIds.toList());
    await _getAllUser();
    
    Provider.of<UserProvider>(context, listen: false).addUser(selectedListUser);
    print("object");
    print(selectedListUser);
    setState(() {
      selectedUserIds.clear();
      selectedListUser.clear();
      isLoading = false;

    });
  }
}
