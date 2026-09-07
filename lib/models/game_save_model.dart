import 'package:_2048_game/models/tile_model.dart';

class GameSaveModel {
  int score;
  List<TileModel> board;

  GameSaveModel({required this.score, required this.board});
}
