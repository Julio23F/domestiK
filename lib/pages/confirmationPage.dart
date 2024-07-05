import 'dart:convert';
import 'package:flutter/material.dart';
import '../constant.dart';
import '../models/api_response.dart';
import '../models/historique.dart';
import '../models/user.dart';
import '../services/historique_service.dart';
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
  Map<int, bool> stateMap = {};
  Map<int, bool> loadingMap = {};

  var listConfirmation;
  int? nbrConfirm;

  Future<void> _historiqueToConfirm() async {
    ApiResponse response = await historiqueToConfirm();

    if (response.error == null) {
      setState(() {
        nbrConfirm = (response.data as List).length;
        listConfirmation = response.data as List<Historique>;
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

  Future<void> _confirm(int foyer_id) async {
    setState(() {
      loadingMap[foyer_id] = true;
    });

    ApiResponse response = await confirm(foyer_id);

    if (response.error == null) {
      setState(() {
        stateMap[foyer_id] = true;
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

    setState(() {
      loadingMap[foyer_id] = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _historiqueToConfirm();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xff192b54);
    return Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: ListView(
            children: [
              SizedBox(
                height: 25,
              ),
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
              SizedBox(
                height: 15,
              ),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: nbrConfirm,
                itemBuilder: (context, index) {
                  Historique confirm = listConfirmation[index];
                  bool isConfirmed = stateMap[confirm.id] ?? false;
                  bool isLoading = loadingMap[confirm.id] ?? false;

                  return Container(
                    margin:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                        top: 15, bottom: 15, left: 20, right: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.purple.withOpacity(0.1),
                        width: 0.5,
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
                              confirm.user!.name.toString(),
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
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
                                      color: (confirm.state!=null) ? Color(0xff8463BE) : Colors.grey.shade400,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Wrap(
                                    children: List.generate(
                                        confirm.taches!.length, (i) {
                                      return Container(
                                        margin:
                                        EdgeInsets.only(right: 7),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(5)),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 10),
                                        child: Text(
                                          confirm.taches![i].name
                                              .toString(),
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 9,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        (isConfirmed || confirm.state!=null)
                            ? Container(
                          width: 8,
                          height: 8,
                          margin: EdgeInsets.only(right: 25),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff8463BE),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.9),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                ),
                              ]),
                        )
                            : InkWell(
                          onTap: () {
                            _confirm(confirm.id);
                            print(confirm.state);
                          },
                          child: isLoading
                              ? CircularProgressIndicator()
                              : Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Color(0xff21304f),
                              borderRadius:
                              BorderRadius.circular(7),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.3),
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
        ));
  }
}
