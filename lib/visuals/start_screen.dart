import 'package:_2048_game/constants/app_colors.dart';
import 'package:_2048_game/models/game_save_model.dart';
import 'package:_2048_game/services/game_storage.dart';
import 'package:_2048_game/visuals/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:_2048_game/services/score_storage.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StatefulWidget> createState() => _StartScreenState();
}

class _StartScreenState() extends State<StartScreen> {
  List<int> topScores = [];
  GameSaveModel currentGame = GameSaveModel(score: 0, board: []);

  @override
  void initState() {
    super.initState();
    loadScores();
    loadGame();
  }

  Future<void> loadGame() async {
    final game = await GameStorage.getCurrentGame();
    print(game.score);

    setState(() {
      currentGame = game;
    });
  }

  Future<void> loadScores() async {
    final scores = await ScoreStorage.getTopScores();

    setState(() {
      topScores = scores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '2048',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: () async {
                      await GameStorage.clearCurrentGame();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(
                            bestScore: topScores.isNotEmpty ? topScores[0] : 0,
                          ),
                        ),
                      );
                      await loadGame();
                      await loadScores();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: AppColors.lightText,
                      backgroundColor: AppColors.neonAccent,
                    ),
                    child: const Text(
                      'NEW GAME',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (currentGame.score != 0)
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameScreen(
                              bestScore: topScores.isNotEmpty
                                  ? topScores[0]
                                  : 0,
                              savedGame: currentGame,
                            ),
                          ),
                        );
                        await loadGame();
                        await loadScores();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: AppColors.darkText,
                        backgroundColor: AppColors.darkAccent,
                      ),
                      child: const Text(
                        'CONTINUE',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.darkAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 280,
              height: 340,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'YOUR TOP SCORES',
                      style: TextStyle(
                        color: AppColors.darkText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),
                    for (int i = 0; i < topScores.length; i++)
                      ListTile(
                        leading: Text(
                          '${i + 1}',
                          style: TextStyle(
                            color: AppColors.darkText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        title: Text(
                          '${topScores[i]}',
                          style: TextStyle(
                            color: AppColors.darkText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
