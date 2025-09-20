import 'dart:math' as math;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:super_fly/game.dart';


const _dinoSize    = (72.0, 56.0); 
const _kryptoSize  = (28.0, 28.0);

const _scrollSpeed = 140.0;               // base speed to the left (px/s)
const _spawnGap    = 1.3;                 // seconds between spawns (avg)
const _topMargin   = 30.0;                // keep from the very top
const _bottomMargin= 160.0; 


class DinoObstacle extends SpriteComponent with CollisionCallbacks, HasGameRef<FlyRun>{
  DinoObstacle({
    required this.speed
  }) : super (
    size: Vector2(_dinoSize.$1, _dinoSize.$2),
    anchor: Anchor.topLeft,
    priority: -5,
  );

  final double speed;

  @override
  Future<void> onLoad() async{
    sprite = await Sprite.load("obs1.png");
    scale.x = -1; 

    add(RectangleHitbox());
  }

  @override     
  void update(double dt){
    super.update(dt);
    x -= speed * dt;
    if (x + width <= 0){ 
    removeFromParent();
    gameRef.scoreIncrement();
    }
  }

}

class KryptoObstacle extends SpriteComponent with CollisionCallbacks, HasGameRef<FlyRun> {
  KryptoObstacle({required this.speed})
      : super(
          size: Vector2(_kryptoSize.$1, _kryptoSize.$2),
          anchor: Anchor.topLeft,
          priority: -5,
        );

  final double speed;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load("obs2.png");

     add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    x -= speed * dt;
    if (x + width <= 0){ removeFromParent();
      gameRef.scoreIncrement();

    }
  }
}

class ObstacleSpawner extends Component with HasGameRef<FlyRun> {
  ObstacleSpawner({
    this.spawnEvery = _spawnGap,
    this.baseSpeed  = _scrollSpeed,
    this.topMargin  = _topMargin,
    this.bottomMargin = _bottomMargin,
  });

  final double spawnEvery;
  final double baseSpeed;
  final double topMargin;
  final double bottomMargin;

  final _rng = math.Random();
  double _t = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
    if (_t >= spawnEvery) {
      _t = 0;

      // Spawn just off the right edge so it is hidden until it enters.
      final startX = gameRef.size.x + 10;

      // Pick a safe Y range
      final minY = topMargin;
      final maxY = gameRef.size.y - bottomMargin;
      final y = _rng.nextDouble() * (maxY - minY) + minY;

      // 50/50 which type (tweak if you want different ratio)
      final speed = baseSpeed + _rng.nextDouble() * 50; // small variation
      if (_rng.nextBool()) {
        final d = DinoObstacle(speed: speed)..position = Vector2(startX, y);
        gameRef.add(d);
      } else {
        final k = KryptoObstacle(speed: speed)..position = Vector2(startX, y);
        gameRef.add(k);
      }
    }
  }
}