import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

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

class MyButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const MyButton(this.label, {Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
          child:
              MaterialButton(child: label.text.white.make(), onPressed: onTap, minWidth: double.infinity, height: 42.0),
          borderRadius: BorderRadius.circular(10.0),
          elevation: 5.0,
          color: Colors.purple)
      .py16();
}
