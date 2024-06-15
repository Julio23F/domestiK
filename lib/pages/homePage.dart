import 'package:domestik/pages/auth/login.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String? selectedValue; // Variable pour stocker la valeur sélectionnée
  final List<String> options = ['Option 1', 'Option 2', 'Option 3'];

  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xff192b54);

    return Scaffold(
      body: Container(
        child: DraggableHome(
          // leading: const Icon(Icons.arrow_back_ios),
          title: Container(
              padding: EdgeInsets.only(top: 25),
              child: Text("Analamahitsy", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)
          ),
          // actions: [
          //   IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          // ],
          headerWidget: SafeArea(
            child: Container(
              padding: EdgeInsets.all(25),
              margin: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                  // color: Colors.grey.withOpacity(0.2),
            
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: 90,),
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
                        SizedBox(height: 8,),
                        Container(
                            margin: EdgeInsets.only(right: 7),
                            decoration: BoxDecoration(
                                color: Color(0xffFB9F06),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            child: GestureDetector(
                              onTap: () {
                                logout();
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);
                              },
                              child: Text(
                                "Admin",
                                style: TextStyle(
                                  color: textColor,
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  )
                ],
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
                      fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: DropdownButton<String>(
                    value: selectedValue,
                    hint: Text('Today'),
                    items: options.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          body: [
            for(var i=0; i<10; i++)
            Container(
                margin: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "FARALAHY Julio",
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
                          children: [
                            for(var i = 0; i < 5; i++)
                              Container(
                                margin: EdgeInsets.only(right: 7),
                                decoration: BoxDecoration(
                                    color: Color(0xffd8e6fe),
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  "Douche",
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 8,
                                  ),
                                ),
                              )
                          ],
                        )
                    )
                  ],
                )
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
