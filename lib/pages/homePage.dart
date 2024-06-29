import 'dart:convert';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:domestik/pages/auth/login.dart';
import 'package:domestik/services/foyer_service.dart';
import 'package:domestik/services/tache_service.dart';
import 'package:domestik/services/user_service.dart';
import 'package:domestik/models/api_response.dart';
import 'package:domestik/constant.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../services/historique_service.dart';
import '../services/myService.dart';

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
  String? dateToday;
  void _showDate() {
    setState(() {
      // dateToday = DateFormat('d MMM, y', 'fr').format(DateTime.now());
    });

  }
  bool load = false;
  Future<void> _addHistorique(List tacheIds) async{
    setState(() {
      load = true;
    });

    await addHistorique(tacheIds).then((value) {
      setState(() {
        load = false;
      });
    });

  }




  @override
  void initState() {
    super.initState();
    _getUserDetail();
    _getTacheTodo(_dateTime.day);
    _showDate();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xff192b54);
    final nbrTache = tacheTodo != null ? jsonDecode(tacheTodo).length : 0;
    var selectedValue;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          children: [
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "Androibé",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Admin',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),

                        ),
                      ],
                    ),
                    SizedBox(width: 7,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,

                      ),
                      child: Image.asset("assets/images/avatar.png", width: 30,),
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "29 juin, 2024",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Today',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.grey,
                    size: 25,
                  ),
                ),
              ],
            ),
            Container(
              height: 90,
              margin: EdgeInsets.only(bottom: 25),
              child: Expanded(
                child: DatePicker(
                  DateTime.now(),
                  initialSelectedDate: DateTime.now(),
                  selectionColor: Color(0xff21304f),
                  selectedTextColor: Colors.white,
                  onDateChange: (date) {
                    setState(() {
                      selectedValue = date;
                      _getTacheTodo(selectedValue.day);
                    });
                  },
                ),
              ),
            ),
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
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: (tache["user"]["id"] == userId)?Color(0xff21304f):Colors.white,
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
                            "Admin",
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
                                          color: (tache["user"]["id"] == userId)?Colors.white.withOpacity(0.1):Color(int.parse(tache["tache"][i].split('-')[2])).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(5)),
                                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                      child: Text(
                                        tache["tache"][i].split('-')[1].toString(),
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
                        child: load?
                        CircularProgressIndicator(color: Colors.grey.shade400,)
                        :InkWell(
                          onTap: () {
                            // tache["tache"][i].split('-')[1].toString()
                            _addHistorique(convert(tache["tache"]));
                            print(tache["tache"]);
                          },
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
                                  blurRadius: 1,
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
        ),
      )
    );
  }
}
