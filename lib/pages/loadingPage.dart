import 'package:domestik/pages/auth/login.dart';
import 'package:domestik/pages/home.dart';
import 'package:domestik/pages/infoPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constant.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  void _loadUserInfo() async {
    String token = await getToken();
    int id = await getUserId();
    print("Token");
    print(token);
    print("Id");
    print(id);
    if(token == ''){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);
    }
    else {
      ApiResponse response = await getUserDetail();
      final userDetail = response.data as User;
      print("Foyer_id");
      print(userDetail.foyer_id);

      if (response.error == null){
        if(userDetail.foyer_id == 0) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>InfoPage()), (route) => false);
        }
        else{
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Home()), (route) => false);
        }
      }
      else if (response.error == unauthorized){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));

      }
    }
  }
  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png", width: 90,),
            SizedBox(height: 10,),
            SpinKitThreeBounce(
              color: Color(0xff8463BE),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
