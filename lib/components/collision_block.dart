import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

///
/// [CollisionBlock] serves as a component for recording collisions in maps.
///
/// This class extends [PositionComponent].
///
class CollisionBlock extends PositionComponent {
  /// The hitbox used for collision detection in maps.
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