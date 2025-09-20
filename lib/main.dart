import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart';
import 'overlays.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: create ONE game instance and reuse it everywhere
    final game = FlyRun();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: LayoutBuilder(
        builder: (context, constraints) {
          const gameAspectRatio = 450.0 / 800.0;
          final screenAspectRatio = constraints.maxWidth / constraints.maxHeight;

          double gameWidth, gameHeight;
          if (screenAspectRatio > gameAspectRatio) {
            gameHeight = constraints.maxHeight;
            gameWidth = gameHeight * gameAspectRatio;
          } else {
            gameWidth = constraints.maxWidth;
            gameHeight = gameWidth / gameAspectRatio;
          }

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF0A0A23), Color(0xFF2D1B69)]),
            ),
            child: Center(
              child: ClipRect(
                child: SizedBox(
                  width: gameWidth,
                  height: gameHeight,
                  child: GameWidget(
                    game: game,
                    overlayBuilderMap: {
                      // Use the SAME 'game' instance here
                      HUD.id:        (context, _) => HUD(game: game),
                      PauseMenu.id:  (context, _) => PauseMenu(game: game),
                      MainMenu.id:   (context, _) => MainMenu(game: game),
                      HighScores.id: (context, _) => HighScores(game: game),
                    },
                    initialActiveOverlays: const [MainMenu.id ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
