import 'package:flutter/services.dart';

import 'directions.dart';

class Controls {
  Directions? handleKey(KeyEvent event) {
    if (event is! KeyDownEvent) {
      return null;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      return Directions.left;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      return Directions.right;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      return Directions.down;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      return Directions.up;
    }
    return null;
  }
}
