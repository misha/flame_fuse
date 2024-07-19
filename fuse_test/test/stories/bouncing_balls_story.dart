import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:fuse/fuse.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

final BOUNCING_BALLS_STORY = Story(
  name: 'Bouncing Balls',
  builder: (_) => GameWidget(game: BouncingBallsGame()),
);

class BouncingBallsGame extends FlameGame
    with //
        HasCollisionDetection,
        Fuse,
        TapCallbacks,
        FuseTaps {
  @override
  FutureOr<void> fuse() {
    final horizontalNormal = Vector2(0, 1);
    final verticalNormal = Vector2(1, 0);

    world.addAll([
      Wall(horizontalNormal) //
        ..position = Vector2(-250, -250)
        ..size = Vector2(500, 1),
      Wall(horizontalNormal) //
        ..position = Vector2(-250, 250)
        ..size = Vector2(500, 1),
      Wall(verticalNormal) //
        ..position = Vector2(-250, -250)
        ..size = Vector2(1, 500),
      Wall(verticalNormal) //
        ..position = Vector2(250, -250)
        ..size = Vector2(1, 500),
    ]);

    void spawn() {
      world.add(Ball());
    }

    spawn();

    fuseTapDown((_) {
      spawn();
    });
  }
}

class Wall extends RectangleComponent with Fuse {
  final Vector2 normal;

  Wall(this.normal);

  @override
  FutureOr<void> fuse() {
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }
}

final _RANDOM = Random();

Color randomColor([double opacity = 0]) {
  return Color.fromRGBO(
    _RANDOM.nextInt(255),
    _RANDOM.nextInt(255),
    _RANDOM.nextInt(255),
    opacity,
  );
}

class Ball extends CircleComponent
    with //
        Fuse,
        CollisionCallbacks,
        FuseCollisions {
  @override
  FutureOr<void> fuse() {
    anchor = Anchor.center;
    size = Vector2.all(33);
    add(CircleHitbox(collisionType: CollisionType.active));

    final velocity = Vector2.all(250) //
      ..rotate(2 * pi * _RANDOM.nextDouble());

    fuseUpdate((dt) {
      position += velocity * dt;
    });

    fuseCollisionStart<Wall>((wall) {
      velocity.reflect(wall.normal);
    });

    paint.color = randomColor();

    fuseCollisionStart<Ball>((_) {
      paint.color = randomColor();
    });
  }
}
