import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:rescue_odyssey/components/dialogue_box.dart';
import 'package:rescue_odyssey/entities/player.dart';
import 'package:rescue_odyssey/game/rescue_odyssey_game.dart';

//Just a blank screen since it is very hard to transfer the game here lol, very complicated
class GameScreen extends Component with HasGameRef<RescueOdysseyGame>{
  /// The pause button of the game.
  late ButtonComponent pauseButton;

  @override
  FutureOr<void> onLoad() {
    _addButtons();
    // If isUsingJoystick is set to true, enable joystick
    if(gameRef.isUsingJoystick && gameRef.canMove) {
      game.camera.viewport.add(game.joystick);
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Updates character movement using joystick if it is enabled and keyboard controls is disabled
    if (gameRef.isUsingJoystick && gameRef.isDialogueFinished && gameRef.canMove) {
      if(!gameRef.camera.viewport.contains(game.joystick)){
        gameRef.camera.viewport.add(game.joystick);
      }
      updateJoystick();
    }

    if(gameRef.isOnDialogue){
      game.player.playerDirection = PlayerMovementState.none;
      gameRef.dialogueBox = DialogueBox(dialogueProperty: gameRef.dialogueProperty);
      if(!game.camera.viewport.contains(gameRef.dialogueBox)) {
        game.camera.viewport.add(gameRef.dialogueBox);
        debugPrint("Dialogue box added");
        if(gameRef.isUsingJoystick) {
          game.joystick.removeFromParent();
          debugPrint("Joystick was removed");
        }
      }
      gameRef.isOnDialogue = false;
    }
  }

  ///
  /// The [_addButtons] method adds all buttons for the game.
  void _addButtons() async{
    final pauseImage = await Flame.images.load('logos/pause_btn_logo.png');
    pauseButton = ButtonComponent(
        position: Vector2(15, 15),
        button: SpriteComponent.fromImage(pauseImage, size: Vector2(50,50)),
        onPressed: (){
          if(gameRef.isUsingJoystick) {
            game.joystick.removeFromParent();
            debugPrint("Joystick was removed");
          }
          game.player.playerDirection = PlayerMovementState.none;
          game.canMove = false;
          gameRef.router.pushNamed('paused');
        }
    );
   add(pauseButton);
  }


  ///
  /// The [updateJoystick] method updates the [PlayerMovementState] state of the Player.
  /// upon the movement of the joystick.
  ///
  void updateJoystick() {
    switch (game.joystick.direction) {
      case JoystickDirection.down:
        game.player.playerDirection = PlayerMovementState.down;
        break;
      case JoystickDirection.up:
        game.player.playerDirection = PlayerMovementState.up;
        break;
      case JoystickDirection.left:
        game.player.playerDirection = PlayerMovementState.left;
        break;
      case JoystickDirection.right:
        game.player.playerDirection = PlayerMovementState.right;
        break;
      case JoystickDirection.downLeft:
        game.player.playerDirection = PlayerMovementState.downLeft;
        break;
      case JoystickDirection.downRight:
        game.player.playerDirection = PlayerMovementState.downRight;
        break;
      case JoystickDirection.upLeft:
        game.player.playerDirection = PlayerMovementState.upLeft;
        break;
      case JoystickDirection.upRight:
        game.player.playerDirection = PlayerMovementState.upRight;
        break;
      default:
        game.player.playerDirection = PlayerMovementState.none;
        break;
    }
  }
}