import 'package:domestik/models/api_response.dart';
import 'package:domestik/pages/auth/login.dart';
import 'package:domestik/pages/home.dart';
import 'package:domestik/services/user_service.dart';
import 'package:flutter/material.dart';

import '../services/foyer_service.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final foyerController = TextEditingController();

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Nom du foyer"),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: "Entrer le nom du foyer"),
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

                Navigator.of(context).pop();

                _creatFoyer();
              },
              child: Text("Save")
          ),
        ],
      )
  );

  void _creatFoyer() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        }
    );
    ApiResponse response = await createFoyer(foyerController.text);

    Navigator.of(context).pop();
    if (response.error == null){
      setState(() {
        foyerController.text = '';
      });
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Home()), (route) => false);
    }
    else {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    foyerController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xff192b54);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Domesti-',
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  'K',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blue
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Color(0xfff9f9f9),
            padding: EdgeInsets.only(top: 35),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Gérer & Organiser',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: textColor,
                        fontSize: 25
                    ),
                  ),
                  Text(
                    'Simplifiez Votre Quotidien en Un Clic',
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 50,),
                  Image.asset(
                    "assets/images/logo.png",
                    width: MediaQuery.of(context).size.width * 4 / 7,
                  ),
                  SizedBox(height: 25,),
                  Text(
                    'Créer un foyer',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Ou attendez qu'on vous ajoute : ",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Actualiser",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 45,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Action du bouton ici
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff74ABED),
                        Color(0xff9771F4),
                        Color(0xff8463BE),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      openDialog();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                        maxWidth: double.infinity,
                        minHeight: 50.0,
                      ),
                      child: Text(
                        'Créer un foyer',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ),
              ),

            ),
          ),
        ],
      ),
    );
  }
}
