import 'dart:ffi';

class User {
  int? id;
  String? name;
  Bool? active;
  String? email;
  int? foyerId;
  String? token;

  User({
    this.id,
    this.name,
    this.active,
    this.email,
    this.foyerId,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      active: json['active'],
      email: json['email'],
      foyerId: json['foyer_id'] ?? 0,
      token: json['token'] ?? '',
    );
  }
}
