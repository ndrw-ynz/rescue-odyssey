import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:rescue_odyssey/components/dialogue_box.dart';

import 'package:rescue_odyssey/entities/player.dart';
import 'package:rescue_odyssey/routes/game_screen.dart';
import 'package:rescue_odyssey/routes/paused_screen.dart';
import 'package:rescue_odyssey/worlds/prelude_world_manager.dart';

import '../routes/start_up.dart';

/// The [CurrentChapterState] enum contains the available chapters of the game.
enum CurrentChapterState {
  prelude
}

///
/// [RescueOdysseyGame] contains all of the main components of the game.
///
/// This class extends [FlameGame] and adds the [HasCollisionDetection] and [KeyBoardEvents] mixins.
///
class RescueOdysseyGame extends FlameGame with HasCollisionDetection, KeyboardEvents {
  /// The component for the Joystick HUD displayed on the viewport of the camera.
  late final JoystickComponent joystick;
  /// The component that views the worlds of the game.
  late final CameraComponent cam;
  /// The player of the game.
  late final Player player;
  /// A manager that stores data about worlds used for the prelude of the game.
  late final PreludeWorldManager preludeWorldManager;
  /// A boolean value that enables and disables joystick usage.
  bool isUsingJoystick = false;
  /// Contains the current chapter state of the game.
  CurrentChapterState chapterState = CurrentChapterState.prelude;
  /// A boolean value that keeps track of warping events occurring in game.
  bool isWarping = false;
  /// Checks if dialogue is ongoing.
  bool isOnDialogue = false;
  /// Checks if the whole dialogue is finished.
  bool isDialogueFinished = true;
  /// Stores the dialogue's property from tiled to be read in [DialogueBox].
  String dialogueProperty = '';
  /// Creates a [DialogueBox] class for later use.
  late DialogueBox dialogueBox ;




  bool canMove = false;

  late final RouterComponent router;

  // TODO: maybe add func for changing world based on current enum state of CurrentChapterState

  @override
  Future<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();
    dialogueBox = DialogueBox(dialogueProperty: "Starter");
    camera.viewport.add(dialogueBox);


    _addRouter();
    // _addButtons();

    // Initialize late final variables.
    player = Player();
    preludeWorldManager = PreludeWorldManager(player: player);

    preludeWorldManager.loadWorlds();
    world = preludeWorldManager.getCurrentWorld();


    // NOTE: ADDING SHOULD BE MADE ON THE SAME FUNCTION BODY TO AVOID CONCURRENCY BS.
    //world.add(player);

    // dimension should be fixed
    // display of worlds should be fixed (no scaling)
    // camera = CameraComponent.withFixedResolution(
    //   height: 420,
    //   width: 620,
    //   world: world
    // );

    // cant do this w follow
    //camera.moveTo(Vector2(320 * 0.5, camera.viewport.virtualSize.y * 0.5));

    camera.follow(player);
    // camera.setBounds(Rectangle.fromLTWH(0, 0, 320, 320));

    // If isUsingJoystick is set to true, enable joystick
    if(isUsingJoystick) {
      createJoystick();
    }

    debugMode = true;
  }

  @override
  update(double dt) {

    super.update(dt);
    // Updates character movement using joystick if it is enabled and keyboard controls is disabled
    if (isUsingJoystick && isDialogueFinished && canMove) {
      if(!camera.viewport.contains(joystick)){
        camera.viewport.add(joystick);
      }
      updateJoystick();
    }


    // Update world for warping.
    if (isWarping) {
      switch (chapterState) {
        case CurrentChapterState.prelude:
          world = preludeWorldManager.getCurrentWorld();
          if (!world.contains(player)) world.add(player);
          break;
      }
      isWarping = false;
    }



    if(isOnDialogue){
      player.playerDirection = PlayerMovementState.none;
      dialogueBox = DialogueBox(dialogueProperty: dialogueProperty);
      if(!camera.viewport.contains(dialogueBox)) {
        camera.viewport.add(dialogueBox);
        debugPrint("Dialogue box added");
        if(isUsingJoystick) {
          joystick.removeFromParent();
          debugPrint("Joystick was removed");
        }
      }
      isOnDialogue = false;
    }
    // debugPrint(isDialogueFinished.toString());
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final down = keysPressed.contains(LogicalKeyboardKey.keyS) || keysPressed.contains(LogicalKeyboardKey.arrowDown);
    final up = keysPressed.contains(LogicalKeyboardKey.keyW) || keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final left = keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final right = keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if(canMove){
      if (left && down && right) {
        player.playerDirection = PlayerMovementState.down;
      } else if (left && up && right) {
        player.playerDirection = PlayerMovementState.up;
      } else if ((down && up) || (left && right)) {
        player.playerDirection = PlayerMovementState.none;
      }else if(down && left) {
        player.playerDirection = PlayerMovementState.downLeft;
      }else if(down && right) {
        player.playerDirection = PlayerMovementState.downRight;
      } else if(up && left) {
        player.playerDirection = PlayerMovementState.upLeft;
      } else if(up && right) {
        player.playerDirection = PlayerMovementState.upRight;
      } else if(down) {
        player.playerDirection = PlayerMovementState.down;
      } else if(up) {
        player.playerDirection = PlayerMovementState.up;
      } else if(left) {
        player.playerDirection = PlayerMovementState.left;
      } else if(right) {
        player.playerDirection = PlayerMovementState.right;
      } else {
        player.playerDirection = PlayerMovementState.none;
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }

  // Color backgroundColor() => const Color(0x00000000);

  ///
  /// The [createJoystick] method creates the joystick of the game.
  ///
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

  ///
  /// The [updateJoystick] method updates the [PlayerMovementState] state of the Player.
  /// upon the movement of the joystick.
  ///
  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.down:
        player.playerDirection = PlayerMovementState.down;
        break;
      case JoystickDirection.up:
        player.playerDirection = PlayerMovementState.up;
        break;
      case JoystickDirection.left:
        player.playerDirection = PlayerMovementState.left;
        break;
      case JoystickDirection.right:
        player.playerDirection = PlayerMovementState.right;
        break;
      case JoystickDirection.downLeft:
        player.playerDirection = PlayerMovementState.downLeft;
        break;
      case JoystickDirection.downRight:
        player.playerDirection = PlayerMovementState.downRight;
        break;
      case JoystickDirection.upLeft:
        player.playerDirection = PlayerMovementState.upLeft;
        break;
      case JoystickDirection.upRight:
        player.playerDirection = PlayerMovementState.upRight;
        break;
      default:
        player.playerDirection = PlayerMovementState.none;
        break;
    }
  }

  void _addRouter() {
    router = RouterComponent(initialRoute: 'start',
        routes: {
      'start' : Route(StartUpPage.new),
          'game' : Route(GameScreen.new),
          'paused' : Route(PausedScreen.new),
    });
    camera.viewport.add(router);
  }


}