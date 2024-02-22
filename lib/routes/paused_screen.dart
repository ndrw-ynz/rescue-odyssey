import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:rescue_odyssey/game/rescue_odyssey_game.dart';

class PausedScreen extends Component with HasGameRef<RescueOdysseyGame>{

  /// The transparent black background of the pause screen.
  late RectangleComponent transparentBackground;
  /// The text that shows PAUSED in the middle of the screen.
  late TextBoxComponent pausedText;

  /// The resume button to start the game.
  late ButtonComponent resume;
  /// The save button to start the game.
  late ButtonComponent save;
  /// The quit to main menu button to start the game.
  late ButtonComponent quitToMainMenu;

  /// Box design for the resume button.
  late RectangleComponent resumeBox;
  /// Box design for the save button.
  late RectangleComponent saveBox;
  /// Box design for the quit button.
  late RectangleComponent quitBox;

  /// Vertical spacing of each button.
  int verticalSpacing = 100;

  /// Text renderer to design text.
  final textRenderer = TextPaint(style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white, decorationColor: Colors.yellow));

  @override
  FutureOr<void> onLoad() {
    _addPauseOverlays();
    return super.onLoad();
  }


  void _addPauseOverlays() {
    transparentBackground = RectangleComponent(
      size: gameRef.size,
      paint: Paint()..color = const Color(0xAA000000),
    );

    pausedText = TextBoxComponent(
        position: Vector2(gameRef.size.x /3, gameRef.size.x * 0.06),
        size: Vector2(300, 100),
        textRenderer: TextPaint(style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white)),
        text: 'Paused',
        align: Anchor.center
    );

    resumeBox = RectangleComponent(
      position: Vector2(pausedText.x + (pausedText.x * 0.13), pausedText.y + verticalSpacing + 30),
      size: Vector2(215, 56),
      paint: Paint()..color = const Color(0xFF000000),
    );

    saveBox = RectangleComponent(
      position: Vector2(pausedText.x + (pausedText.x * 0.13), resumeBox.y + verticalSpacing),
      size: Vector2(215, 56),
      paint: Paint()..color = const Color(0xFF000000),
    );

    quitBox = RectangleComponent(
      position: Vector2(pausedText.x + (pausedText.x * 0.13), saveBox.y + verticalSpacing),
      size: Vector2(215, 56),
      paint: Paint()..color = const Color(0xFF000000),
    );

    resume = ButtonComponent(
      // position: Vector2(pausedText.x + (pausedText.x * 0.13), pausedText.y + verticalSpacing + 30),
        button: TextBoxComponent(
            textRenderer: textRenderer,
            text: 'Resume',
            align: Anchor.center),
        onPressed: (){
          gameRef.router.pushNamed('game');
          game.canMove = true;
        }
    );

    save = ButtonComponent(
        button: TextBoxComponent(
            textRenderer: textRenderer,
            text: 'Save',
            align: Anchor.center),
        onPressed: (){
          debugPrint("Save");
        }
    );

    quitToMainMenu = ButtonComponent(
        button: TextBoxComponent(
            textRenderer: textRenderer,
            text: 'Quit',
            align: Anchor.center),
        onPressed: (){
          game.transition.add(OpacityEffect.fadeIn(LinearEffectController(1.5)));

          Future.delayed(const Duration(milliseconds: 1500), ()
          {
            gameRef.router.pushNamed('start');
            game.transition.add(OpacityEffect.fadeOut(LinearEffectController(0.1)));
          });
        }
    );


    resumeBox.add(resume);
    saveBox.add(save);
    quitBox.add(quitToMainMenu);
    addAll([transparentBackground,pausedText,resumeBox,saveBox,quitBox]);
  }
}