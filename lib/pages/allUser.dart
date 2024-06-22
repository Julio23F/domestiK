import 'package:flutter/material.dart';

class AllUser extends StatefulWidget {
  const AllUser({super.key});

  @override
  State<AllUser> createState() => _AllUserState();
}

class _AllUserState extends State<AllUser> {
  final List<User> users = [
    User(name: 'FARALAHY', username: 'Julio', isSelected: false),
    User(name: 'ZAFISOA', username: 'Madeleine', isSelected: false),
    User(name: 'Jhon', username: 'Doe', isSelected: false),    User(name: 'FARALAHY', username: 'Julio', isSelected: false),
    User(name: 'ZAFISOA', username: 'Madeleine', isSelected: false),
    User(name: 'Jhon', username: 'Doe', isSelected: false),    User(name: 'FARALAHY', username: 'Julio', isSelected: false),
    User(name: 'ZAFISOA', username: 'Madeleine', isSelected: false),
    User(name: 'Jhon', username: 'Doe', isSelected: false),    User(name: 'FARALAHY', username: 'Julio', isSelected: false),
    User(name: 'ZAFISOA', username: 'Madeleine', isSelected: false),
    User(name: 'Jhon', username: 'Doe', isSelected: false),    User(name: 'FARALAHY', username: 'Julio', isSelected: false),
    User(name: 'ZAFISOA', username: 'Madeleine', isSelected: false),
    User(name: 'Jhon', username: 'Doe', isSelected: false),    User(name: 'FARALAHY', username: 'Julio', isSelected: false),
    User(name: 'ZAFISOA', username: 'Madeleine', isSelected: false),
    User(name: 'Jhon', username: 'Doe', isSelected: false),    User(name: 'FARALAHY', username: 'Julio', isSelected: false),
    User(name: 'ZAFISOA', username: 'Madeleine', isSelected: false),
    User(name: 'Jhon', username: 'Doe', isSelected: false),    User(name: 'FARALAHY', username: 'Julio', isSelected: false),
    User(name: 'ZAFISOA', username: 'Madeleine', isSelected: false),
    User(name: 'Jhon', username: 'Doe', isSelected: false),    User(name: 'FARALAHY', username: 'Julio', isSelected: false),
    User(name: 'ZAFISOA', username: 'Madeleine', isSelected: false),
    User(name: 'Jhon', username: 'Doe', isSelected: false),    User(name: 'FARALAHY', username: 'Julio', isSelected: false),
    User(name: 'ZAFISOA', username: 'Madeleine', isSelected: false),
    User(name: 'Jhon', username: 'Doe', isSelected: false),

  ];

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
                      fontWeight: FontWeight.w500
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
            child: SingleChildScrollView(
              child: Column(
                children: users.map((user) {
                  int index = users.indexOf(user);
                  return Card(
                    elevation: 0.5,
                    margin: EdgeInsets.symmetric(vertical: 6.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          user.name,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text("${user.name} ${user.username}"),
                      trailing: Checkbox(
                        value: user.isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            users[index].isSelected = value!;
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Expanded(

              child: Container(
                color: Colors.white.withOpacity(0.9),
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      print("Ajout00");
                    },
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
                          child: Text(
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
            ),
        ],
      ),
    );
  }
}

class User {
  String name;
  String username;
  bool isSelected;

  User({required this.name, required this.username, required this.isSelected});
}
