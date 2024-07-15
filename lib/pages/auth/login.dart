import 'package:domestik/pages/auth/signup.dart';
import 'package:domestik/pages/auth/widgets/remember.dart';
import 'package:domestik/pages/loadingPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/api_response.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';
import '../home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();

  final confEmailController = TextEditingController();
  final confMDPController = TextEditingController();

  bool loading = false;
  bool _isObscure = true;
  String error = "";

  void _loginUser() async {
    ApiResponse response = await login(confEmailController.text, confMDPController.text);

    if (response.error == null) {
      final data = response.data as User;
      print(data.name);
      _saveAndRedirectToHome(response.data as User);

    } else {

      setState(() {
        error = response.error.toString();
      });
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          error = "";
        });
      });
    }
    setState(() {
      loading = false;
    });
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoadingPage()), (route) => false);
  }

  @override
  void dispose() {
    super.dispose();
    confEmailController.dispose();
    confMDPController.dispose();
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
                              "Connexion",
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
                              obscureText: _isObscure,
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
                                    _isObscure ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Mot de passe invalide";
                                }
                                return null;
                              },
                              controller: confMDPController,
                            ),
                          ),
                          RememberSection(),
                          Container(
                            margin: EdgeInsets.only(top: 10),

                            child: Text(
                                error,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 17
                                ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 25),
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
                                    _loginUser();
                                  });
                                }
                              },
                              child: loading
                                  ? Container(height: 27, width: 27,child: CircularProgressIndicator(color: Colors.white,))
                                  : Text(
                                "Connexion",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 35),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Vous n'avez pas de compte ?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) => SignupPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Inscription",
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
