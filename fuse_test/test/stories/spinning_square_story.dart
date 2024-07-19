import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_fuse/fuse.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

final SPINNING_SQUARE_STORY = Story(
  name: 'Spinning Square',
  builder: (_) => GameWidget(game: SpinningSquareGame()),
);

class SpinningSquareGame extends FlameGame with Fuse {
  @override
  FutureOr<void> fuse() {
    final square = SpinningSquare();
    world.add(square);
    camera.follow(square);
  }
}

class SpinningSquare extends RectangleComponent with Fuse {
  @override
  FutureOr<void> fuse() {
    anchor = Anchor.center;
    paint = Paint() //
      ..color = Colors.green;

    size = Vector2.all(100);

    fuseUpdate((dt) {
      angle += (pi / 2) * dt;
    });
  }
}
