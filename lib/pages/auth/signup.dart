import 'package:flutter/material.dart';

import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignupPage> {

  final _formkey = GlobalKey<FormState>();

  final confEmailController = TextEditingController();
  final confMDPController = TextEditingController();
  final confNomController = TextEditingController();
  final confPrenomController = TextEditingController();

  String _response = 'No response yet';
  Future<void> register(nom, prenom, email, mdp) async {
    final url = Uri.parse('https://domestik.onrender.com/api/members/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'mot_de_passe': mdp,
      }),
    );
    setState(() {
      confNomController.text = '';
      confPrenomController.text = '';
      confEmailController.text = '';
      confMDPController.text = '';
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        print(response);
        _response = 'Success: ${response.body}';
      });
    } else {
      setState(() {
        _response = 'Failed: ${response.body}';
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    confEmailController.dispose();
    confMDPController.dispose();
    confNomController.dispose();
    confPrenomController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/auth.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 130,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F8FF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(25),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              "Créer un compte",
                              style: TextStyle(
                                color: Color(0xff222d56),
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Nom',
                                  hintText: 'Votre nom',
                                  hintStyle: const TextStyle(
                                    color: Colors.black26,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.grey, // Nouvelle couleur du bord
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.grey, // Nouvelle couleur du bord
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value){
                                  if(value == null || value.isEmpty ){
                                    return "Invalide";
                                  }
                                  return null;
                                },
                                controller: confNomController,
                              )
                          ),
                          Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Prenom',
                                  hintText: 'Votre prenom',
                                  hintStyle: const TextStyle(
                                    color: Colors.black26,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.grey, // Nouvelle couleur du bord
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.grey, // Nouvelle couleur du bord
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value){
                                  if(value == null || value.isEmpty ){
                                    return "Invalide";
                                  }
                                  return null;
                                },
                                controller: confPrenomController,
                              )
                          ),
                          Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'Votre adresse email',
                                  hintStyle: const TextStyle(
                                    color: Colors.black26,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.grey, // Nouvelle couleur du bord
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.grey, // Nouvelle couleur du bord
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value){
                                  if(value == null || value.isEmpty ){
                                    return "Adresse email invalide";
                                  }
                                  return null;
                                },
                                controller: confEmailController,
                              )
                          ),
                          Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Mot de passe',
                                  hintText: 'Votre mot de passe',
                                  hintStyle: const TextStyle(
                                    color: Colors.black26,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.grey, // Nouvelle couleur du bord
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.grey, // Nouvelle couleur du bord
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value){

                                  if(value!.length < 5){
                                    return "Le mot de passe doit contenir au moins 6 caractères";
                                  }
                                  return null;
                                },
                                controller: confMDPController,
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 35),
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    padding: MaterialStatePropertyAll(EdgeInsets.all(12)),
                                    backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 66, 101, 224))
                                ),
                                onPressed: () {
                                  register(confNomController.text, confPrenomController.text, confEmailController.text, confMDPController.text);
                                },
                                child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18
                                    )
                                )
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 15),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Vous avez déjà compte ?"),
                                  TextButton(
                                    onPressed: (){
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                              pageBuilder: (_, __, ___) => LoginPage()
                                          )
                                      );
                                    },
                                    child: Text(
                                      "Connexion",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.blueAccent
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          )

                        ],
                      ),
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


