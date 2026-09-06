import 'dart:math';

import 'directions.dart';

class GameLogic {
  List<int> board = List.filled(16, 0);
  bool gameOver = false;

  int score = 0;

  final Random _random = Random();

  GameLogic() {
    _addRandomTile();
    _addRandomTile();
  }

  void _addRandomTile() {
    List<int> emptyCells = [];

    for (int i = 0; i < board.length; i++) {
      if (board[i] == 0) {
        emptyCells.add(i);
      }
    }
    if (emptyCells.isEmpty) {
      return;
    }

    final cell = emptyCells[_random.nextInt(emptyCells.length)];

    board[cell] = _random.nextDouble() < 0.9 ? 2 : 4;
  }

  List<int> _mergeLine(List<int> line) {
    List<int> fullTiles = line.where((value) => value != 0).toList();

    List<int> result = [];

    int i = 0;
    while (i < fullTiles.length) {
      if (i + 1 < fullTiles.length && fullTiles[i] == fullTiles[i + 1]) {
        result.add(fullTiles[i] * 2);
        i += 2;
      } else {
        result.add(fullTiles[i]);
        i++;
      }
    }
    while (result.length < 4) {
      result.add(0);
    }
    return result;
  }

  void move(Directions direction) {
    List<int> result = [];
    if (direction == Directions.left) {
      for (int i = 0; i < 4; i++) {
        List<int> tempLine = [];
        int start = i * 4;
        for (int j = start; j < start + 4; j++) {
          tempLine.add(board[j]);
        }
        result.addAll(_mergeLine(tempLine));
      }
    }
    if (direction == Directions.right) {
      for (int i = 0; i < 4; i++) {
        List<int> tempLine = [];
        int start = i * 4 + 3;
        for (int j = start; j >= start - 3; j--) {
          tempLine.add(board[j]);
        }
        result.addAll(_mergeLine(tempLine).reversed);
      }
    }
    if (direction == Directions.up) {
      result = List.filled(16, 0);
      for (int i = 0; i < 4; i++) {
        List<int> tempLine = [];
        for (int j = i; j <= i + 12; j += 4) {
          tempLine.add(board[j]);
        }
        tempLine = _mergeLine(tempLine);
        for (int x = 0; x < 4; x++) {
          result[i + x * 4] = tempLine[x];
        }
      }
    }
    if (direction == Directions.down) {
      result = List.filled(16, 0);
      for (int i = 0; i < 4; i++) {
        List<int> tempLine = [];
        for (int j = i + 12; j >= i; j -= 4) {
          tempLine.add(board[j]);
        }
        tempLine = _mergeLine(tempLine).reversed.toList();
        for (int x = 0; x < 4; x++) {
          result[i + x * 4] = tempLine[x];
        }
      }
    }
    if (result.toString() != board.toString()) {
      board = result;
      _addRandomTile();
      _addRandomTile();
      bool gameEnd = true;
      for (int i = 0; i < board.length; i++) {
        if (board[i] == 0) {
          gameEnd = false;
        }
      }
      if (gameEnd) {
        for (int i = 0; i < board.length; i++) {
          if (i % 4 != 3 && board[i] == board[i + 1]) {
            gameEnd = false;
          }
          if (i < 12 && board[i] == board[i + 4]) {
            gameEnd = false;
          }
        }
        if (gameEnd) {
          gameOver = true;
        }
      }
    } else {
      board = result;
    }
  }

  void reset() {
    board = List.filled(16, 0);
    _addRandomTile();
    _addRandomTile();
    gameOver = false;
  }
}
