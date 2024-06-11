import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Userpage extends StatefulWidget {
  const Userpage({super.key});

  @override
  State<Userpage> createState() => _UserpageState();
}

class _UserpageState extends State<Userpage> {
  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xff192b54);

    return Scaffold(
      body: Container(
        color: Color(0xffF4FCFC),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 25),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 17, right: 17),
                margin: EdgeInsets.only(bottom: 35),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/avatar.png",
                      width: 50,
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Faralahy Julio',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Admin',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 17, right: 17),
                margin: EdgeInsets.only(bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Taches",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) => SizedBox(width: 20),
                        itemCount: 4,
                        itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "1,285",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                "Tache à faire",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 22, horizontal: 17),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Taches",
                        style: TextStyle(
                            color: textColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "A faire",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                          Text(
                            "Mois en cours",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),

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
                                          border: Border(bottom: BorderSide(color: Color(0xff3cadfc).withOpacity(0.3), width: 1))
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Douche",
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 16,

                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 7),
                                            decoration: BoxDecoration(
                                                color: Color(0xffd8e6fe),
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                            child: Text(
                                              "2 jun 2024",
                                              style: TextStyle(
                                                color: textColor,
                                                fontSize: 12
                                              ),
                                            ),

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
              )
            ],
          ),
        ),
      ),
    );
  }
}