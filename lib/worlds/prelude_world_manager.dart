import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'package:rescue_odyssey/entities/player.dart';

class PreludeWorldManager {
  late World preludeWoodenBoardingCottage;

  late World preludeCottageHalls;

  void loadWorlds(Player player) {
    loadPreludeWoodenBoardingCottage(player);
    loadPreludeCottageHalls(player);
  }

  Future<void> loadPreludeWoodenBoardingCottage(Player player) async {
    preludeWoodenBoardingCottage = World();
    TiledComponent map = await TiledComponent.load('prelude_waldorf_woodenboardingcottage.tmx', Vector2.all(32))
    ..debugMode = true;

    print('pre');
    preludeWoodenBoardingCottage.add(map);

    final spawnPointLayer = map.tileMap.getLayer<ObjectGroup>('Spawnpoint');
    if (spawnPointLayer != null) {
      for (final spawnPoint in spawnPointLayer.objects) {

        switch (spawnPoint.type) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            preludeWoodenBoardingCottage.add(player);
            break;
          default:
            break;
        }
      }
    }
  }

  Future<void> loadPreludeCottageHalls(Player player) async {
    preludeCottageHalls = World();
    TiledComponent map = await TiledComponent.load('prelude_waldorf_cottage_halls.tmx', Vector2.all(32));

    preludeCottageHalls.add(map);
   //preludeCottageHalls.add(player);
  }
}