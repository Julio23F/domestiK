import 'package:domestik/pages/loadingPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/api_response.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';
import '../home.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formkey = GlobalKey<FormState>();

  final confEmailController = TextEditingController();
  final confMDPController = TextEditingController();
  final confNomController = TextEditingController();
  final confMDP2Controller = TextEditingController();

  bool loading = false;
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;

  void _registerUser() async {
    ApiResponse response = await register(confNomController.text, confEmailController.text, confMDPController.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
    }
  }

  // Save and redirect to home
  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoadingPage()), (route) => false);
  }

  @override
  void dispose() {
    super.dispose();
    confEmailController.dispose();
    confMDPController.dispose();
    confNomController.dispose();
    confMDP2Controller.dispose();
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
                                labelStyle: TextStyle(
                                  color: Colors.black26,
                                ),
                                hintText: 'Votre nom',
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Invalide";
                                }
                                return null;
                              },
                              controller: confNomController,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: Colors.black26,
                                ),
                                hintText: 'Votre adresse email',
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Adresse email invalide";
                                }
                                return null;
                              },
                              controller: confEmailController,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: TextFormField(
                              obscureText: !_passwordVisible1,
                              decoration: InputDecoration(
                                labelText: 'Mot de passe',
                                labelStyle: TextStyle(
                                  color: Colors.black26,
                                ),
                                hintText: 'Votre mot de passe',
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible1
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible1 = !_passwordVisible1;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value!.length < 6) {
                                  return "Le mot de passe doit contenir au moins 6 caractères";
                                }
                                return null;
                              },
                              controller: confMDPController,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: TextFormField(
                              obscureText: !_passwordVisible2,
                              decoration: InputDecoration(
                                labelText: 'Confirmation mdp',
                                labelStyle: TextStyle(
                                  color: Colors.black26,
                                ),
                                hintText: 'Confirmation mdp',
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible2
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible2 = !_passwordVisible2;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value != confMDPController.text) {
                                  return "La confirmation du mdp est incorrect";
                                }
                                return null;
                              },
                              controller: confMDP2Controller,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 35),
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStatePropertyAll(EdgeInsets.all(12)),
                                backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 66, 101, 224)),
                              ),
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                    _registerUser();
                                  });
                                }
                              },
                              child: loading
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                "Inscription",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Vous avez déjà un compte ?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) => LoginPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Connexion",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
