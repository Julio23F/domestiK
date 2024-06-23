class Tache {
  String? name;

  Tache({
    this.name,
  });

// map json to post model

  factory Tache.fromJson(Map<String, dynamic> json) {
    return Tache(
        name: json['name'],
    );
  }

}