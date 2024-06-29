List convert(List<dynamic> donnees) {
  List<String> resultats = [];

  RegExp regex = RegExp(r'^(\d+)');

  for (String donnee in donnees) {
    RegExpMatch? match = regex.firstMatch(donnee);
    if (match != null) {
      resultats.add(match.group(1).toString());
    }
  }

  return resultats;
}