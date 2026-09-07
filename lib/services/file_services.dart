import 'dart:io';

import 'package:_2048_game/models/game_save_model.dart';

import 'game_storage.dart';

import 'package:path_provider/path_provider.dart';

class FileServices {
  static Future<File> get _gameFile async {
    final directoryPath = await getApplicationDocumentsDirectory();
    final dataDirectory = Directory('${directoryPath.path}/data');

    await dataDirectory.create(recursive: true);

    final gameFile = File('${dataDirectory.path}/game_data.txt');

    return gameFile;
  }

  static Future<void> writeGame(List<String> gameString) async {
    final gameFile = await _gameFile;

    if (!await fileExists()) {
      await gameFile.writeAsString(gameString.join('\n'));
    }
    await deleteGame();
    await gameFile.writeAsString(gameString.join('\n'));
  }

  static Future<List<String>> readGame() async {
    final gameFile = await _gameFile;

    if (!await gameFile.exists()) {
      final empty = GameSaveModel(score: 0, board: []);
      final gameString = GameStorage.gameToString(empty);
      return gameString;
    }

    final data = await gameFile.readAsLines();
    return data;
  }

  static Future<void> deleteGame() async {
    final gameFile = await _gameFile;

    if (await gameFile.exists()) {
      await gameFile.delete();
    }
  }

  static Future<bool> fileExists() async {
    final gameFile = await _gameFile;

    if (await gameFile.exists()) {
      return true;
    }
    return false;
  }
}
