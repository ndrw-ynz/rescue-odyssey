import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class CollisionBlock extends PositionComponent {

  late final RectangleHitbox hitBox;

  CollisionBlock({position, size}) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    hitBox = RectangleHitbox(
      isSolid: true,
      collisionType: CollisionType.passive
    );
    add(hitBox);
  }
}