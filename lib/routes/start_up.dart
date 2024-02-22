import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:rescue_odyssey/game/rescue_odyssey_game.dart';
import 'package:flutter/rendering.dart';

class StartUpPage extends Component with HasGameRef<RescueOdysseyGame>{

  /// The background of the main menu.
  late SpriteComponent background;

  /// The start button to start the game.
  late ButtonComponent startButton;
  /// The load button to load the game's save file.
  late ButtonComponent loadButton;
  /// The credits button to see credits for the game's developers.
  late ButtonComponent creditsButton;

  /// Box design for the startButton.
  late RectangleComponent startBox;
  /// Box design for the load button.
  late RectangleComponent loadBox;
  /// Box design for the credits button.
  late RectangleComponent creditsBox;

  /// Text renderer to design text.
  final textRenderer = TextPaint(style: const TextStyle(fontSize: 25, color: Colors.white));

  /// Horizontal horizontalSpacing for each boxes.
  int horizontalSpacing = 250;

  @override
  FutureOr<void> onLoad() {
    game.canMove = false;
    _addStartUpPage();
    return super.onLoad();
  }

  ///
  /// The [_addStartUpPage] method adds all elements to the start up page.
  void _addStartUpPage() async{
    final backgroundImage = await Flame.images.load('backgrounds/main_menu_background.png');
    background = SpriteComponent.fromImage(backgroundImage, size: gameRef.size);
    add(background);


    startBox = RectangleComponent(
      position: Vector2(gameRef.size.x * 0.2, gameRef.size.y * 0.7),
      size: Vector2(160, 56),
      paint: Paint()..color = const Color(0xFF006400),
    );

    loadBox = RectangleComponent(
      position: Vector2(startBox.x + horizontalSpacing, startBox.y),
      size: Vector2(160, 56),
      paint: Paint()..color = const Color(0xFF006400),
    );

    creditsBox = RectangleComponent(
      position: Vector2(loadBox.x + horizontalSpacing, startBox.y),
      size: Vector2(160, 56),
      paint: Paint()..color = const Color(0xFF006400),
    );


    startButton = ButtonComponent(
      button: TextBoxComponent(textRenderer: textRenderer, text: 'Start', align: Anchor.center, size: startBox.size), onPressed: () {
      if (game.gameHasLoaded) {
        game.transition.add(OpacityEffect.fadeIn(LinearEffectController(1.5)));

        Future.delayed(const Duration(milliseconds: 1500), () {
          gameRef.router.pushNamed('game');
          game.canMove = true;
          game.transition.add(OpacityEffect.fadeOut(LinearEffectController(0.1)));
        });
      }
    }
    );

    loadButton = ButtonComponent(
        button: TextBoxComponent(textRenderer: textRenderer, text: 'Load', align: Anchor.center, size: startBox.size), onPressed: (){
      debugPrint("LOAD");
    }
    );

    creditsButton = ButtonComponent(
        button: TextBoxComponent(textRenderer: textRenderer, text: 'Credits', align: Anchor.center, size: startBox.size), onPressed: (){
      debugPrint("CREDITS");
    }
    );


    debugPrint(startBox.position.x.toString());
    debugPrint(startBox.position.x.toString());
    debugPrint(loadBox.position.x.toString());
    debugPrint(creditsBox.position.x.toString());

    startBox.add(startButton);
    loadBox.add(loadButton);
    creditsBox.add(creditsButton);
    addAll([background,startBox,loadBox,creditsBox]);
  }
}
