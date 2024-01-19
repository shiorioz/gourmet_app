import 'package:flutter/material.dart';
import 'package:gourmet_app/constant.dart';

class NormalTextComponent extends StatelessWidget {
  final String text;
  final double textSize;

  const NormalTextComponent(
      {super.key, required this.text, required this.textSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: textSize,
          fontWeight: FontWeight.normal,
          color: Constant.darkGray),
    );
  }
}
