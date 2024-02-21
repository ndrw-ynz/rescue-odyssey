import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:rescue_odyssey/game/rescue_odyssey_game.dart';

class PausedScreen extends Component with HasGameRef<RescueOdysseyGame>{

  late RectangleComponent transparentBackground;
  
  late TextBoxComponent pausedText;
  
  late RectangleComponent resumeBox;
  late RectangleComponent saveBox;
  late RectangleComponent quitBox;

  late ButtonComponent resume;
  late ButtonComponent save;
  late ButtonComponent quitToMainMenu;
  int spacing = 100;

  final textRenderer = TextPaint(style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white, decorationColor: Colors.yellow));

  @override
  FutureOr<void> onLoad() {
    _addPauseOverlays();
    return super.onLoad();
  }


  void _addPauseOverlays() {
    game.canMove = false;

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
      position: Vector2(pausedText.x + (pausedText.x * 0.13), pausedText.y + spacing + 30),
      size: Vector2(215, 56),
      paint: Paint()..color = const Color(0xFF000000),
    );

    saveBox = RectangleComponent(
      position: Vector2(pausedText.x + (pausedText.x * 0.13), resumeBox.y + spacing),
      size: Vector2(215, 56),
      paint: Paint()..color = const Color(0xFF000000),
    );

    quitBox = RectangleComponent(
      position: Vector2(pausedText.x + (pausedText.x * 0.13), saveBox.y + spacing),
      size: Vector2(215, 56),
      paint: Paint()..color = const Color(0xFF000000),
    );

    resume = ButtonComponent(
      // position: Vector2(pausedText.x + (pausedText.x * 0.13), pausedText.y + spacing + 30),
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
          gameRef.router.pushNamed('start');
        }
    );


    resumeBox.add(resume);
    saveBox.add(save);
    quitBox.add(quitToMainMenu);
    addAll([transparentBackground,pausedText,resumeBox,saveBox,quitBox]);
  }
}