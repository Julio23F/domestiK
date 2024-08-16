class Groupe {
  int? id;
  String? name;
  List? image;
  int? nbrMembres;

  Groupe({
    this.id,
    this.name,
    this.image,
    this.nbrMembres,
  });
  @override
  String toString() {
    return 'Groupe{id: $id, name: $name}';
  }
}
