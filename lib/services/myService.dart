import 'dart:convert';
import 'package:domestik/services/user_service.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import '../models/api_response.dart';
import '../pages/auth/login.dart';
import '../pages/home.dart';
import '../pages/infoPage.dart';

List convert(List<dynamic> donnees) {
  List<String> resultats = [];

  RegExp regex = RegExp(r'^(\d+)');

  for (String donnee in donnees) {
    RegExpMatch? match = regex.firstMatch(donnee);
    if (match != null) {
      resultats.add(match.group(1).toString());
    }
  }

  return resultats;
}


class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

void loadUserInfo(BuildContext context) async {
  String token = await getToken();
  int id = await getUserId();

  if (token == '') {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
  } else {
    ApiResponse response = await getUserDetailSercice();
    final userDetail = jsonEncode(response.data);

    if (response.error == null) {
      print("foyer id de user");
      print(jsonDecode(userDetail)["user"]["foyer_id"]);
      if (jsonDecode(userDetail)["user"]["foyer_id"] == null || jsonDecode(userDetail)["user"]["foyer_id"] == 0) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const InfoPage()), (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Home()), (route) => false);
      }
    } else if (response.error == unauthorized) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }
}
