import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import 'package:rescue_odyssey/entities/player.dart';
import 'package:rescue_odyssey/worlds/prelude_world.dart';

/// The base class of the game.
///
/// `RescueOdysseyGame` contains all of the components of the game.
class RescueOdysseyGame extends FlameGame {

  /// The component for the Joystick HUD displayed on the viewport of the camera.
  late final JoystickComponent joystick;
  // Creates Player class called player
  final player = Player();

  late final PreludeWorld preludeWorld;

  @override
  Future<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    // Create preludeWorld
    preludeWorld = PreludeWorld(player: player);

    // Switch world
    world = preludeWorld;
    world.add(player);

    createJoystick();
    camera.follow(player);

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
    // player = JoystickPlayer(joystick);
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