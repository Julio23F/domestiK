import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';

class ImageProfil extends StatefulWidget {
  const ImageProfil({super.key});

  @override
  State<ImageProfil> createState() => _ImageProfilState();
}

class _ImageProfilState extends State<ImageProfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
          builder: (context, userProvider, child){
            return Center(
              child: Container(
                child: Image.asset(
                    userProvider.profil
                ),
              ),
            );
          }
      ),
    );
  }
}
