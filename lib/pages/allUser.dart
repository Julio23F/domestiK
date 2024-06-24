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

  Future<void> _getAllUser() async {

    ApiResponse response = await getAllUser();
    final allUser = jsonEncode(response.data);
    print(jsonDecode(allUser)["users"][0]["name"]);

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
                children: [
                  for(int i=0; i<20; i++)
                  Card(
                    elevation: 0.5,
                    margin: EdgeInsets.symmetric(vertical: 6.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          "user.name",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text("username"),
                      trailing: Checkbox(
                        value: true,
                        onChanged: (bool? value) {
                          setState(() {

                          });
                        },
                      ),
                    ),
                  )
                ]
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
                      child: InkWell(
                        onTap: () {
                          _getAllUser();
                        },
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
            ),
        ],
      ),
    );
  }
}

