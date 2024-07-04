import 'package:domestik/models/tache.dart';
import 'package:domestik/models/user.dart';

class Historique {
  int? id;
  int? userId;
  String? state;
  User? user;
  List<Tache>? taches;

  Historique({
    this.id,
    this.userId,
    this.state,
    this.user,
    this.taches,
  });

  factory Historique.fromJson(Map<String, dynamic> json) {
    return Historique(
      id: json['id'],
      userId: json['user_id'],
      state: json['state'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      taches: json['taches'] != null
          ? (json['taches'] as List).map((i) => Tache.fromJson(i)).toList()
          : [],
    );
  }
}
