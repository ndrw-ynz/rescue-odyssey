import 'package:flame/components.dart';
import 'dart:async';
import 'package:rescue_odyssey/game/rescue_odyssey_game.dart';

// Created player states
enum PlayerState {idle, idleFaceBack, idleFaceFront, idleFaceLeft, idleFaceRight, runningBack, runningFront, runningLeft, runningRight}

// Created all directions for movement of the player
enum PlayerDirection {none, down, up, left, right, downLeft, downRight, upLeft, upRight}

/// The Player Class
///
/// Contains animations, and movements of the player
class Player extends SpriteAnimationGroupComponent
    with HasGameRef<RescueOdysseyGame>{

  /// Player idle states
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation backIdleAnimation;
  late final SpriteAnimation frontIdleAnimation;
  late final SpriteAnimation leftIdleAnimation;
  late final SpriteAnimation rightIdleAnimation;

  /// Player walking animations
  late final SpriteAnimation backWalkAnimation;
  late final SpriteAnimation frontWalkAnimation;
  late final SpriteAnimation leftWalkAnimation;
  late final SpriteAnimation rightWalkAnimation;

  /// Last current position, used for idle states.
  late var currentPosition = 'Front';

  /// States how fast the animation moves.
  final double stepTime = 0.20;

  /// Player movement speed
  double movementSpeed = 150;

  PlayerDirection playerDirection = PlayerDirection.none;
  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  // \/ Methods \/
  /// A method that loads all animations for character movement
  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('arturo_bird_front_walk_anim.png', 1);
    backIdleAnimation = _spriteAnimation('arturo_bird_back_walk_anim.png', 1);
    frontIdleAnimation = _spriteAnimation('arturo_bird_front_walk_anim.png', 1);
    leftIdleAnimation = _spriteAnimation('arturo_bird_left_walk_anim.png', 1);
    rightIdleAnimation = _spriteAnimation('arturo_bird_right_walk_anim.png', 1);
    backWalkAnimation = _spriteAnimation('arturo_bird_back_walk_anim.png', 4);
    frontWalkAnimation = _spriteAnimation('arturo_bird_front_walk_anim.png', 4);
    leftWalkAnimation = _spriteAnimation('arturo_bird_left_walk_anim.png', 4);
    rightWalkAnimation = _spriteAnimation('arturo_bird_right_walk_anim.png', 4);

    //List of all animations
    animations = {
      PlayerState.idle : idleAnimation,
      PlayerState.idleFaceBack : backIdleAnimation,
      PlayerState.idleFaceFront : frontIdleAnimation,
      PlayerState.idleFaceLeft : leftIdleAnimation,
      PlayerState.idleFaceRight : rightIdleAnimation,
      PlayerState.runningBack : backWalkAnimation,
      PlayerState.runningFront : frontWalkAnimation,
      PlayerState.runningLeft : leftWalkAnimation,
      PlayerState.runningRight : rightWalkAnimation,

    };
    current = PlayerState.idle;
  }

  /// A method for creating player animations.
  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('characters/arturo_bird/$state'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2(24, 48),
      ),
    );
  }

  /// A method for updating player movement when joystick is moved or key is pressed.
  void _updatePlayerMovement(double dt) {
    // Direction X and Direction Y
    double dirX = 0.0;
    double dirY = 0.0;

    switch (playerDirection) {

      // If player stopped, check the last current faced position and set the correct idle image
      case PlayerDirection.none:
        switch(currentPosition){
          case 'Back':
            current = PlayerState.idleFaceBack;
            break;
          case 'Front':
            current = PlayerState.idleFaceFront;
            break;
          case 'Left':
            current = PlayerState.idleFaceLeft;
            break;
          case 'Right':
            current = PlayerState.idleFaceRight;
            break;
        }
        break;

      case PlayerDirection.down:
        // Set current player state
        current = PlayerState.runningFront;
        currentPosition = 'Front';

        // Add vector Y with the movement speed to change vector Y position upward
        dirY += movementSpeed;
        break;
      case PlayerDirection.up:
        // Set current player state
        current = PlayerState.runningBack;
        currentPosition = 'Back';

        // Subtract vector Y with the movement speed to change vector Y position downward
        dirY -= movementSpeed;
        break;
      case PlayerDirection.left:
        current = PlayerState.runningLeft;
        currentPosition = 'Left';

        // Similar with process above done with vector Y
        dirX -= movementSpeed;
        break;
      case PlayerDirection.right:
        current = PlayerState.runningRight;
        currentPosition = 'Right';

        dirX += movementSpeed;
        break;
      case PlayerDirection.downLeft:
        current = PlayerState.runningFront;
        currentPosition = 'Front';

        dirX -= movementSpeed;
        dirY += movementSpeed;
        break;
      case PlayerDirection.downRight:
        current = PlayerState.runningFront;
        currentPosition = 'Front';


        dirX += movementSpeed;
        dirY += movementSpeed;
        break;
      case PlayerDirection.upLeft:
        current = PlayerState.runningBack;
        currentPosition = 'Back';


        dirX -= movementSpeed;
        dirY -= movementSpeed;
        break;
      case PlayerDirection.upRight:
        current = PlayerState.runningBack;
        currentPosition = 'Back';

        dirX += movementSpeed;
        dirY -= movementSpeed;
        break;
      default:
    }

    // Sets velocity using the updated values
    velocity = Vector2(dirX, dirY);
    // Sets the position of the player
    position += velocity * dt;
  }

}