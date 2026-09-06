import 'package:flutter/material.dart';

Color tile_colors(int value) {
  switch (value) {
    case 2:
      return Colors.white;
    case 4:
      return Colors.yellow;
    case 8:
      return Colors.orange;
    case 16:
      return Colors.red;
    case 32:
      return Colors.pink;
    case 64:
      return Colors.purple;
    case 128:
      return Colors.blue;
    case 256:
      return Colors.green;
    case 512:
      return Colors.teal;
    case 1024:
      return Colors.indigo;
    case 2048:
      return Colors.amber;
    default:
      return Colors.grey[500]!;
  }
}
