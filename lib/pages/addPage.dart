import 'package:domestik/pages/widgets/addTache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:domestik/pages/widgets/addUser.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

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
  Color pickerColor = const Color(0xff2196f3);

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
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AllUser()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_add,
                        color: Colors.grey,
                      ),
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
                  Navigator.of(context).pop();
                  openDialog();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.assignment,
                        color: Colors.grey,
                      ),
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
        content: Container(
          height: 210,
          child: Column(
            children: [
              TextField(
                autofocus: true,
                decoration:
                InputDecoration(hintText: "Entrer le nom de la tache"),
                controller: foyerController,
              ),
              SizedBox(height: 20),
              Expanded(
                child: BlockPicker(
                  pickerColor: pickerColor,
                  onColorChanged: changeColor,
                  availableColors: [
                    Color(0xffef4749),
                    Colors.green,
                    Color(0xff1877f2),
                    Colors.yellow,
                    Colors.orange,
                    Colors.purple,
                    Colors.brown,
                    Color(0xff51bca8),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Annuler")),
          TextButton(
              onPressed: () async {
                _addTache(foyerController.text);
                setState(() {
                  foyerController.text = '';
                });
                Navigator.of(context).pop();
              },
              child: Text("Save")),
        ],
      )
  );

  Future<void> _addTache(String name) async {
    ApiResponse response = await addTache(name, pickerColor.value.toString());
    setState(() {
      isLoading = false;
    });

    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    } else {
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
  }

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
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
                  color: Color(0xff21304f),
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
            AddTache(),
          ],
        ),
      ),
    );
  }
}
