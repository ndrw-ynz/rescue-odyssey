import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame/text.dart';
import 'package:rescue_odyssey/game/rescue_odyssey_game.dart';
import 'package:flutter/rendering.dart';

class StartUpPage extends Component with HasGameRef<RescueOdysseyGame>{
  late TextComponent title;
  late ButtonComponent playButton;
  late ButtonComponent loadButton;
  late ButtonComponent creditsButton;
  late ButtonComponent quitButton;

  late RectangleComponent playBox;

  late RectangleComponent loadBox;

  late RectangleComponent creditsBox;

  late RectangleComponent quitBox;

  late SpriteComponent background;

  int spacing = 180;
  @override
  FutureOr<void> onLoad() {
    game.canMove = false;
    _addStartUpPage();
    return super.onLoad();
  }


  void _addStartUpPage() async{
    final backgroundImage = await Flame.images.load('backgrounds/main_menu_background.png');
    background = SpriteComponent.fromImage(backgroundImage, size: gameRef.size);
    add(background);


    playBox = RectangleComponent(
      position: Vector2(gameRef.size.x * 0.1, gameRef.size.y * 0.7),
      size: Vector2(160, 56),
      paint: Paint()..color = const Color(0xFF000000),
    );

    loadBox = RectangleComponent(
      position: Vector2(playBox.x + spacing, playBox.y),
      size: Vector2(160, 56),
      paint: Paint()..color = const Color(0xFF000000),
    );

    creditsBox = RectangleComponent(
      position: Vector2(loadBox.x + spacing, playBox.y),
      size: Vector2(160, 56),
      paint: Paint()..color = const Color(0xFF000000),
    );

    quitBox = RectangleComponent(
      position: Vector2(creditsBox.x + spacing, playBox.y),
      size: Vector2(160, 56),
      paint: Paint()..color = const Color(0xFF000000),
    );

    playButton = ButtonComponent(
      button: TextBoxComponent(text: 'Text', align: Anchor.center, size: playBox.size), onPressed: (){
        gameRef.router.pushNamed('game');
      }
    );

    loadButton = ButtonComponent(
        button: TextBoxComponent(text: 'Text', align: Anchor.center, size: playBox.size), onPressed: (){
      debugPrint("LOAD");
    }
    );

    creditsButton = ButtonComponent(
        button: TextBoxComponent(text: 'Text', align: Anchor.center, size: playBox.size), onPressed: (){
      debugPrint("CREDITS");
    }
    );

    quitButton = ButtonComponent(
        button: TextBoxComponent(text: 'Text', align: Anchor.center, size: playBox.size), onPressed: (){
      debugPrint("QUIT");
    }
    );

    debugPrint(playBox.position.x.toString());
    debugPrint(playBox.position.x.toString());

    debugPrint(loadBox.position.x.toString());
    debugPrint(creditsBox.position.x.toString());
    debugPrint(quitBox.position.x.toString());


    playBox.add(playButton);
    loadBox.add(loadButton);
    creditsBox.add(creditsButton);
    quitBox.add(quitButton);
    addAll([background,playBox,loadBox,creditsBox,quitBox]);
  }
}
