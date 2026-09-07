import 'package:_2048_game/models/game_save_model.dart';
import 'package:_2048_game/models/tile_model.dart';
import 'package:_2048_game/services/file_services.dart';

class GameStorage {
  static Future<GameSaveModel> getCurrentGame() async {
    final gameFile = await FileServices.readGame();

    if (gameFile[0] == '0') {
      return GameSaveModel(score: 0, board: []);
    }

    return stringToGame(gameFile);
  }

  static Future<void> saveCurrentGame(GameSaveModel game) async {
    final currentGame = gameToString(game);

    await FileServices.writeGame(currentGame);
  }

  static Future<void> clearCurrentGame() async {
    await FileServices.deleteGame();
  }

  static List<String> gameToString(GameSaveModel game) {
    final currentGame = [
      game.score.toString(),
      ...game.board.map((tile) => tile.toString()),
    ];

    return currentGame;
  }

  static GameSaveModel stringToGame(List<String> gameString) {
    final score = int.parse(gameString[0]);
    final board = gameString.sublist(1).map(TileModel.parse).toList();

    return GameSaveModel(score: score, board: board);
  }
}
