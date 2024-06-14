import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_hooks/flame_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

final SNAKE_GAME_STORY = Story(
  name: 'Snake Game',
  builder: (_) => _Story(),
);

class _Story extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: 500,
        child: GameWidget(
          game: SnakeGame(),
        ),
      ),
    );
  }
}

enum Direction {
  north,
  south,
  west,
  east;

  Vector2 get vector {
    switch (this) {
      case Direction.north:
        return Vector2(0, -1);
      case Direction.south:
        return Vector2(0, 1);
      case Direction.west:
        return Vector2(-1, 0);
      case Direction.east:
        return Vector2(1, 0);
    }
  }
}

class SnakeGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents, FlameHooks {
  final snake = SnakeComponent();

  @override
  void hook() {
    camera.viewport.position = -size / 2;
    world.add(snake);
    world.add(FoodComponent());
  }
}

class TurnEffect extends ComponentEffect<SnakeSegmentComponent> {
  final Direction direction;

  TurnEffect({
    required this.direction,
    bool head = false,
  }) : super(
          EffectController(
            duration: 0,
            startDelay: head ? 0 : SnakeSegmentComponent.speed,
          ),
        );

  @override
  void apply(double progress) {
    if (controller.completed) {
      target.direction = direction;
      target.childSegment?.add(TurnEffect(direction: direction));
    }
  }
}

class SnakeComponent extends Component with HasWorldReference, KeyboardHandler, FlameHooks, FlameKeyHooks {
  late final head = SnakeSegmentComponent(this, null);

  late var tail = head;

  void turn(Direction direction) {
    head.add(TurnEffect(direction: direction, head: true));
  }

  void grow() {
    world.add(tail = tail.childSegment = SnakeSegmentComponent(this, tail));
  }

  @override
  void hook() {
    world.add(head);

    useFlameKeyEvent({LogicalKeyboardKey.arrowUp}, (_, __) {
      if (head.direction != Direction.south) {
        turn(Direction.north);
      }
    });

    useFlameKeyEvent({LogicalKeyboardKey.arrowDown}, (_, __) {
      if (head.direction != Direction.north) {
        turn(Direction.south);
      }
    });

    useFlameKeyEvent({LogicalKeyboardKey.arrowLeft}, (_, __) {
      if (head.direction != Direction.east) {
        turn(Direction.west);
      }
    });

    useFlameKeyEvent({LogicalKeyboardKey.arrowRight}, (_, __) {
      if (head.direction != Direction.west) {
        turn(Direction.east);
      }
    });
  }
}

class SnakeSegmentComponent extends RectangleComponent
    with HasWorldReference, FlameHooks, CollisionCallbacks, FlameCollisionHooks {
  static const speed = 2.0;

  final SnakeComponent snake;

  final SnakeSegmentComponent? parentSegment;

  SnakeSegmentComponent? childSegment;

  var direction = Direction.south;

  var _active = false;

  final _timestamp = DateTime.now();

  SnakeSegmentComponent(this.snake, this.parentSegment);

  @override
  void hook() {
    size = Vector2.all(25);
    anchor = Anchor.center;
    paint = Paint() //
      ..color = Colors.white;

    final parentSegment = this.parentSegment;

    if (parentSegment != null) {
      size = Vector2.all(15);
      direction = parentSegment.direction;
      position = parentSegment.position.clone();
    }

    add(
      RectangleHitbox(
        anchor: Anchor.center,
        isSolid: true,
      ),
    );

    // Wait a second to activate.
    useFlameTimer(1, () {
      _active = true;
    }, repeat: false);

    useFlameUpdate((dt) {
      if (_active) {
        position += direction.vector * speed;
      }
    });

    useFlameCollision<SnakeSegmentComponent>((other) {
      if (!_active || !other._active) {
        return;
      }

      if (_timestamp.isBefore(other._timestamp)) {
        // TODO: lose the game
        print('collided with another snake segment, lost the game!');
      }
    });

    useFlameCollision<FoodComponent>((food) {
      food.removeFromParent();
      snake.grow();
      world.add(FoodComponent());
    });
  }
}

class FoodComponent extends CircleComponent with FlameHooks, HasGameReference<SnakeGame> {
  @override
  void hook() {
    radius = 8;
    anchor = Anchor.center;
    paint = Paint() //
      ..color = Colors.orange;

    position = Vector2.random() //
      ..multiply(game.size)
      ..floor();

    add(
      CircleHitbox(
        anchor: Anchor.center,
        isSolid: true,
      ),
    );
  }
}
