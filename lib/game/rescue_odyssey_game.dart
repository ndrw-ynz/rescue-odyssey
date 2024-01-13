import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import 'package:rescue_odyssey/entities/player.dart';
import 'package:rescue_odyssey/worlds/prelude_world.dart';
import 'package:rescue_odyssey/worlds/prelude_world_manager.dart';


/// The base class of the game.
///
/// `RescueOdysseyGame` contains all of the components of the game.
class RescueOdysseyGame extends FlameGame with HasCollisionDetection {

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  /// The component for the Joystick HUD displayed on the viewport of the camera.
  late final JoystickComponent joystick;

  late final CameraComponent cam;

  // Creates Player class called player
  late final Player player;

  late final PreludeWorld preludeWorld;

  final PreludeWorldManager preludeWorldManager = PreludeWorldManager();

  @override
  Future<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    // Create preludeWorld
    player = Player();
    preludeWorldManager.loadWorlds(player);
    world = preludeWorldManager.preludeWoodenBoardingCottage
    ..debugMode = true;

    // dimension should be fixed
    // display of worlds should be fixed (no scaling)
    // camera = CameraComponent.withFixedResolution(
    //   height: 420,
    //   width: 620,
    //   world: world
    // );
    createJoystick();

    // cant do this w follow
    //camera.moveTo(Vector2(320 * 0.5, camera.viewport.virtualSize.y * 0.5));

    camera.follow(player);
    // camera.setBounds(Rectangle.fromLTWH(0, 0, 320, 320));
  }

  @override
  void update(double dt) {
    updateJoystick();
    super.update(dt);
  }

  /// Creates the joystick for the game
  void createJoystick() {
    final knobPaint = BasicPalette.lightGray.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.lightGray.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 25, paint: knobPaint),
      background: CircleComponent(radius: 90, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    camera.viewport.add(joystick);
  }

  /// Updates the direction of player when joystick is moved
  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.down:
        player.playerDirection = PlayerDirection.down;
        break;
      case JoystickDirection.up:
        player.playerDirection = PlayerDirection.up;
        break;
      case JoystickDirection.left:
        player.playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.right:
        player.playerDirection = PlayerDirection.right;
        break;
      case JoystickDirection.downLeft:
        player.playerDirection = PlayerDirection.downLeft;
        break;
      case JoystickDirection.downRight:
        player.playerDirection = PlayerDirection.downRight;
        break;
      case JoystickDirection.upLeft:
        player.playerDirection = PlayerDirection.upLeft;
        break;
      case JoystickDirection.upRight:
        player.playerDirection = PlayerDirection.upRight;
        break;
      default:
        player.playerDirection = PlayerDirection.none;
        break;
    }
  }
}