import 'package:domestik/pages/widgets/addUser.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ajouter'),
              InkWell(
                onTap: () {

                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                  decoration: BoxDecoration(
                    color: Color(0xff8463BE),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.white,),
                      Text('Ajouter', style: TextStyle(color: Colors.white, fontSize: 13),),
                    ],
                  )
                ),
              )
            ],
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Membres'),
              Tab(text: 'Taches'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AddUser(),
            AddUser(),
          ],
        ),
      ),
    );
  }
}
