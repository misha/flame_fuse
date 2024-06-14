import 'dart:async';

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
    world.add(snake);

    useFlameTimer(3, () {
      final position = Vector2.random() //
        ..multiply(size)
        ..floor();

      final food = FoodComponent() //
        ..position = position;

      world.add(food);
    });
  }
}

class TurnEffect extends ComponentEffect<SnakeSegmentComponent> {
  final Direction direction;

  TurnEffect({
    required this.direction,
    required int index,
  }) : super(
          EffectController(
            duration: 0,
            startDelay: index * SnakeSegmentComponent.speed,
          ),
        );

  @override
  void apply(double progress) {
    if (controller.completed) {
      target.direction = direction;
    }
  }
}

class SnakeComponent extends PositionComponent with KeyboardHandler, FlameHooks, FlameKeyHooks {
  final segments = [SnakeSegmentComponent(head: true)];

  @override
  FutureOr<void> hook() {
    final head = segments.first;
    add(head);

    void turn(Direction direction) {
      for (final (index, segment) in segments.indexed) {
        segment.add(TurnEffect(direction: direction, index: index));
      }
    }

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

class SnakeSegmentComponent extends RectangleComponent with FlameHooks {
  static const speed = 2.0;

  final bool head;

  var direction = Direction.south;

  SnakeSegmentComponent({
    this.head = false,
  });

  @override
  FutureOr<void> hook() {
    size = Vector2.all(head ? 25 : 15);
    anchor = Anchor.center;
    paint = Paint() //
      ..color = Colors.white;

    add(
      RectangleHitbox(
        anchor: Anchor.center,
        isSolid: true,
      ),
    );

    useFlameUpdate((dt) {
      position += direction.vector * speed;
      // TODO: change direction based on given tail.
    });

    useFlameCollision<SnakeSegmentComponent>((_) {
      print('collided with another snake segment!');
    });

    useFlameCollision<FoodComponent>((food) {
      food.removeFromParent();
      // add new segment to snake
    });
  }
}

class FoodComponent extends CircleComponent with FlameHooks {
  @override
  FutureOr<void>? hook() {
    radius = 8;
    anchor = Anchor.center;
    paint = Paint() //
      ..color = Colors.orange;

    add(
      CircleHitbox(
        anchor: Anchor.center,
        isSolid: true,
      ),
    );
  }
}
