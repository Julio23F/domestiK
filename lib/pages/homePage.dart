import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:domestik/pages/auth/login.dart';
import 'package:domestik/services/foyer_service.dart';
import 'package:domestik/services/tache_service.dart';
import 'package:domestik/services/user_service.dart';
import 'package:domestik/models/api_response.dart';
import 'package:domestik/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String foyerName = '';
  var tacheTodo;
  bool isLoading = true;

  void _getFoyerData() async {
    ApiResponse response = await getFoyerData();
    if (response.data != null && response.data is Map<String, dynamic>) {
      setState(() {
        foyerName = (response.data as Map<String, dynamic>)['name'] ?? '';
      });
    }
  }

  Future<void> _getTacheTodo(int date) async {
    setState(() {
      isLoading = true;
    });

    ApiResponse response = await todoTache(date.toString());

    if (response.error == null) {
      setState(() {
        tacheTodo = jsonEncode(response.data);
        isLoading = false;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false)
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  DateTime _dateTime = DateTime.now();
  void _showDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024, 1, 1), // Corrected firstDate
      lastDate: DateTime(2025, 12, 31), // Corrected lastDate
    ).then((DateTime? value) {
      if (value != null) {
        setState(() {
          _dateTime = value;
        });
        _getTacheTodo(_dateTime.day);

      }
    });
  }





  @override
  void initState() {
    super.initState();
    _getFoyerData();
    _getTacheTodo(_dateTime.day);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xff192b54);
    final nbrTache = tacheTodo != null ? jsonDecode(tacheTodo).length : 0;
    final List<Color> colors = [
      Color(0xffa1c4fd),
      Color(0xffffc2e1),
      Color(0xffc3f8ff),
      Color(0xffffe1a8),
      Color(0xffd4f8e8),
    ];

    return Scaffold(
      body: Container(
        child: DraggableHome(
          title: Container(
            padding: EdgeInsets.only(top: 25),
            child: Text(
              foyerName,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          headerWidget: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              margin: EdgeInsets.only(top: 15),
              child: Container(
                margin: EdgeInsets.only(bottom: 50),
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffd7d6fe),
                      Color(0xfff4ebff).withOpacity(0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 90,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "FARALAHY Julio",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            foyerName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 7),
                            decoration: BoxDecoration(
                                color: Color(0xffFB9F06),
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Text(
                              "Admin",
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          headerBottomBar: Container(
            margin: EdgeInsets.only(top: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Liste tache",
                  style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    _showDate();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color(0xff8463BE),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                        "${_dateTime.day.toString()}/${_dateTime.month.toString()}/${_dateTime.year.toString()}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400
                        ),
                    ),
                  ),
                )

              ],
            ),
          ),
          body: [
            isLoading
                ? Center(
                child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: nbrTache,
              itemBuilder: (context, index) {
                final tache = jsonDecode(tacheTodo)[index];

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tache["user"].toString(),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "juliofaralahy23@gmail.com",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 8,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          children: List.generate(tache["tache"].length, (i) {
                            return Container(
                              margin: EdgeInsets.only(right: 7),
                              decoration: BoxDecoration(
                                  color: colors[index  % colors.length],
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                              child: Text(
                                tache["tache"][i].toString(),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 9,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              },
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
          ],
          fullyStretchable: true,
          backgroundColor: Color(0xfffafafa),
          appBarColor: Color(0xff8463BE),
        ),
      ),
    );
  }
}
