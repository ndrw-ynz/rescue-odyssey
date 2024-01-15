import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:rescue_odyssey/worlds/world_manager.dart';

/// The [PreludeWorldState] enum contains the state of world of the prelude.
enum PreludeWorldState {
  woodenBoardingCottage,
  cottageHalls
}

///
/// [PreludeWorldManager] contains all of the worlds of the prelude chapter
/// of the game.
///
class PreludeWorldManager extends WorldManager {
  late World preludeWoodenBoardingCottage;
  late World preludeCottageHalls;

  /// The current state of the world of prelude.
  late PreludeWorldState currentWorldState;

  PreludeWorldManager({required player}) : super(player: player) {
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

  @override
  World getCurrentWorld() {
    late World currentWorld;
    switch (currentWorldState) {
      case PreludeWorldState.woodenBoardingCottage: currentWorld = preludeWoodenBoardingCottage;
      case PreludeWorldState.cottageHalls: currentWorld = preludeCottageHalls;
    }
    return currentWorld;
  }
}