import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:rescue_odyssey/worlds/world_manager.dart';

/// The [PreludeWorldState] enum contains the state of world of the prelude.
enum PreludeWorldState {
  woodenBoardingCottage,
  cottageHalls,
  extBoardingHouse,
  crossroads,
  extLibrary,
  intLibrary,
  archiveRoom,
  unknownDomain
}

///
/// [PreludeWorldManager] contains all of the worlds of the prelude chapter
/// of the game.
///
class PreludeWorldManager extends WorldManager {
  late World preludeWoodenBoardingCottage;
  late World preludeCottageHalls;
  late World preludeExtBoardingHouse;
  late World preludeCrossroads;
  late World preludeExtLibrary;
  late World preludeIntLibrary;
  late World preludeArchiveRoom;
  late World preludeUnknownDomain;

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
    loadPreludeExtBoardingHouse();
    loadPreludeCrossroads();
    loadPreludeExtLibrary();
    loadPreludeIntLibrary();
    loadPreludeArchiveRoom();
    loadPreludeUnknownDomain();
  }

  Future<void> loadPreludeWoodenBoardingCottage() async {
    preludeWoodenBoardingCottage = World();
    TiledComponent map = await TiledComponent.load('prelude_waldorf_woodenboardingcottage.tmx', Vector2.all(32));

    preludeWoodenBoardingCottage.add(map);

    addSpawnPoint(map, preludeWoodenBoardingCottage);
    addCollisions(map, preludeWoodenBoardingCottage);
    addWarpZones(map, preludeWoodenBoardingCottage);
    addInteractables(map, preludeWoodenBoardingCottage);
  }

  Future<void> loadPreludeCottageHalls() async {
    preludeCottageHalls = World();
    TiledComponent map = await TiledComponent.load('prelude_waldorf_cottage_halls.tmx', Vector2.all(32));

    preludeCottageHalls.add(map);

    addCollisions(map, preludeCottageHalls);
    addWarpZones(map, preludeCottageHalls);
  }

  Future<void> loadPreludeExtBoardingHouse() async {
    preludeExtBoardingHouse = World();
    TiledComponent map = await TiledComponent.load('prelude_ext_boardinghouse.tmx', Vector2.all(32));

    preludeExtBoardingHouse.add(map);

    addCollisions(map, preludeExtBoardingHouse);
    addWarpZones(map, preludeExtBoardingHouse);
  }

  Future<void> loadPreludeCrossroads() async {
    preludeCrossroads = World();
    TiledComponent map = await TiledComponent.load('prelude_ext_crossroads.tmx', Vector2.all(32));

    preludeCrossroads.add(map);

    addCollisions(map, preludeCrossroads);
    addWarpZones(map, preludeCrossroads);
  }

  Future<void> loadPreludeExtLibrary() async {
    preludeExtLibrary = World();
    TiledComponent map = await TiledComponent.load('prelude_ext_library.tmx', Vector2.all(32));

    preludeExtLibrary.add(map);

    addCollisions(map, preludeExtLibrary);
    addWarpZones(map, preludeExtLibrary);
  }

  Future<void> loadPreludeIntLibrary() async {
    preludeIntLibrary = World();
    TiledComponent map = await TiledComponent.load('prelude_int_library.tmx', Vector2.all(32));

    preludeIntLibrary.add(map);

    addCollisions(map, preludeIntLibrary);
    addWarpZones(map, preludeIntLibrary);
  }

  Future<void> loadPreludeArchiveRoom() async {
    preludeArchiveRoom = World();
    TiledComponent map = await TiledComponent.load('prelude_int_library_archiveroom.tmx', Vector2.all(32));

    preludeArchiveRoom.add(map);

    addCollisions(map, preludeArchiveRoom);
    addWarpZones(map, preludeArchiveRoom);
  }

  Future<void> loadPreludeUnknownDomain() async {
    preludeUnknownDomain = World();
    TiledComponent map = await TiledComponent.load('prelude_ext_unknowndomain.tmx', Vector2.all(32));

    preludeUnknownDomain.add(map);

    addCollisions(map, preludeUnknownDomain);
    // addWarpZones(map, preludeUnknownDomain);
  }

  @override
  World getCurrentWorld() {
    late World currentWorld;
    switch (currentWorldState) {
      case PreludeWorldState.woodenBoardingCottage: currentWorld = preludeWoodenBoardingCottage;
      case PreludeWorldState.cottageHalls: currentWorld = preludeCottageHalls;
      case PreludeWorldState.extBoardingHouse: currentWorld = preludeExtBoardingHouse;
      case PreludeWorldState.crossroads: currentWorld = preludeCrossroads;
      case PreludeWorldState.extLibrary: currentWorld = preludeExtLibrary;
      case PreludeWorldState.intLibrary: currentWorld = preludeIntLibrary;
      case PreludeWorldState.archiveRoom: currentWorld = preludeArchiveRoom;
      case PreludeWorldState.unknownDomain: currentWorld = preludeUnknownDomain;
    }
    return currentWorld;
  }
}