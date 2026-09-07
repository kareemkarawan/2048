import 'package:_2048_game/visuals/tile_colors.dart';
import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final int id;
  final int value;

  const Tile({super.key, required this.id, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tile_colors(value),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          value == 0 ? '' : value.toString(),
          style: TextStyle(
            fontSize: value >= 1000 ? 28 : 36,
            fontWeight: FontWeight.bold,
            color: value <= 4 ? Color(0xFF776E65) : Colors.white,
          ),
        ),
      ),
    );
  }
}
