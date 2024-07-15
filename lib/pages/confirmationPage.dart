import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/historique.dart';
import '../provider/confirmation_provider.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({Key? key}) : super(key: key);

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConfirmationProvider(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Validation",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                print("Ajouter");
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  Icons.watch_later_outlined,
                  color: Colors.grey,
                  size: 25,
                ),
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
        body: Consumer<ConfirmationProvider>(
          builder: (context, provider, child) {
            return RefreshIndicator(
              color: Colors.grey,
              backgroundColor: Colors.white,
              onRefresh: () async{
                await provider.loadData();
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: provider.isLoading
                    ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.surface,))
                    : provider.nbrConfirm == 0
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 60,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Aucune confirmation disponible.",
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: provider.nbrConfirm,
                  itemBuilder: (context, index) {
                    Historique confirm = provider.listConfirmation![index];
                    bool isConfirmed = provider.stateMap[confirm.id] ?? false;
                    bool isLoading = provider.loadingMap[confirm.id] ?? false;

                    return AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: 1.0,
                      curve: Curves.easeIn,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0.0, -0.5),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(
                              0.5 + index * 0.05,
                              1.0,
                              curve: Curves.easeInOut,
                            ),
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
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
                                    confirm.user!.name.toString(),
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    confirm.user!.email.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 7),
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: (confirm.state != null)
                                                ? Color(0xff8463BE)
                                                : Colors.grey.shade400,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            size: 11,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Wrap(
                                          children: List.generate(
                                            confirm.taches!.length,
                                                (i) {
                                              return Container(
                                                margin: EdgeInsets.only(right: 7),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.secondary,
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                                child: Text(
                                                  confirm.taches![i].name.toString(),
                                                  style: Theme.of(context).textTheme.bodySmall,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              (isConfirmed || confirm.state != null)
                                  ? Container(
                                width: 8,
                                height: 8,
                                margin: EdgeInsets.only(right: 25),
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
                              )
                                  : InkWell(
                                onTap: () {
                                  provider.confirm(confirm.id);
                                },
                                child: isLoading
                                    ? CircularProgressIndicator()
                                    : Container(
                                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Color(0xff21304f),
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
                                  child: Text(
                                    "Valider",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
