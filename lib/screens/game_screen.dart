import 'package:_2048_game/constants/app_colors.dart';
import 'package:_2048_game/game/controls.dart';
import 'package:_2048_game/game/game_logic.dart';
import 'package:_2048_game/models/game_save_model.dart';

import 'package:_2048_game/services/game_storage.dart';
import 'package:_2048_game/services/score_storage.dart';
import 'package:_2048_game/visuals/game_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager_plus/window_manager_plus.dart' as wmp;

import 'dart:math';

import '../game/directions.dart';

class GameScreen extends StatefulWidget {
  final int bestScore;
  final GameSaveModel? savedGame;

  const GameScreen({super.key, required this.bestScore, this.savedGame});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with wmp.WindowListener {
  int? pipWindowId;
  late GameLogic game;
  late final Controls controls;
  final FocusNode _focusNode = FocusNode();

  void _handleKey(KeyEvent event) {
    final direction = controls.handleKey(event);

    if (direction != null) {
      game.move(direction);
      setState(() {});

      sendGameData();
    }
  }

  Future<void> enterPip() async {
    if (pipWindowId != null) {
      return;
    }

    final pipWindow = await wmp.WindowManagerPlus.createWindow(['pip']);

    if (pipWindow == null) {
      return;
    }

    pipWindowId = pipWindow.id;
  }

  @override
  void onWindowClose([int? windowId]) {
    print('WINDOW CLOSED: $windowId');
    print('PIP WINDOW ID: $pipWindowId');

    if (windowId == pipWindowId) {
      pipWindowId = null;
      print('PIP ID CLEARED');
    }
  }

  Future<void> sendGameData() async {
    final id = pipWindowId;
    if (id == null) {
      return;
    }
    try {
      await wmp.WindowManagerPlus.current.invokeMethodToWindow(
        id,
        'updateGame',
        {
          'score': game.score,
          'bestScore': game.bestScore,
          'gameOver': game.gameOver,
          'board': game.board
              .map((tile) => {'id': tile.id, 'value': tile.value})
              .toList(),
        },
      );
    } catch (_) {
      pipWindowId = null;
    }
  }

  @override
  Future<dynamic> onEventFromWindow(
    String eventName,
    int fromWindowId,
    dynamic arguments,
  ) async {
    if (eventName == 'pipReady') {
      await sendGameData();
    }
    if (eventName == 'move') {
      final direction = arguments.toString();

      switch (direction) {
        case 'up':
          game.move(Directions.up);
          break;

        case 'down':
          game.move(Directions.down);
          break;

        case 'left':
          game.move(Directions.left);
          break;

        case 'right':
          game.move(Directions.right);
          break;
      }
      setState(() {});
      await sendGameData();
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    wmp.WindowManagerPlus.current.addListener(this);
    wmp.WindowManagerPlus.addGlobalListener(this);

    game = GameLogic(
      onGameOver: (score) async {
        await ScoreStorage.saveScore(score);
      },
    );
    if (widget.savedGame != null) {
      game.board = widget.savedGame!.board;
      game.score = widget.savedGame!.score;

      game.nextTileId = game.board.map((tile) => tile.id).reduce(max) + 1;
    }
    controls = Controls();
    _focusNode.requestFocus();
    game.bestScore = widget.bestScore;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      autofocus: true,
      focusNode: _focusNode,
      onKeyEvent: _handleKey,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '2048',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF776E65),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Score: ${game.score}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE0C8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'High Score: ${game.bestScore}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  Flexible(child: GameBoard(game: game, pip: false)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              onPressed: () async {
                if (game.score != 0) {
                  await GameStorage.saveCurrentGame(
                    GameSaveModel(score: game.score, board: game.board),
                  );
                }
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: IconButton(
              onPressed: () async {
                enterPip();
              },
              icon: const Icon(Icons.picture_in_picture),
            ),
          ),
          if (game.gameOver)
            Center(
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      spreadRadius: 5,
                      color: Colors.black26,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'score:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      '${game.score}',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.orange,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'GAME OVER',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        color: AppColors.darkText,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'No more moves!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        decoration: TextDecoration.none,
                      ),
                    ),

                    const SizedBox(height: 25),

                    ElevatedButton(
                      onPressed: () {
                        game.reset();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Text('NEW GAME', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (game.score != 0) {
                          await GameStorage.saveCurrentGame(
                            GameSaveModel(score: game.score, board: game.board),
                          );
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[500],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          'HOME',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.lightText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
