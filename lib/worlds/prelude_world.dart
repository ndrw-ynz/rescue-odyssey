import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'package:rescue_odyssey/entities/player.dart';
import 'package:rescue_odyssey/game/rescue_odyssey_game.dart';

/// A world containing the necessary components for the
/// Prelude chapter of the game.
class PreludeWorld extends World with HasGameRef<RescueOdysseyGame> {

  /// The component for the wooden boarding cottage map in prelude.
  late TiledComponent preludeWoodenBoardingCottage;
  /// The component for the cottage halls map in prelude.
  late TiledComponent preludeCottageHalls;
  /// The main player of the game.
  Player player;

  PreludeWorld({required this.player});

  @override
  Future<void> onLoad() async {
    // Load TiledComponents
    preludeWoodenBoardingCottage = await TiledComponent.load('prelude_waldorf_woodenboardingcottage.tmx', Vector2.all(32));

    preludeCottageHalls = await TiledComponent.load('prelude_waldorf_cottage_halls.tmx', Vector2.all(32));

    // Add as a component.
    add(preludeWoodenBoardingCottage);

    // Load player on spawnpoint.
    final spawnPointLayer = preludeWoodenBoardingCottage.tileMap.getLayer<ObjectGroup>('Spawnpoint');
    for (final spawnPoint in spawnPointLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          // create Player here
          // add(player);
          //player.position = Vector2(spawnPoint.x, spawnPoint.y);
          break;
        default:
          break;
      }
    }
  }
}