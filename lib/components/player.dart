// import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
import 'package:super_fly/components/ground.dart';
import 'package:super_fly/components/obstacle.dart';
import 'package:super_fly/config.dart';
import 'package:super_fly/game.dart';
//import 'package:super_fly/config.dart';

class Player extends SpriteComponent with HasGameRef, CollisionCallbacks {
  Player({required this.joystick, Vector2? startPos})
      : super(
          position: startPos ?? Vector2(100, 100),
          size: Vector2(50, 70),
          anchor: Anchor.center, // center makes bounding easy
        );

  final JoystickComponent joystick;
  double vy = 0; // vertical velocity

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (dt > 1/45) dt = 1/45;

    // --- HORIZONTAL: Using joystick input ---
    double speed = HorizontalSpeed.toDouble();
    
    // Get input from joystick
    double dx = 0;
    double dyInput = 0;
    
    if (!joystick.delta.isZero()) {
      dx = joystick.relativeDelta.x;
      dyInput = joystick.relativeDelta.y; // For joystick, positive Y is down
    }
    
    final horzFactor = (dx != 0 && dyInput != 0) ? 0.7071 : 1.0;
    position.x += dx * speed * horzFactor * dt;

    // --- VERTICAL: simple g-force feel (accel + drag) ---
    double accel = AccVelo.toDouble();   
    double drag  = Drag.toDouble(); 
    double biasG = BiasG.toDouble();  
    double maxVy = MaxVy.toDouble();  

    // Check for joystick input with better sensitivity
    bool upPressed = false;
    bool downPressed = false;
    
    if (!joystick.delta.isZero()) {
      // Use joystick input for vertical movement with lower threshold
      if (joystick.relativeDelta.y < -0.1) upPressed = true;
      if (joystick.relativeDelta.y > 0.1) downPressed = true;
    }

    // input pushes velocity up/down
    if (upPressed)   vy -= accel * dt;
    if (downPressed) vy += accel * dt;

    // small constant gravity-like bias (optional)
    vy += biasG * dt;

    // drag = counterforce proportional to current speed (balances motion)
    vy -= vy * drag * dt;

    // clamp and integrate
    if (vy >  maxVy) vy =  maxVy;
    if (vy < -maxVy) vy = -maxVy;
    position.y += vy * dt;

    // --- BOUNDS (same as yours) ---
    final minX = size.x * 0.5;
    final maxX = gameRef.size.x - size.x * 0.5;
    final minY = size.y * 0.5;
    final maxY = gameRef.size.y - size.y * 0.5;

    if (x < minX) x = minX;
    if (x > maxX) x = maxX;

    if (y < minY) { y = minY; vy = 0; }     // zero velocity on hit feels better
    if (y > maxY) { y = maxY; vy = 0; }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if(other is Ground){
      (parent as FlyRun).gameOver();
    }

    if(other is DinoObstacle){
      (parent as FlyRun).gameOver();
    }
    if(other is KryptoObstacle){
      (parent as FlyRun).gameOver();
    }
  }
}