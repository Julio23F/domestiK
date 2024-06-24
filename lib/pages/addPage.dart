import 'package:flutter/material.dart';
import 'package:domestik/pages/widgets/addUser.dart';

import '../models/api_response.dart';
import '../services/tache_service.dart';
import 'allUser.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  final foyerController = TextEditingController();
  bool isLoading = false;
  void _showFlexibleBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  print("Utilisateur");
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AllUser()));

                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Row(
                    children: [
                      Icon(Icons.person_add, color: Colors.grey,),
                      SizedBox(width: 10),
                      Text(
                        'Ajouter un Utilisateur',
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 1, color: Colors.grey),
              InkWell(
                onTap: () {
                  print("Tache");
                  Navigator.of(context).pop();
                  openDialog();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Row(
                    children: [
                      Icon(Icons.assignment, color: Colors.grey,),
                      SizedBox(width: 10),
                      Text(
                        'Ajouter une tache',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Tache"),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: "Entrer le nom de la tache"),
          controller: foyerController,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Annuler")
          ),
          TextButton(
              onPressed: () async{
                _addTache(foyerController.text);
                Navigator.of(context).pop();

              },
              child: Text("Save")
          ),
        ],
      )
  );

  Future<void> _addTache(String name) async {


    ApiResponse response = await addTache(name);
    setState(() {
      isLoading = false;
    });

    if(response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('${response.message}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    foyerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ajout'),
          actions: [
            InkWell(
              onTap: () {
                print("Ajouter");
                _showFlexibleBottomSheet(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: Color(0xff8463BE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      'Ajouter',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
          ],
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
