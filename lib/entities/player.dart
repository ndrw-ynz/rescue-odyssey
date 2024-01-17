import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'dart:async';
import 'package:rescue_odyssey/game/rescue_odyssey_game.dart';

/// The [PlayerState] enum containing the possible asset state of the Player.
enum PlayerState {idle, idleFaceBack, idleFaceFront, idleFaceLeft, idleFaceRight, runningBack, runningFront, runningLeft, runningRight}

/// The [PlayerDirection] enum containing the possible direction states of the Player.
enum PlayerDirection {none, down, up, left, right, downLeft, downRight, upLeft, upRight}

///  [Player] contains the attributes and properties of the player of the game.
///
///  This class extends [SpriteAnimationGroupComponent] and uses [HasGameRef]
///  and [CollisionCallbacks].
///
class Player extends SpriteAnimationGroupComponent with HasGameRef<RescueOdysseyGame>, CollisionCallbacks{
  /// The idle animation asset of [Player].
  late final SpriteAnimation idleAnimation;
  /// The back idle animation asset of [Player].
  late final SpriteAnimation backIdleAnimation;
  /// The front idle animation asset of [Player].
  late final SpriteAnimation frontIdleAnimation;
  /// The left idle animation asset of [Player].
  late final SpriteAnimation leftIdleAnimation;
  /// The right idle animation asset of [Player].
  late final SpriteAnimation rightIdleAnimation;
  /// The back walking animation asset of [Player].
  late final SpriteAnimation backWalkAnimation;
  /// The front walking animation asset of [Player].
  late final SpriteAnimation frontWalkAnimation;
  /// The left walking animation asset of [Player].
  late final SpriteAnimation leftWalkAnimation;
  /// The right walking animation asset of [Player].
  late final SpriteAnimation rightWalkAnimation;

  /// Last current position of [Player].
  late var currentPosition = 'Front';
  /// The speed of [Player] character animation.
  final double stepTime = 0.20;
  /// The size dimension of the [Player].
  Vector2 playerSize = Vector2(24, 48);
  /// The state of the [PlayerDirection] of the [Player].
  PlayerDirection playerDirection = PlayerDirection.none;
  /// The speed of [Player] for walking.
  double movementSpeed = 150;
  /// Contains the velocity value for walking.
  Vector2 velocity = Vector2.zero();

  // The Hitboxes for the sides of the Player.
  /// The hitbox of the left side of the [Player].
  late final RectangleHitbox leftHitbox;
  /// The hitbox of the right side of the [Player].
  late final RectangleHitbox rightHitbox;
  /// The hitbox of the top side of the [Player].
  late final RectangleHitbox topHitbox;
  /// The hitbox of the bottom side of the [Player].
  late final RectangleHitbox bottomHitbox;

  Player() : super(priority: 1);

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

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

  }

  ///
  /// [_initHitboxes] is a private method that initializes the hitboxes of the 4 sides of [Player].
  ///
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


  ///
  /// [_loadAllAnimations] is a private method that loads all animation assets
  /// of [Player] for character movement.
  ///
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

  ///
  /// [_spriteAnimation] is a private method for creating player animations.
  ///
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

  ///
  /// [_updatePlayerMovement] is a private method for updating player movement
  /// when joystick is moved or key is pressed.
  ///
  void _updatePlayerMovement(double dt) {
    // Direction X and Direction Y
    double dirX = 0.0;
    double dirY = 0.0;

    switch (playerDirection) {
      // Checks the current position of player and load correct idle state
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
        // Sets current position of player
        currentPosition = 'Front';
        // Add vector Y with the movement speed to change vector Y position upward
        dirY += bottomHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerDirection.up:
        // Set current player state
        current = PlayerState.runningBack;
        currentPosition = 'Back';
        // Subtract vector Y with the movement speed to change vector Y position downward
        dirY -= topHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerDirection.left:
        current = PlayerState.runningLeft;
        currentPosition = 'Left';
        // Similar with process above done with vector Y
        dirX -= leftHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerDirection.right:
        current = PlayerState.runningRight;
        currentPosition = 'Right';
        dirX += rightHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerDirection.downLeft:
        current = PlayerState.runningFront;
        currentPosition = 'Front';
        dirX -= leftHitbox.isColliding ? 0 : movementSpeed;
        dirY += bottomHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerDirection.downRight:
        current = PlayerState.runningFront;
        currentPosition = 'Front';
        dirX += rightHitbox.isColliding ? 0 : movementSpeed;
        dirY += bottomHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerDirection.upLeft:
        current = PlayerState.runningBack;
        currentPosition = 'Back';
        dirX -= leftHitbox.isColliding ? 0 : movementSpeed;
        dirY -= topHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerDirection.upRight:
        current = PlayerState.runningBack;
        currentPosition = 'Back';
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