import 'package:flame/components.dart';
import 'dart:async';
import 'package:rescue_odyssey/game/rescue_odyssey_game.dart';

// Created player states using assets
enum PlayerState {idle, runningBack, runningFront, runningLeft, runningRight}

// Created all possible directions for movement of the player
enum PlayerDirection {none, down, up, left, right, downLeft, downRight, upLeft, upRight}

/// The Player Class
///
/// Contains animations, and movements of the player
class Player extends SpriteAnimationGroupComponent
    with HasGameRef<RescueOdysseyGame>{

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation backWalkAnimation;
  late final SpriteAnimation frontWalkAnimation;
  late final SpriteAnimation leftWalkAnimation;
  late final SpriteAnimation rightWalkAnimation;
  final double stepTime = 0.20;

  PlayerDirection playerDirection = PlayerDirection.none;
  double movementSpeed = 150;
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
    backWalkAnimation = _spriteAnimation('arturo_bird_back_walk_anim.png', 4);
    frontWalkAnimation = _spriteAnimation('arturo_bird_front_walk_anim.png', 4);
    leftWalkAnimation = _spriteAnimation('arturo_bird_left_walk_anim.png', 4);
    rightWalkAnimation = _spriteAnimation('arturo_bird_right_walk_anim.png', 4);

    //List of all animations
    animations = {
      PlayerState.idle : idleAnimation,
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
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
      case PlayerDirection.down:
        // Set current player state
        current = PlayerState.runningFront;
        // Add vector Y with the movement speed to change vector Y position upward
        dirY += movementSpeed;
        break;
      case PlayerDirection.up:
        // Set current player state
        current = PlayerState.runningBack;
        // Subtract vector Y with the movement speed to change vector Y position downward
        dirY -= movementSpeed;
        break;
      case PlayerDirection.left:
        current = PlayerState.runningLeft;
        // Similar with process above done with vector Y
        dirX -= movementSpeed;
        break;
      case PlayerDirection.right:
        current = PlayerState.runningRight;
        dirX += movementSpeed;
        break;
      case PlayerDirection.downLeft:
        current = PlayerState.runningFront;
        dirX -= movementSpeed;
        dirY += movementSpeed;
        break;
      case PlayerDirection.downRight:
        current = PlayerState.runningFront;
        dirX += movementSpeed;
        dirY += movementSpeed;
        break;
      case PlayerDirection.upLeft:
        current = PlayerState.runningBack;
        dirX -= movementSpeed;
        dirY -= movementSpeed;
        break;
      case PlayerDirection.upRight:
        current = PlayerState.runningBack;
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