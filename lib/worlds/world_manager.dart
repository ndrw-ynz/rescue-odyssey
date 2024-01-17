import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:rescue_odyssey/components/collision_block.dart';
import 'package:rescue_odyssey/components/interactable_block.dart';
import 'package:rescue_odyssey/components/warp_zone_block.dart';

import 'package:rescue_odyssey/entities/player.dart';

abstract class WorldManager {
  /// The current instance of the player of the game.
  Player player;

  WorldManager({required this.player});

  void addSpawnPoint(TiledComponent map, World world) {
    final spawnPointLayer = map.tileMap.getLayer<ObjectGroup>('Spawnpoint');
    if (spawnPointLayer != null) {
      for (final spawnPoint in spawnPointLayer.objects) {
        // TODO: maybe in the future, delegate logic to base game.
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

  void addInteractables(TiledComponent map, World world) {
    final interactableLayer = map.tileMap.getLayer<ObjectGroup>('Interactable');
    if (interactableLayer != null) {
      for (final interactableObject in interactableLayer.objects) {
        final interactable = InteractableBlock(
          position: Vector2(
              interactableObject.x,
              interactableObject.y
          ),
          size: Vector2(
              interactableObject.width,
              interactableObject.height
          ),
          interactableDialogue: interactableObject.properties.getValue("dialogue")
        );
        world.add(interactable);
      }
    }
  }

  World getCurrentWorld();

}