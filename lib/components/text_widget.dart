import 'package:flutter/material.dart';

class NormalTextComponent extends StatelessWidget {
  var viewText;

  NormalTextComponent({super.key, required this.viewText});

  @override
  Widget build(BuildContext context) {
    return Text(
      viewText,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
