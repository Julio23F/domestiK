import 'dart:convert';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:domestik/pages/auth/login.dart';
import 'package:domestik/services/foyer_service.dart';
import 'package:domestik/services/tache_service.dart';
import 'package:domestik/services/user_service.dart';
import 'package:domestik/models/api_response.dart';
import 'package:domestik/constant.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../services/historique_service.dart';
import '../services/myService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  List<Animation<Offset>> _offsetAnimations = [];

  String data = '';
  var tacheTodo;
  bool isLoading = true;
  String userName = '';
  String foyerName = '';
  int? userId;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _getUserDetail();
    _getTacheTodo(DateTime.now().day);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _startAnimation();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _getUserDetail() async {
    ApiResponse response = await getUserDetail();
    if (response.data != null) {
      setState(() {
        data = jsonEncode(response.data);
        userName = jsonDecode(data)["user"]["name"];
        foyerName = jsonDecode(data)["user"]["foyer"]["name"];
        userId = jsonDecode(data)["user"]["id"];
      });
    }
  }

  Future<void> _getTacheTodo(int date) async {
    setState(() {
      isLoading = true;
    });

    ApiResponse response = await todoTache(date.toString());

    if (response.error == null) {
      setState(() {
        tacheTodo = jsonEncode(response.data);
        isLoading = false;

        // Reset animations for new data
        _offsetAnimations.clear();
        _controller.reset();

        _offsetAnimations = List.generate(
          jsonDecode(tacheTodo).length,
              (index) => Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
            // CurvedAnimation(
            //   parent: _controller,
            //   curve: Curves.easeOut,
            //   reverseCurve: Curves.easeIn,
            // ),
                CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    (index + 1) * 0.1,
                    1.0,
                    curve: Curves.easeOut,
                  ),

                ),
          ),
        );

        // Start the animation
        _startAnimation();
      });
    } else if (response.error == unauthorized) {
      logout().then((value) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false,
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: Text('${response.error}'),
      ));
    }
  }

  void _startAnimation() {
    _controller.forward(from: 0.0);
  }

  bool load = false;
  Future<void> _addHistorique(List tacheIds) async {
    setState(() {
      load = true;
    });

    await addHistorique(tacheIds).then((value) {
      setState(() {
        load = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xff192b54);
    final nbrTache = tacheTodo != null ? jsonDecode(tacheTodo).length : 0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: false,
            floating: true,
            delegate: SliverAppBarDelegate(
              minHeight: 100.0,
              maxHeight: 100.0,
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                padding: EdgeInsets.only(top: 35, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Androibé",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Theme.of(context).colorScheme.surface
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Theme.of(context).colorScheme.surface

                              ),
                            ),
                            Text(
                              'Admin',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 7),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            "assets/images/avatar.png",
                            width: 30,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: SliverAppBarDelegate(
              minHeight: 160.0,
              maxHeight: 160.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 0.5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '29 juin 2024',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Today',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,

                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.grey,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: DatePicker(
                        DateTime.now(),
                        initialSelectedDate: DateTime.now(),
                        selectionColor: Color(0xff21304f),
                        selectedTextColor: Colors.white,
                        onDateChange: (date) {
                          _getTacheTodo(date.day);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                final tache = jsonDecode(tacheTodo)[index];
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return SlideTransition(
                      position: _offsetAnimations[index],
                      child: FadeTransition(
                        opacity: _controller.drive(
                          CurveTween(curve: Curves.easeInOut),
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                            color: (tache["user"]["id"] == userId) ? Color(0xff21304f) : Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.purple.withOpacity(0.1),
                              width: 0.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 0.2,
                                blurRadius: 5,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tache["user"]["name"].toString(),
                                    style: (tache["user"]["id"] == userId) ? TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ) : Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  SizedBox(height: 5),
                                  Wrap(
                                    spacing: 5,
                                    children: List.generate(tache["tache"].length, (i) {
                                      return Container(
                                        margin: EdgeInsets.only(right: 7),
                                        decoration: BoxDecoration(
                                          color: (tache["user"]["id"] == userId)
                                              ? Colors.white.withOpacity(0.1)
                                              : Color(int.parse(tache["tache"][i].split('-')[2])).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                        child: Text(
                                          tache["tache"][i].split('-')[1].toString(),
                                          style: TextStyle(
                                            color: (tache["user"]["id"] == userId) ? Colors.white : textColor,
                                            fontSize: 9,
                                          ),
                                        ),
                                      );
                                    }),
                                  )
                                ],
                              ),
                              SizedBox(width: 10),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                    color: (tache["user"]["id"] == userId) ? Colors.white.withOpacity(0.15) : Colors.grey.withOpacity(0.1),
                                  ),
                                ),
                                child: (tache["user"]["id"] == userId)
                                    ? Container(
                                  height: 70,

                                  child: load
                                      ? Container(
                                        margin: EdgeInsets.symmetric(vertical: 16),

                                        child: CircularProgressIndicator(),
                                      )
                                      : InkWell(
                                    onTap: () {
                                      _addHistorique(convert(tache["tache"]));
                                    },
                                    child: Container(
                                      height: 70,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        color: Color(0xff8463BE),
                                        borderRadius: BorderRadius.circular(7),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: RotatedBox(
                                        quarterTurns: 3,
                                        child: Center(
                                          child: Text(
                                            'Confirmer',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                    : Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xff8463BE),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.9),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              childCount: nbrTache,
            ),
          ),
        ],
      ),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
