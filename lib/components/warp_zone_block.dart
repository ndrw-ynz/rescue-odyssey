import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import 'package:rescue_odyssey/entities/player.dart';
import 'package:rescue_odyssey/game/rescue_odyssey_game.dart';
import 'package:rescue_odyssey/worlds/prelude_world_manager.dart';

///
/// [WarpZoneBlock] serves as a component for implementing warps in maps.
///
/// This class extends [PositionComponent].
///
class WarpZoneBlock extends PositionComponent with CollisionCallbacks, HasGameReference<RescueOdysseyGame> {
  /// The hitbox used for collision detection in maps.
  late final RectangleHitbox hitBox;
  /// The target point for where a player warps on the new world.
  Vector2 warpTargetPoint;
  /// The target world for where a player warps.
  late PreludeWorldState warpTargetWorld;

  WarpZoneBlock({position, size, required this.warpTargetPoint, required warpTargetWorld}) : super(position: position, size: size) {
    // Assign associated PreludeWorldState enum for each associated file_name in file.
    switch (warpTargetWorld) {
      case "prelude_waldorf_woodenboardingcottage": this.warpTargetWorld = PreludeWorldState.woodenBoardingCottage;
      case "prelude_waldorf_cottage_halls": this.warpTargetWorld = PreludeWorldState.cottageHalls;
    }
  }

  @override
  Future<void> onLoad() async {
    hitBox = RectangleHitbox(
        isSolid: true,
        collisionType: CollisionType.passive
    );
    add(hitBox);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      // TODO: modify the code st logic is implemented in base game.
      game.isWarping = true;
      game.switchPreludeWorld(warpTargetWorld, warpTargetPoint);

      // // Remove player first.
      // game.world.remove(other);
      // // Change world
      // switch (warpTargetWorld) {
      //   case PreludeWorldState.woodenBoardingCottage:
      //     game.world = game.preludeWorldManager.preludeWoodenBoardingCottage;
      //     break;
      //   case PreludeWorldState.cottageHalls:
      //     game.world = game.preludeWorldManager.preludeCottageHalls;
      //     break;
      // }
      // // Change position of player.
      // other.position = warpTargetPoint;
      // // Add player
      // game.world.add(other);

    }
  }
}