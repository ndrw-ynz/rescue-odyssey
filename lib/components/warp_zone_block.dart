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
      case "prelude_ext_boardinghouse": this.warpTargetWorld = PreludeWorldState.extBoardingHouse;
      case "prelude_ext_crossroads": this.warpTargetWorld = PreludeWorldState.crossroads;
      case "prelude_ext_library": this.warpTargetWorld = PreludeWorldState.extLibrary;
      case "prelude_int_library": this.warpTargetWorld = PreludeWorldState.intLibrary;
      case "prelude_int_library_archiveroom": this.warpTargetWorld = PreludeWorldState.archiveRoom;
    }
  }

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
    if (other is Player) {
      game.isWarping = true;
      game.preludeWorldManager.currentWorldState = warpTargetWorld;
      game.player.position = warpTargetPoint;
    }
  }
}