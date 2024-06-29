import 'dart:convert';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import '../models/api_response.dart';
import '../services/historique_service.dart';
import '../services/myService.dart';
import '../services/tache_service.dart';
import '../services/user_service.dart';
import 'auth/login.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({super.key});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
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
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirmation',
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
                      Icons.watch_later_outlined,
                      color: Colors.grey,
                      size: 25,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),

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
                      color: Colors.white,
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
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            Text(
                              "Admin",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 8,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 7),
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Color(0xff8463BE),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Wrap(
                                    children: List.generate(tache["tache"].length, (i) {
                                      return Container(
                                        margin: EdgeInsets.only(right: 7),
                                        decoration: BoxDecoration(
                                            color: Color(int.parse(tache["tache"][i].split('-')[2])).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(5)),
                                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                        child: Text(
                                          tache["tache"][i].split('-')[1].toString(),
                                          style: TextStyle(
                                            color: textColor,
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
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color(0xff21304f),
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
                          child: Text(
                            "Confirmer",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
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
