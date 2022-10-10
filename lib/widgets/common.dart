import 'package:flutter/material.dart';

class PaddingAll extends StatelessWidget {
  final double gap;
  final Widget? child;
  const PaddingAll({Key? key, this.child, this.gap = 8}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(child: child, padding: EdgeInsets.all(gap));
}

class GapHorizontal extends StatelessWidget {
  const GapHorizontal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(width: 20);
}

class GapVertical extends StatelessWidget {
  const GapVertical({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(height: 20);
}
