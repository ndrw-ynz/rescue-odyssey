import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

/// The base class of the game.
///
/// `RescueOdysseyGame` contains all of the components of the game.
class RescueOdysseyGame extends FlameGame {

  /// The component for the Joystick HUD displayed on the viewport of the camera.
  late final JoystickComponent joystick;

  @override
  Future<void> onLoad() async {
    final knobPaint = BasicPalette.lightGray.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.lightGray.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 25, paint: knobPaint),
      background: CircleComponent(radius: 90, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    // player = JoystickPlayer(joystick);

    // world.add(player);
    camera.viewport.add(joystick);
  }

}