import 'package:flame/components.dart';
import 'package:flame/effects.dart';
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
  bool isUsingJoystick = true;
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
  /// Determines whether player can move or not.
  bool canMove = false;
  /// Router component that routes to pages of the game.
  late final RouterComponent router;

  late final RectangleComponent transition;

  late final RectangleComponent startTransition;

  late Vector2 warpTargetPoint;

  bool gameHasLoaded = false;

  // TODO: maybe add func for changing world based on current enum state of CurrentChapterState

  @override
  Future<void> onLoad() async {
    _addStartTransition();
    // Load all images into cache
    await images.loadAllImages();

    // Adds router to other pages
    _addRouter();

    // Initialize late final variables.
    player = Player();
    preludeWorldManager = PreludeWorldManager(player: player);

    preludeWorldManager.loadWorlds();
    world = preludeWorldManager.getCurrentWorld();

    if(isUsingJoystick) {
      createJoystick();
    }

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



    debugMode = true;

    Future.delayed(const Duration(milliseconds: 500), () {
      dialogueBox = DialogueBox(dialogueProperty: "Starter");
      add(dialogueBox);
    });


    Future.delayed(const Duration(seconds: 2), () {
      startTransition.removeFromParent();
      _addTransitionEffect();
      Future.delayed(const Duration(milliseconds: 1500), (){
        gameHasLoaded = true;
      });

    });


  }

  @override
  update(double dt) {
    super.update(dt);

    // Update world for warping.
    if (isWarping) {
      transition.add(OpacityEffect.fadeIn(LinearEffectController(1.5)));
      world.remove(player);
      Future.delayed(const Duration(milliseconds: 1500), () {
        switch (chapterState) {
          case CurrentChapterState.prelude:
            world = preludeWorldManager.getCurrentWorld();
            if (!world.contains(player)) player.position = warpTargetPoint; world.add(player);
            break;
        }
        transition.add(OpacityEffect.fadeOut(LinearEffectController(0.1)));
        canMove = true;
      });


      isWarping = false;
      canMove = false;
      player.playerDirection = PlayerMovementState.none;
    }

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
  }

  ///
  /// The [_addRouter] method creates the router of the game.
  ///
  void _addRouter() {
    router = RouterComponent(initialRoute: 'start',
        routes: {
      'start' : Route(StartUpPage.new),
          'game' : Route(GameScreen.new),
          'paused' : Route(PausedScreen.new),
    });
    camera.viewport.add(router);
  }


  ///
  /// The [_addTransitionEffect] method creates the transition effect for scene changes in the game.
  ///
  void _addTransitionEffect() {
    transition = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.black,
      children: [OpacityEffect.fadeOut(LinearEffectController(1.5))],
    );
    camera.viewport.add(transition);
  }

  ///
  ///  The [_addStartTransition] method creates the black screen to load the assets of the game and transition to the main menu.
  ///
  void _addStartTransition() {
    startTransition = RectangleComponent(
      priority: 1,
      size: size,
      paint: Paint()..color = Colors.black,
    );
    camera.viewport.add(startTransition);
  }
}