import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../forgot_password.dart';

class RememberSection extends StatelessWidget {
  const RememberSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: const ForgotPasswordPage(),
                  ),
              );
            },
            child: const Text(
              "Mot de passe oublié ?",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.blueAccent
              ),
            ),
          )

        ],
      ),
    );
  }
}
