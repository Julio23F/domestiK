import 'dart:convert';
import 'package:domestik/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';

import '../constant.dart';
import '../models/api_response.dart';
import '../provider/home_provider.dart';
import '../services/myService.dart';
import '../services/tache_service.dart';
import '../services/user_service.dart';
import '../theme/dark_theme.dart';
import '../theme/theme_provider.dart';
import 'auth/login.dart';

class HomePage extends StatefulWidget {
  final Function(int) setCurrentIndex;

  const HomePage({super.key, required this.setCurrentIndex});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  List<Animation<Offset>> _offsetAnimations = [];

  String data = '';
  var tacheTodo;
  bool isLoading = false;
  bool isLoad = false;

  bool isToday = false;
  DateTime date = DateTime.now();

  // String dateToday = DateFormat('d MMMM y', 'fr_FR').format(DateTime.now());
  String dateToday = DateFormat.yMMMd('en')
      .format(DateTime.now()); // Replace 'en' with your locale
  int dayOfYear(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return dayOfYear;
  }

  @override
  void initState() {
    super.initState();
    _getTacheTodo(dayOfYear(DateTime.now()));

    Provider.of<ThemeProvider>(context, listen: false).checkUserPrefernce();

    Provider.of<UserProvider>(context, listen: false).getUserProfil();
    Provider.of<UserProvider>(context, listen: false).getUserDetail();

    Provider.of<HistoriqueProvider>(context, listen: false).getUserDetail();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimation();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getTacheTodo(int date) async {
    setState(() {
      isLoading = true;
    });
    DateTime now = DateTime.now();
    // String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedDate = DateFormat('dd').format(now);
    ApiResponse response = await todoTache(date.toString());
    if (response.error == null) {
      setState(() {
        tacheTodo = jsonEncode(response.data);
        isLoading = false;

        _offsetAnimations.clear();
        _controller.reset();
        jsonDecode(tacheTodo).length;

        _offsetAnimations = List.generate(
          jsonDecode(tacheTodo).length,
          (index) => Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
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
        _startAnimation();
      });
    } else if (response.error == "unauthorized") {
      print(response.error);
      logout();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );

      await Provider.of<HistoriqueProvider>(context, listen: false).reset();
      await Provider.of<UserProvider>(context, listen: false).reset();
      await Provider.of<ThemeProvider>(context, listen: false).reset();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: Text('${response.error}'),
      ));
    }
    //Vérifier si la date est égale à aujourd'hui
    if (date == dayOfYear(DateTime.now())) {
      setState(() {
        isToday = true;
      });
    } else {
      setState(() {
        isToday = false;
      });
    }
  }

  void _startAnimation() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xff192b54);
    final nbrTache = tacheTodo != null ? jsonDecode(tacheTodo).length : 0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Consumer<HistoriqueProvider>(builder: (context, provider, _) {
        return RefreshIndicator(
          color: Colors.grey,
          backgroundColor: Colors.white,
          onRefresh: () async {
            _getTacheTodo(dayOfYear(DateTime.now()));
          },
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: false,
                floating: true,
                delegate: SliverAppBarDelegate(
                  minHeight: 100.0,
                  maxHeight: 100.0,
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                    padding:
                        const EdgeInsets.only(top: 35, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (provider.foyerName.isNotEmpty)
                              ? '${provider.foyerName.toString()[0].toUpperCase()}${provider.foyerName.toString().substring(1)}'
                              : "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  (provider.userName.isNotEmpty)
                                      ? '${provider.userName.toString()[0].toUpperCase()}${provider.userName.toString().substring(1)}'
                                      : "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 1, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: (provider.accountType == "")
                                          ? Colors.transparent
                                          : (provider.accountType == "admin")
                                              ? Colors.deepOrange
                                                  .withOpacity(0.3)
                                              : Colors.green.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    provider.accountType,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                widget.setCurrentIndex(3);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .profil,
                                    width: 35,
                                    height: 35,
                                    fit: BoxFit.cover,
                                  ),
                                ),
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
                  minHeight: 162.0,
                  maxHeight: 162.0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 0.5),
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
                                    dateToday,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Text(
                                    'Date',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Icon(
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
                            selectionColor: const Color(0xff21304f),
                            selectedTextColor: Colors.white,
                            dayTextStyle: TextStyle(
                                color: Theme.of(context).colorScheme.surface,
                                fontSize: 12),
                            dateTextStyle: TextStyle(
                                color: Theme.of(context).colorScheme.surface,
                                fontWeight: FontWeight.w500,
                                fontSize: 25),
                            monthTextStyle: TextStyle(
                                color: Theme.of(context).colorScheme.surface,
                                fontSize: 11),
                            locale: 'fr_FR',
                            onDateChange: (value) {
                              setState(() {
                                date = value;
                              });
                              _getTacheTodo(dayOfYear(date));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              isLoading
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 100.0),
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.surface,
                            )),
                          );
                        },
                        childCount: 1,
                      ),
                    )
                  : provider.active
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final tache = jsonDecode(tacheTodo)[index];
                              print(tache);
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
                                        margin: const EdgeInsets.only(
                                            top: 10, left: 7, right: 7),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 20),
                                        decoration: BoxDecoration(
                                          color: (tache["user"]
                                                      ["usersIdInGroupe"]
                                                  .contains(provider.userId))
                                              ? const Color(0xff21304f)
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color:
                                                Colors.purple.withOpacity(0.1),
                                            width: 0.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              spreadRadius: 0.2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    tache["user"]["usersIdInGroupe"]
                                                                .length >
                                                            1
                                                        ? Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 8),
                                                            child: Icon(
                                                              Icons.group,
                                                              color: (tache["user"]
                                                                          [
                                                                          "usersIdInGroupe"]
                                                                      .contains(
                                                                          provider
                                                                              .userId))
                                                                  ? Colors.white
                                                                  : Colors.grey,
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                    Text(
                                                      (tache["user"]["name"]
                                                              .isNotEmpty)
                                                          ? '${tache["user"]["name"].toString()[0].toUpperCase()}${tache["user"]["name"].toString().substring(1)}'
                                                          : '',
                                                      style: (tache["user"][
                                                                  "usersIdInGroupe"]
                                                              .contains(provider
                                                                  .userId))
                                                          ? const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )
                                                          : Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 7),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      decoration: BoxDecoration(
                                                        color: tache["user"]
                                                                    [
                                                                    "usersIdInGroupe"]
                                                                .contains(
                                                                    provider
                                                                        .userId)
                                                            ? Colors.white
                                                                .withOpacity(
                                                                    0.1)
                                                            : Colors
                                                                .grey.shade400,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons
                                                            .cleaning_services_rounded,
                                                        size: 11,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Wrap(
                                                      spacing: 5,
                                                      children: List.generate(
                                                          tache["tache"].length,
                                                          (i) {
                                                        return Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 7),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: (tache["user"]["usersIdInGroupe"].contains(
                                                                        provider
                                                                            .userId) ||
                                                                    Provider.of<ThemeProvider>(context)
                                                                            .themeData ==
                                                                        darkTheme)
                                                                ? Colors.white
                                                                    .withOpacity(
                                                                        0.1)
                                                                : Color(int.parse(tache["tache"]
                                                                            [i]
                                                                        .split(
                                                                            '-')[2]))
                                                                    .withOpacity(0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 4,
                                                                  horizontal:
                                                                      10),
                                                          child: Text(
                                                            tache["tache"][i]
                                                                .split('-')[1]
                                                                .toString(),
                                                            style: TextStyle(
                                                              color: (tache["user"]
                                                                              [
                                                                              "usersIdInGroupe"]
                                                                          .contains(provider
                                                                              .userId) ||
                                                                      Provider.of<ThemeProvider>(context)
                                                                              .themeData ==
                                                                          darkTheme)
                                                                  ? Colors.white
                                                                  : textColor,
                                                              fontSize: 9,
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                border: Border.all(
                                                  color: (tache["user"][
                                                              "usersIdInGroupe"]
                                                          .contains(
                                                              provider.userId))
                                                      ? Colors.white
                                                          .withOpacity(0.15)
                                                      : Colors.grey
                                                          .withOpacity(0.1),
                                                ),
                                              ),
                                              child: (tache["user"]
                                                          ["usersIdInGroupe"]
                                                      .contains(
                                                          provider.userId))
                                                  ? Container(
                                                      child: isLoad
                                                          ? const SizedBox(
                                                              height: 25,
                                                              width: 25,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )
                                                          : (provider.isCheck ||
                                                                  !isToday ||
                                                                  tache[
                                                                      "state"] ||
                                                                  convert(tache[
                                                                          "tache"])
                                                                      .isEmpty)
                                                              ? const Icon(
                                                                  Icons.done,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20,
                                                                )
                                                              : InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      isLoad =
                                                                          true;
                                                                    });

                                                                    provider
                                                                        .addHistorique(convert(tache[
                                                                            "tache"]))
                                                                        .then(
                                                                            (value) {
                                                                      setState(
                                                                          () {
                                                                        isLoad =
                                                                            false;
                                                                      });
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: const Color(
                                                                          0xff8463BE),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              7),
                                                                    ),
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .done,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 20,
                                                                    ),
                                                                  ),
                                                                ))
                                                  : Container(
                                                      width: 8,
                                                      height: 8,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: const Color(
                                                            0xff8463BE),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.9),
                                                            spreadRadius: 1,
                                                            blurRadius: 3,
                                                            offset:
                                                                const Offset(
                                                                    0, 1),
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
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Center(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .surface
                                                      .withOpacity(0.7),
                                                  BlendMode.srcATop,
                                                ),
                                                child: Lottie.asset(
                                                  'assets/lottifiles/coco-light.json',
                                                ),

                                                // child: Image.asset(
                                                //   "assets/images/coco.png",
                                                //   width: MediaQuery.of(context).size.width / 3*6,
                                                //   height: 300,
                                                //   fit: BoxFit.cover,
                                                // ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25),
                                            child: Text(
                                              "Votre compte est actuellement désactivé",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Veuillez informer votre admin pour le réactiver.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface
                                                  .withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                            childCount: 1,
                          ),
                        )
            ],
          ),
        );
      }),
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
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
