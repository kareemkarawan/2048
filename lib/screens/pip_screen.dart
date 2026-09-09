import 'package:_2048_game/constants/app_colors.dart';
import 'package:window_manager_plus/window_manager_plus.dart';

import '../game/game_logic.dart';
import '../models/tile_model.dart';
import '../visuals/game_board.dart';
import '../game/controls.dart';

import 'package:flutter/material.dart';

class PipScreen extends StatefulWidget {
  const PipScreen({super.key});

  @override
  State<PipScreen> createState() => _PipScreenState();
}

class _PipScreenState extends State<PipScreen> with WindowListener {
  late final Controls controls;
  final FocusNode _focusNode = FocusNode();
  GameLogic? game;
  bool mouseOn = false;

  void _handleKey(KeyEvent event) {
    final direction = controls.handleKey(event);

    if (direction != null) {
      WindowManagerPlus.current.invokeMethodToWindow(0, 'move', direction.name);
    }
  }

  @override
  void initState() {
    super.initState();

    WindowManagerPlus.current.addListener(this);

    controls = Controls();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    WindowManagerPlus.current.invokeMethodToWindow(0, 'pipReady');
  }

  @override
  void dispose() {
    WindowManagerPlus.current.removeListener(this);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Future<dynamic> onEventFromWindow(
    String eventName,
    int fromWindowId,
    dynamic arguments,
  ) async {
    if (eventName == 'updateGame') {
      final data = Map<String, dynamic>.from(arguments);

      game ??= GameLogic();

      game!.score = data['score'];
      game!.bestScore = data['bestScore'];
      game!.gameOver = data['gameOver'];

      final boardData = List<dynamic>.from(data['board']);

      game!.board = boardData.map((tile) {
        return TileModel(id: tile['id'], value: tile['value']);
      }).toList();
      setState(() {});
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          mouseOn = true;
        });
      },
      onExit: (_) {
        setState(() {
          mouseOn = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus();
        },
        child: KeyboardListener(
          autofocus: true,
          focusNode: _focusNode,
          onKeyEvent: _handleKey,
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.boardColor,
                body: game == null
                    ? const SizedBox.expand()
                    : GameBoard(game: game!, pip: true),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: IgnorePointer(
                  ignoring: !mouseOn,
                  child: AnimatedOpacity(
                    opacity: mouseOn ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: IconButton(
                      onPressed: () {
                        WindowManagerPlus.current.close();
                      },
                      icon: Icon(Icons.close, color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
