import 'package:flutter/material.dart';

class Constant {
  static Color blue = const Color(0xFF93AEC1).withOpacity(0.9);
  static Color red = const Color(0xFFEC6A52).withOpacity(0.9);
  static Color yellow = const Color(0xFFF8B042);
  static Color pink = const Color(0xFFF3B7AD);
  static const Color darkGray = Color(0xFF343434);
  static const Color lightGray = Color(0xFFD9D9D9);

  // mapに使用する半径の値
  static const Map<int, double> rangeMap = {
    1: 300,
    2: 500,
    3: 1000,
    4: 2000,
    5: 3000,
  };

  // mapに使用するズームレベルの値
  static const Map<int, double> zoomLevelMap = {
    1: 15,
    2: 15,
    3: 14,
    4: 13,
    5: 12,
  };
}
