class User {
   int? id;
   String? name;
   String? email;
   int? foyer_id;
   String? token;

  User ({
     this.id,
     this.name,
     this.email,
    this.foyer_id,
    this.token
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['user']['id'],
        name: json['user']['name'],
        email: json['user']['email'],
        foyer_id: json['user']['foyer_id']??0,
        token: json['token']??''
    );
  }

}