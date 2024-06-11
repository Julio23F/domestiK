import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        color: Color(0xffF4FCFC),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 25, left: 17, right: 17),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ANOSY",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Container(
                padding: EdgeInsets.all(25),
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Text("Remplir"),
                    SizedBox(height: 90,),
                    Column(
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
                          child: Text(
                            "Admin",
                            style: TextStyle(
                              color: textColor,
                            ),
                          ),

                        )
                      ],
                    )
                  ],
                ),
              ),

              //Filtre
              Container(
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

              //Tache à faire
              Container(
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for(var i = 0; i < 15; i++)
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
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
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
