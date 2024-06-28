import 'dart:convert';
import 'package:flutter/cupertino.dart';
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
  String data = '';
  var tacheTodo;
  bool isLoading = true;
  String userName = '';
  String foyerName = '';
  int? userId;

  void _getUserDetail() async {
    ApiResponse response = await getUserDetail();
    if (response.data != null) {
      setState(() {
        data = jsonEncode(response.data);
        userName = jsonDecode(data)["user"]["name"];
        foyerName = jsonDecode(data)["user"]["foyer"]["name"];
        userId = jsonDecode(data)["user"]["id"];
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
      initialDate: _dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025, 12, 31),
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
    _getUserDetail();
    _getTacheTodo(_dateTime.day);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xff192b54);
    final nbrTache = tacheTodo != null ? jsonDecode(tacheTodo).length : 0;

    return Scaffold(
      body: Container(
        child: DraggableHome(
          title: Container(
            padding: EdgeInsets.only(top: 25),
            child: Text(
              foyerName,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
          ),
          headerWidget: SafeArea(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              margin: EdgeInsets.only(top: 15),
              child: Container(
                margin: EdgeInsets.only(bottom: 50),
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      // Color(0xff8463BE),
                      Color(0xfff4ebff),
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
                            userName,
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
                          InkWell(
                            onTap: _getUserDetail,
                            child: Container(
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
                      color: Colors.grey,
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
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 23, horizontal: 20),
                  decoration: BoxDecoration(
                    color: (tache["user"]["id"] == userId)?Color(0xff8463BE):Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.purple.withOpacity(0.1),
                      width: 0.5, // très fine
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 0.2,
                        blurRadius: 5,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tache["user"]["name"].toString(),
                            style: TextStyle(
                              color: (tache["user"]["id"] == userId)?Colors.white:textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          Text(
                            tache["user"]["name"].toString(),
                            style: TextStyle(
                              color: (tache["user"]["id"] == userId)?Colors.white70:textColor,
                              fontSize: 8,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 7),
                                  padding: EdgeInsets.all(4), // Space around the icon
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.cleaning_services_rounded,
                                    size: 11,
                                    color: Color(0xff8463BE),
                                  ),
                                ),
                                Wrap(
                                  children: List.generate(tache["tache"].length, (i) {
                                    return Container(
                                      margin: EdgeInsets.only(right: 7),
                                      decoration: BoxDecoration(
                                          color: (tache["user"]["id"] == userId)?Colors.white.withOpacity(0.1):Color(int.parse(tache["tache"][i].split('-')[1])).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(5)),
                                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                      child: Text(
                                        tache["tache"][i].split('-')[0].toString(),
                                        style: TextStyle(
                                          color: (tache["user"]["id"] == userId)?Colors.white:textColor,
                                          fontSize: 9,
                                        ),
                                      ),
                                    );
                                  }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      (tache["user"]["id"] == userId)?
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.grey.withOpacity(0.6),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Container(
                            height: 70,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Color(0xff8463BE),
                              borderRadius: BorderRadius.circular(7),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Center(
                                child: Text(
                                  'Confirmer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      :Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff8463BE),
                            boxShadow: [
                              BoxShadow(
                              color: Colors.grey.withOpacity(0.9),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                            ]
                        ),
                      )

                    ],
                  ),
                );
              },
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
          ],
          fullyStretchable: true,
          backgroundColor: Colors.white,
          appBarColor: Colors.white,

        ),
      ),
    );
  }
}
