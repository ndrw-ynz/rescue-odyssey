import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import 'package:rescue_odyssey/entities/player.dart';

import 'package:rescue_odyssey/game/rescue_odyssey_game.dart';

///
/// [InteractableBlock] serves as a component for recording collisions in maps.
///
/// This class extends [PositionComponent].
///
class InteractableBlock extends PositionComponent with CollisionCallbacks, HasGameReference<RescueOdysseyGame>  {
  /// The hitbox used for collision detection in maps.
  late final RectangleHitbox hitBox;

  String interactableDialogue;

  InteractableBlock({required position, required size, required this.interactableDialogue}) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    hitBox = RectangleHitbox(
      isSolid: true,
      collisionType: CollisionType.passive,
    );
    add(hitBox);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player && intersectionPoints.length == 2) {

    }
  }
}