import 'package:flame/collisions.dart';
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
class Player extends SpriteAnimationGroupComponent with HasGameRef<RescueOdysseyGame>, CollisionCallbacks{

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation backWalkAnimation;
  late final SpriteAnimation frontWalkAnimation;
  late final SpriteAnimation leftWalkAnimation;
  late final SpriteAnimation rightWalkAnimation;
  final double stepTime = 0.20;

  Vector2 playerSize = Vector2(24, 48);
  PlayerDirection playerDirection = PlayerDirection.none;
  double movementSpeed = 150;
  Vector2 velocity = Vector2.zero();

  late final RectangleHitbox leftHitbox;
  late final RectangleHitbox rightHitbox;
  late final RectangleHitbox topHitbox;
  late final RectangleHitbox bottomHitbox;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    _initHitboxes();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  // \/ Methods \/
  /// A method that initializes the hitboxes of the 4 sides of the Player.
  void _initHitboxes() {
    leftHitbox = RectangleHitbox(
      position: Vector2(1, playerSize.y * 0.8),
      size: Vector2(2, playerSize.x*0.3),
      collisionType: CollisionType.active
    );

    rightHitbox = RectangleHitbox(
      position: Vector2(playerSize.x-3, playerSize.y * 0.8),
      size: Vector2(2, playerSize.x*0.3),
      collisionType: CollisionType.active
    );

    topHitbox = RectangleHitbox(
      position: Vector2(5, playerSize.y * 0.8),
      size: Vector2(playerSize.x*0.6, 2),
      collisionType: CollisionType.active
    );

    bottomHitbox = RectangleHitbox(
      position: Vector2(5, playerSize.y - 3),
      size: Vector2(playerSize.x*0.6, 2),
      collisionType: CollisionType.active
    );

    add(leftHitbox);
    add(rightHitbox);
    add(topHitbox);
    add(bottomHitbox);
  }


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
        textureSize: playerSize,
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
        dirY += bottomHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerDirection.up:
        // Set current player state
        current = PlayerState.runningBack;
        // Subtract vector Y with the movement speed to change vector Y position downward
        dirY -= topHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerDirection.left:
        current = PlayerState.runningLeft;
        // Similar with process above done with vector Y
        dirX -= leftHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerDirection.right:
        current = PlayerState.runningRight;
        dirX += rightHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerDirection.downLeft:
        current = PlayerState.runningFront;
        dirX -= leftHitbox.isColliding ? 0 : movementSpeed;
        dirY += bottomHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerDirection.downRight:
        current = PlayerState.runningFront;
        dirX += rightHitbox.isColliding ? 0 : movementSpeed;
        dirY += bottomHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerDirection.upLeft:
        current = PlayerState.runningBack;
        dirX -= leftHitbox.isColliding ? 0 : movementSpeed;
        dirY -= topHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerDirection.upRight:
        current = PlayerState.runningBack;
        dirX += rightHitbox.isColliding ? 0 : movementSpeed;
        dirY -= topHitbox.isColliding ? 0 : movementSpeed;
        break;
      default:
    }

    // Sets velocity using the updated values
    velocity = Vector2(dirX, dirY);
    // Sets the position of the player
    position += velocity * dt;
  }
}