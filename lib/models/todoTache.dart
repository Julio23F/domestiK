import 'package:domestik/models/tache.dart';

class TodoTache {
  String? name;
  Tache? tache;

  TodoTache ({
    this.name,
    this.tache,

  });

  factory TodoTache.fromJson(Map<String, dynamic> json) {
    return TodoTache(
      name: json['user']['name'],
      tache: Tache(
        name: json['user']['name'],
      )

    );
  }

}