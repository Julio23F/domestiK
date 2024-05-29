import 'package:flutter/material.dart';


class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final confEmailController = TextEditingController();

  @override
  void dispose() {
    confEmailController.dispose();
    super.dispose();
  }

/*  Future passwordChange() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: confEmailController.text.trim()
      );
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Le lien a été envoyé! Regarder voutre email"),
            );
          }
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          }
      );
    }

  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                  'assets/images/cadenas-ouvert.png',
                  width: 100,
              ),
              SizedBox(height: 25,),
              Text(
                "Mot de passe oublié",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 15,),
              Text(
                "Veuillez saisir votre adresse e-mail, et nous vous enverrons un lien vous permettant de modifier le mot de passe.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey
                ),
              ),
              SizedBox(height: 22,),
              TextFormField(
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
                  if (value == null || value.isEmpty){
                    return "Adresse email invalide";
                  }
                  return null;
                },
                controller: confEmailController,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 25),
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.all(12)),
                        backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 66, 101, 224))
                    ),
                    onPressed: () {},
                    child: Text(
                        "Enoyer",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                        )
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
