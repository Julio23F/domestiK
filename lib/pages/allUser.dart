import 'dart:convert';
import 'package:domestik/models/api_response.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';

class AllUser extends StatefulWidget {
  const AllUser({super.key});

  @override
  State<AllUser> createState() => _AllUserState();
}

class _AllUserState extends State<AllUser> {
  List<dynamic> allUser = [];
  Set<int> selectedUserIds = {};
  bool isLoading = false; // Variable d'état pour le chargement

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'All User',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Color(0xfff9f9f9),
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
              color: Colors.white.withOpacity(0.9),
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
      ),
    );
  }

  Widget _buildUserTile(String name, String email, int userId, bool isSelected) {
    return ListTile(
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
          }
        });
      },
    );
  }

  Future<void> _addUserToFoyer() async {
    setState(() {
      isLoading = true;
    });
    await addUser(selectedUserIds.toList());
    await _getAllUser();
    setState(() {
      isLoading = false;
    });
  }
}
