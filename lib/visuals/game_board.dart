import 'package:_2048_game/constants/app_colors.dart';
import 'package:_2048_game/game/game_logic.dart';
import 'package:flutter/material.dart';

import 'tile.dart';

class GameBoard extends StatefulWidget {
  final GameLogic game;
  final bool pip;

  const GameBoard({super.key, required this.game, required this.pip});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double size = 0;
        double borderR = 0;
        double edgedistance = 10;

        if (widget.pip) {
          size = (constraints.maxWidth - edgedistance).clamp(
            0.0,
            double.infinity,
          );
        } else {
          size =
              ((constraints.maxWidth < constraints.maxHeight
                          ? constraints.maxWidth
                          : constraints.maxHeight) -
                      edgedistance)
                  .clamp(0.0, double.infinity);

          borderR = 7;
        }

        final tiledivision = ((size) / 4);
        final interval = tiledivision / 40;
        final tileSize = tiledivision - 2 * interval;
        final spacing = tiledivision;
        return Container(
          width: size,
          height: size,
          margin: EdgeInsets.all(edgedistance / 2),
          decoration: BoxDecoration(
            color: AppColors.boardColor,
            borderRadius: BorderRadius.circular(borderR),
          ),
          child: Container(
            padding: EdgeInsets.all(interval),
            child: Stack(
              children: [
                for (int index = 0; index < 16; index++)
                  Positioned(
                    left: (index % 4) * spacing,
                    top: (index ~/ 4) * spacing,
                    width: tileSize,
                    height: tileSize,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFCDC1B4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                for (int index = 0; index < 16; index++)
                  if (widget.game.board[index].value != 0)
                    AnimatedPositioned(
                      key: ValueKey(widget.game.board[index].id),
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeOut,
                      left: (index % 4) * spacing,
                      top: (index ~/ 4) * spacing,
                      width: tileSize,
                      height: tileSize,
                      child: Tile(
                        id: widget.game.board[index].id,
                        value: widget.game.board[index].value,
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
