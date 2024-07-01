import 'package:flutter/cupertino.dart';

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


class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
