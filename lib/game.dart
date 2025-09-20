// lib/fly_run.dart
import 'dart:async';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/player.dart';
import 'components/background.dart';
import 'components/ground.dart';
import 'components/obstacle.dart';
import 'config.dart';
import 'overlays.dart';

class FlyRun extends FlameGame with HasCollisionDetection {
  // world components
  late final Player player;
  late final Background bg;
  late final Ground gd1;
  late final Ground gd2;
  late final ObstacleSpawner obs;
  late final JoystickComponent joystick;

  // score lives in HUD via ValueNotifier
  int score = 0;
  final ValueNotifier<int> scoreVN = ValueNotifier<int>(0);

  bool isGameOver = false;

  // wait-until-loaded gate
  final Completer<void> _boot = Completer<void>();
  Future<void> get boot => _boot.future;

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(resolution: Vector2(400, 800));

    // background
    bg = Background(Vector2(500, 800));
    add(bg);

    // Joystick (margin uses game size, so set it here)
    joystick = JoystickComponent(
      knob: CircleComponent(
        radius: 20,
        paint: Paint()..color = const Color.fromARGB(255, 126, 22, 192).withOpacity(0.9),
      ),
      background: CircleComponent(
        radius: 50,
        paint: Paint()..color = Colors.grey.withOpacity(0.6),
      ),
      margin: EdgeInsets.only(left: size.x / 2 - 50, bottom: 100),
      priority: 1000,
    );

    // player
    player = Player(joystick: joystick, startPos: Vector2(120, 320));
    add(player);
    add(joystick);

    // ground strips
    gd1 = Ground(startX: 0, speed: 80)..priority = 0;
    gd2 = Ground(startX: size.x, speed: 80)..priority = 0;
    addAll([gd1, gd2]);

    // obstacles
    obs = ObstacleSpawner(
      spawnEvery: spawnRate,
      baseSpeed: obstacleSpeed.toDouble(),
      topMargin: 60,
      bottomMargin: 160,
    );
    add(obs);

    // start paused (MainMenu overlay is initially visible from GameWidget)
    pauseEngine();

    // mark game as ready
    if (!_boot.isCompleted) _boot.complete();
  }

  // call wherever you award points
  void scoreIncrement() {
    score += 1;
    scoreVN.value = score; // HUD updates automatically
  }

  //  game flow
  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    pauseEngine();

    // s ave locally then show HighScores overlay
    ScoreService.saveIfTop(ScoreService.playerName, score);
    overlays.remove(HUD.id);
    overlays.add(HighScores.id);
  }

  void resetGame() {
    // reset player & world
    player.vy = 0;
    isGameOver = false;

    // Clear existing obstacles
    children.whereType<DinoObstacle>().forEach((o) => o.removeFromParent());
    children.whereType<KryptoObstacle>().forEach((o) => o.removeFromParent());

    // Reset score
    score = 0;
    scoreVN.value = 0;
  }

  //  overlay helpers
  void pauseGame() {
    pauseEngine();
    overlays.add(PauseMenu.id);
  }

  void resumeGame() {
    overlays.remove(PauseMenu.id);
    resumeEngine();
  }

  void goToMenu() {
    pauseEngine();
    // Remove all overlays safely (OverlayManager has no removeWhere)
    for (final id in overlays.activeOverlays.toList()) {
      overlays.remove(id);
    }
    overlays.add(MainMenu.id);
  }

  Future<void> startRun() async {
    // Ensure onLoad has finished and components exist
    await boot;
    resetGame();
    overlays.remove(MainMenu.id);
    overlays.add(HUD.id);
    resumeEngine();
  }
}
