import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:super_fly/game.dart';

class Ground extends SpriteComponent
    with HasGameRef<FlyRun>, CollisionCallbacks {
  Ground({required this.startX, this.speed = 80}) : super();

  final double startX;
  final double speed;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.topLeft;
    size = Vector2(gameRef.size.x, 80);
    position = Vector2(startX, gameRef.size.y - 145);
    sprite = await Sprite.load('ground.png');
    priority = -50;

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    position.x -= speed * dt;

    if (position.x + size.x <= 0) {
      position.x += size.x * 2;
    }
  }
}
