import 'package:domestik/pages/widgets/addTache.dart';
import 'package:domestik/provider/tache_provider.dart';
import 'package:flutter/material.dart';
import 'package:domestik/pages/widgets/addUser.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import 'allUser.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final foyerController = TextEditingController();
  bool isLoading = false;
  Color pickerColor = const Color(0xff2196f3);

  void _showFlexibleBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 1.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => const AllUser()));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_add,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Ajouter un Utilisateur',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, color: Colors.grey),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  openDialog();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.assignment,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Ajouter une tache',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tache"),
        content: SizedBox(
          height: 210,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Entrer le nom de la tache",
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
                controller: foyerController,

              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlockPicker(
                  pickerColor: pickerColor,
                  onColorChanged: changeColor,
                  availableColors: const [
                    Color(0xffef4749),
                    Colors.green,
                    Color(0xff1877f2),
                    Colors.grey,
                    Colors.orange,
                    Colors.purple,
                    Colors.brown,
                    Color(0xff51bca8),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Annuler",
                style: Theme.of(context).textTheme.bodyMedium,
              )
          ),
          TextButton(
              onPressed: () async {
                final allTache = Provider.of<TacheProvider>(context, listen: false).allTache;
                Navigator.of(context).pop();
                if (allTache.length < 10) {
                  Provider.of<TacheProvider>(context, listen: false).addTache(context, foyerController.text, pickerColor.value.toString());
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Impossible d'ajouter"),
                        content: const Text("Le nombre de vos tâches ne peut pas dépasser 10"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Fermer',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }

                setState(() {
                  foyerController.text = '';
                });
              },
              child: Text(
                "Enregistrer",
                style: Theme.of(context).textTheme.bodyMedium,
              )
          ),
        ],
      )
  );

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
  }

  @override
  void dispose() {
    super.dispose();
    foyerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            "Ajout",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                print("Ajouter");
                _showFlexibleBottomSheet(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xff21304f),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      'Ajouter',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.surface,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).colorScheme.surface,
            tabs: const [
              Tab(text: 'Membres'),
              Tab(text: 'Taches'),
            ],
          ),
        ),

        body: const TabBarView(
          children: [
            AddUser(),
            AddTache(),
          ],
        ),
      ),
    );
  }
}
