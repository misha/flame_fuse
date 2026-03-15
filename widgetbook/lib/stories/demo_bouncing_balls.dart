import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_fuse/flame_fuse.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:flame_fuse_widgetbook/widgets/demo_frame.dart';

@UseCase(name: 'Demo: Bouncing Balls', type: Fuse)
Widget buildBouncingBallsDemo(_) {
  return DemoFrame(
    name: 'bouncing_balls_demo',
    child: GameWidget(
      game: BouncingBallsGame(),
    ),
  );
}

final _NORMAL_HORIZONTAL = Vector2(0, 1);
final _NORMAL_VERTICAL = Vector2(1, 0);

class BouncingBallsGame extends FlameGame with HasCollisionDetection, Fuse, TapCallbacks, FuseTaps {
  @override
  FutureOr<void> fuse() {
    world.addAll([
      Wall(_NORMAL_HORIZONTAL) //
        ..position = Vector2(-250, -250)
        ..size = Vector2(500, 1),
      Wall(_NORMAL_HORIZONTAL) //
        ..position = Vector2(-250, 250)
        ..size = Vector2(500, 1),
      Wall(_NORMAL_VERTICAL) //
        ..position = Vector2(-250, -250)
        ..size = Vector2(1, 500),
      Wall(_NORMAL_VERTICAL) //
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
  Wall(this.normal);

  final Vector2 normal;

  @override
  FutureOr<void> fuse() {
    add(RectangleHitbox(collisionType: .passive));
  }
}

final _RANDOM = Random();

class Ball extends CircleComponent with Fuse, CollisionCallbacks, FuseCollisions {
  @override
  FutureOr<void> fuse() {
    anchor = Anchor.center;
    size = Vector2.all(33);
    add(CircleHitbox());

    //
    // Movement (constant velocity, reflect off walls)
    //

    final velocity = Vector2.all(250);
    velocity.rotate(2 * pi * _RANDOM.nextDouble());

    fuseUpdate((dt) {
      position += velocity * dt;
    });

    fuseCollisionStart<Wall>((wall) {
      velocity.reflect(wall.normal);
    });

    //
    // Colors (green by default, red when colliding)
    //

    paint.color = Colors.green;
    var collisions = 0;

    fuseCollisionEffect<Ball>((_) {
      collisions += 1;
      paint.color = Colors.red;

      return () {
        collisions -= 1;

        if (collisions == 0) {
          paint.color = Colors.green;
        }
      };
    });
  }
}
