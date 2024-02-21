import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:rescue_odyssey/game/rescue_odyssey_game.dart';

//Just a blank screen since it is very hard to transfer the game here lol, very complicated
class GameScreen extends Component with HasGameRef<RescueOdysseyGame>{

  late ButtonComponent pauseButton;

  @override
  FutureOr<void> onLoad() {
    game.canMove = true;
    _addButtons();
    return super.onLoad();
  }

  void _addButtons() async{
    final pauseImage = await Flame.images.load('logos/pause_btn_logo.png');
    pauseButton = ButtonComponent(
        position: Vector2(15, 15),
        button: SpriteComponent.fromImage(pauseImage, size: Vector2(50,50)),
        onPressed: (){
          gameRef.router.pushNamed('paused');
        }
    );
   add(pauseButton);
  }
}