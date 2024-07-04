class User {
  int? id;
  String? name;
  String? email;
  int? foyerId;
  String? token;

  User({
    this.id,
    this.name,
    this.email,
    this.foyerId,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'] ?? '',
      foyerId: json['foyer_id'] ?? 0,
      token: json['token'] ?? '',
    );
  }
}
