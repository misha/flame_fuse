import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_fuse/flame_fuse.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:flame_fuse_widgetbook/widgets/demo_frame.dart';

@UseCase(name: 'Demo: Spinning Square', type: Fuse)
Widget buildSpinningSquareDemo(_) {
  return DemoFrame(
    name: 'spinning_square_demo',
    child: GameWidget(
      game: SpinningSquareGame(),
    ),
  );
}

class SpinningSquareGame extends FlameGame with Fuse {
  @override
  FutureOr<void> fuse() {
    final square = SpinningSquare();
    world.add(square);
  }
}

class SpinningSquare extends RectangleComponent with Fuse {
  SpinningSquare()
    : super(
        anchor: .center,
        size: .all(100),
      );

  @override
  FutureOr<void> fuse() {
    paint.color = Colors.green;

    fuseUpdate((dt) {
      angle += (pi / 2) * dt;
    });
  }
}
