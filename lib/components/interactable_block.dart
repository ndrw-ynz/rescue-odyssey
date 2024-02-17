import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:rescue_odyssey/components/dialogue_box.dart';

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
  /// The dialogue property to be read as a node in object dialogues yarn file
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
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    debugPrint("intersectionPoints: ${intersectionPoints.length.toString()}");

    if (other is Player && intersectionPoints.isNotEmpty) {
      game.isOnDialogue = true;
      game.dialogueProperty = interactableDialogue;
      game.isDialogueFinished = false;

      debugPrint("");
      debugPrint("isOnDialogue: ${game.isOnDialogue}");
      debugPrint("dialogueProperty: ${game.dialogueProperty}");
      debugPrint("isDialogueFinished: ${game.isDialogueFinished}");
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    game.isDialogueFinished = true;
    super.onCollisionEnd(other);
  }
}