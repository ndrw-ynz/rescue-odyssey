import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:rescue_odyssey/components/collision_block.dart';
import 'package:rescue_odyssey/components/warp_zone_block.dart';

import 'package:rescue_odyssey/entities/player.dart';

/// The [PreludeWorldState] enum contains the state of world of the prelude.
enum PreludeWorldState {
  woodenBoardingCottage,
  cottageHalls
}

///
/// [PreludeWorldManager] contains all of the worlds of the prelude chapter
/// of the game.
///
class PreludeWorldManager {
  late World preludeWoodenBoardingCottage;
  late World preludeCottageHalls;
  /// The current instance of the player of the game.
  Player player;
  /// The current state of the world of prelude.
  late PreludeWorldState currentWorldState;

  PreludeWorldManager({required this.player}) {
    currentWorldState = PreludeWorldState.woodenBoardingCottage;
}

  ///
  /// [loadWorlds] is a method that loads all of the worlds in prelude.
  ///
  void loadWorlds() {
    loadPreludeWoodenBoardingCottage();
    loadPreludeCottageHalls();
  }

  Future<void> loadPreludeWoodenBoardingCottage() async {
    preludeWoodenBoardingCottage = World();
    TiledComponent map = await TiledComponent.load('prelude_waldorf_woodenboardingcottage.tmx', Vector2.all(32));

    preludeWoodenBoardingCottage.add(map);

    addSpawnPoint(map, preludeWoodenBoardingCottage);
    addCollisions(map, preludeWoodenBoardingCottage);
    addWarpZones(map, preludeWoodenBoardingCottage);

  }

  Future<void> loadPreludeCottageHalls() async {
    preludeCottageHalls = World();
    TiledComponent map = await TiledComponent.load('prelude_waldorf_cottage_halls.tmx', Vector2.all(32));

    preludeCottageHalls.add(map);

    addCollisions(map, preludeCottageHalls);
    addWarpZones(map, preludeCottageHalls);
  }

  void addSpawnPoint(TiledComponent map, World world) {
    final spawnPointLayer = map.tileMap.getLayer<ObjectGroup>('Spawnpoint');
    if (spawnPointLayer != null) {
      for (final spawnPoint in spawnPointLayer.objects) {
        switch (spawnPoint.type) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            world.add(player);
            break;
          default:
            break;
        }
      }
    }
  }

  void addCollisions(TiledComponent map, World world) {
    final collisionLayer = map.tileMap.getLayer<ObjectGroup>('Collision');
    if (collisionLayer != null) {
      for (final collisionBlock in collisionLayer.objects) {
        final collision = CollisionBlock(
            position: Vector2(collisionBlock.x, collisionBlock.y),
            size: Vector2(collisionBlock.width, collisionBlock.height)
        );
        world.add(collision);
      }
    }
  }

  void addWarpZones(TiledComponent map, World world) {
    final warpZoneLayer = map.tileMap.getLayer<ObjectGroup>('Warp Zone');
    if (warpZoneLayer != null) {
      for (final warpZoneBlock in warpZoneLayer.objects) {
        final warpZone = WarpZoneBlock(
            position: Vector2(
                warpZoneBlock.x,
                warpZoneBlock.y
            ),
            size: Vector2(
                warpZoneBlock.width,
                warpZoneBlock.height
            ),
            warpTargetPoint: Vector2(
                warpZoneBlock.properties.getValue("targetX"),
                warpZoneBlock.properties.getValue("targetY")
            ),
            warpTargetWorld: warpZoneBlock.properties.getValue("targetWorld")
        );
        world.add(warpZone);
      }
    }
  }
}