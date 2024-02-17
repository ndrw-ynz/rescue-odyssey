import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:rescue_odyssey/components/interactable_block.dart';
import 'dart:async';
import 'package:rescue_odyssey/game/rescue_odyssey_game.dart';

/// The [PlayerAnimationState] enum containing the possible asset state of the Player.
enum PlayerAnimationState {idle, idleFaceBack, idleFaceFront, idleFaceLeft, idleFaceRight, runningBack, runningFront, runningLeft, runningRight}

/// The [PlayerMovementState] enum containing the possible movement states of the Player.
enum PlayerMovementState {none, down, up, left, right, downLeft, downRight, upLeft, upRight}

/// The [PlayerCardinalDirectionState] enum containing the four possible directions of the Player.
enum PlayerCardinalDirectionState {west, east, north, south}

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
  PlayerCardinalDirectionState currentPosition = PlayerCardinalDirectionState.south;
  /// The speed of [Player] character animation.
  final double stepTime = 0.20;
  /// The size dimension of the [Player].
  Vector2 playerSize = Vector2(24, 48);
  /// The state of the [PlayerMovementState] of the [Player].
  PlayerMovementState playerDirection = PlayerMovementState.none;
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
    // TODO:
    if (other is InteractableBlock && intersectionPoints.length == 2) {
      Vector2 pointA = intersectionPoints.elementAt(0);
      Vector2 pointB = intersectionPoints.elementAt(1);

      Vector2 interactablePoint = other.toRect().containsPoint(pointA) ? pointA : pointB;
      bool isFacingInteractable = false;
      switch (currentPosition) {
        case PlayerCardinalDirectionState.north:
          isFacingInteractable = positionOfAnchor(Anchor.bottomCenter).y - 5 > interactablePoint.y;
          break;
        case PlayerCardinalDirectionState.south:
          isFacingInteractable = positionOfAnchor(Anchor.bottomCenter).y - 5 < interactablePoint.y;
          break;
        case PlayerCardinalDirectionState.west:
          isFacingInteractable = positionOfAnchor(Anchor.bottomCenter).x > interactablePoint.x;
          break;
        case PlayerCardinalDirectionState.east:
          isFacingInteractable = positionOfAnchor(Anchor.bottomCenter).x < interactablePoint.x;
          break;
      }

      if (isFacingInteractable) {

      }

    }
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
      PlayerAnimationState.idle : idleAnimation,
      PlayerAnimationState.idleFaceBack : backIdleAnimation,
      PlayerAnimationState.idleFaceFront : frontIdleAnimation,
      PlayerAnimationState.idleFaceLeft : leftIdleAnimation,
      PlayerAnimationState.idleFaceRight : rightIdleAnimation,
      PlayerAnimationState.runningBack : backWalkAnimation,
      PlayerAnimationState.runningFront : frontWalkAnimation,
      PlayerAnimationState.runningLeft : leftWalkAnimation,
      PlayerAnimationState.runningRight : rightWalkAnimation,
    };
    current = PlayerAnimationState.idle;
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
      case PlayerMovementState.none:
        switch(currentPosition) {
          case PlayerCardinalDirectionState.north:
            current = PlayerAnimationState.idleFaceBack;
            break;
          case PlayerCardinalDirectionState.south:
            current = PlayerAnimationState.idleFaceFront;
            break;
          case PlayerCardinalDirectionState.west:
            current = PlayerAnimationState.idleFaceLeft;
            break;
          case PlayerCardinalDirectionState.east:
            current = PlayerAnimationState.idleFaceRight;
            break;
        }
        break;
      case PlayerMovementState.down:
        // Set current player state
        current = PlayerAnimationState.runningFront;
        // Sets current position of player
        currentPosition =  PlayerCardinalDirectionState.south;
        // Add vector Y with the movement speed to change vector Y position upward
        dirY += bottomHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerMovementState.up:
        // Set current player state
        current = PlayerAnimationState.runningBack;
        currentPosition =  PlayerCardinalDirectionState.north;
        // Subtract vector Y with the movement speed to change vector Y position downward
        dirY -= topHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerMovementState.left:
        current = PlayerAnimationState.runningLeft;
        currentPosition =  PlayerCardinalDirectionState.west;
        // Similar with process above done with vector Y
        dirX -= leftHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerMovementState.right:
        current = PlayerAnimationState.runningRight;
        currentPosition =  PlayerCardinalDirectionState.east;
        dirX += rightHitbox.isColliding ? 0 : movementSpeed;
        break;
      case PlayerMovementState.downLeft:
        current = PlayerAnimationState.runningFront;
        currentPosition =  PlayerCardinalDirectionState.south;
        dirX -= leftHitbox.isColliding ? 0 : movementSpeed - 30;
        dirY += bottomHitbox.isColliding ? 0 : movementSpeed - 30;
        break;
      case PlayerMovementState.downRight:
        current = PlayerAnimationState.runningFront;
        currentPosition =  PlayerCardinalDirectionState.south;
        dirX += rightHitbox.isColliding ? 0 : movementSpeed - 30;
        dirY += bottomHitbox.isColliding ? 0 : movementSpeed - 30;
        break;
      case PlayerMovementState.upLeft:
        current = PlayerAnimationState.runningBack;
        currentPosition =  PlayerCardinalDirectionState.north;
        dirX -= leftHitbox.isColliding ? 0 : movementSpeed - 30;
        dirY -= topHitbox.isColliding ? 0 : movementSpeed - 30;
        break;
      case PlayerMovementState.upRight:
        current = PlayerAnimationState.runningBack;
        currentPosition =  PlayerCardinalDirectionState.north;
        dirX += rightHitbox.isColliding ? 0 : movementSpeed - 30;
        dirY -= topHitbox.isColliding ? 0 : movementSpeed - 30;
        break;
      default:
    }

    // Sets velocity using the updated values
    velocity = Vector2(dirX, dirY);
    // Sets the position of the player
    position += velocity * dt;
  }

}