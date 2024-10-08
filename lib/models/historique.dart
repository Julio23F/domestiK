import 'package:domestik/models/tache.dart';
import 'package:domestik/models/user.dart';

class Historique {
  int id;
  int? userId;
  int? userConfimId;
  String? state;
  User? user;
  List<Tache>? taches;

  Historique({
    required this.id,
    this.userId,
    this.userConfimId,
    this.state,
    this.user,
    this.taches,
  });

  factory Historique.fromJson(Map<String, dynamic> json) {
    return Historique(
      id: json['id'],
      userId: json['user_id'],
      userConfimId: json['user_confirm_id'],
      state: json['state'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      taches: json['taches'] != null
          ? (json['taches'] as List).map((i) => Tache.fromJson(i)).toList()
          : [],
    );
  }
}
