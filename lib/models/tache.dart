class Tache {
  int? id;
  String? name;

  Tache({
    this.id,
    this.name,
  });

  factory Tache.fromJson(Map<String, dynamic> json) {
    return Tache(
      id: json['id'],
      name: json['name'],
    );
  }
}
