import 'dart:math';

import 'package:_2048_game/models/tile_model.dart';

import 'directions.dart';

class GameLogic {
  late List<TileModel> board = List.generate(
    16,
    (index) => TileModel(id: nextTileId++, value: 0),
  );
  bool gameOver = false;
  int? newTileIndex;
  int nextTileId = 0;
  int bestScore = 0;

  int score = 0;

  final void Function(int score)? onGameOver;

  final Random _random = Random();

  GameLogic({this.onGameOver}) {
    _addRandomTile();
    _addRandomTile();
  }

  void _addRandomTile() {
    List<int> emptyCells = [];

    for (int i = 0; i < board.length; i++) {
      if (board[i].value == 0) {
        emptyCells.add(i);
      }
    }
    if (emptyCells.isEmpty) {
      return;
    }

    final cell = emptyCells[_random.nextInt(emptyCells.length)];

    board[cell] = TileModel(
      id: nextTileId++,
      value: _random.nextDouble() < 0.9 ? 2 : 4,
    );

    newTileIndex = cell;
  }

  List<TileModel> _mergeLine(List<TileModel> line) {
    List<TileModel> fullTiles = line.where((tile) => tile.value != 0).toList();

    List<TileModel> result = [];

    int i = 0;
    while (i < fullTiles.length) {
      if (i + 1 < fullTiles.length &&
          fullTiles[i].value == fullTiles[i + 1].value) {
        result.add(TileModel(id: nextTileId++, value: fullTiles[i].value * 2));
        score += fullTiles[i].value * 2;
        if (bestScore < score) {
          bestScore = score;
        }
        i += 2;
      } else {
        result.add(fullTiles[i]);
        i++;
      }
    }
    while (result.length < 4) {
      result.add(TileModel(id: -1, value: 0));
    }
    return result;
  }

  void move(Directions direction) {
    List<TileModel> result = [];
    if (direction == Directions.left) {
      for (int i = 0; i < 4; i++) {
        List<TileModel> tempLine = [];
        int start = i * 4;
        for (int j = start; j < start + 4; j++) {
          tempLine.add(board[j]);
        }
        result.addAll(_mergeLine(tempLine));
      }
    }
    if (direction == Directions.right) {
      for (int i = 0; i < 4; i++) {
        List<TileModel> tempLine = [];
        int start = i * 4 + 3;
        for (int j = start; j >= start - 3; j--) {
          tempLine.add(board[j]);
        }
        result.addAll(_mergeLine(tempLine).reversed);
      }
    }
    if (direction == Directions.up) {
      result = List.generate(16, (index) => TileModel(id: -1, value: 0));
      for (int i = 0; i < 4; i++) {
        List<TileModel> tempLine = [];
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
      result = List.generate(16, (index) => TileModel(id: -1, value: 0));
      for (int i = 0; i < 4; i++) {
        List<TileModel> tempLine = [];
        for (int j = i + 12; j >= i; j -= 4) {
          tempLine.add(board[j]);
        }
        tempLine = _mergeLine(tempLine).reversed.toList();
        for (int x = 0; x < 4; x++) {
          result[i + x * 4] = tempLine[x];
        }
      }
    }
    if (_boardChanged(board, result)) {
      board = result;
      _addRandomTile();
      bool gameEnd = true;
      for (int i = 0; i < board.length; i++) {
        if (board[i].value == 0) {
          gameEnd = false;
        }
      }
      if (gameEnd) {
        for (int i = 0; i < board.length; i++) {
          if (i % 4 != 3 && board[i].value == board[i + 1].value) {
            gameEnd = false;
          }
          if (i < 12 && board[i].value == board[i + 4].value) {
            gameEnd = false;
          }
        }
        if (gameEnd) {
          gameOver = true;
          onGameOver?.call(score);
        }
      }
    } else {
      newTileIndex = null;
    }
  }

  void reset() {
    board = List.generate(16, (index) => TileModel(id: nextTileId++, value: 0));
    _addRandomTile();
    _addRandomTile();
    gameOver = false;
  }

  bool _boardChanged(List<TileModel> oldBoard, List<TileModel> newBoard) {
    for (int i = 0; i < oldBoard.length; i++) {
      if (oldBoard[i].value != newBoard[i].value) {
        return true;
      }
    }

    return false;
  }
}
