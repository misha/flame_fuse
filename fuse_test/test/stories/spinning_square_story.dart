import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:fuse/fuse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

final SPINNING_SQUARE_STORY = Story(
  name: 'Spinning Square',
  builder: (_) => _Story(),
);

class _Story extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: 400,
        child: GameWidget(
          game: FlameGame() //
            ..add(SpinningSquareComponent() //
              ..size = Vector2.all(100)
              ..position = Vector2.all(200)),
        ),
      ),
    );
  }
}

class SpinningSquareComponent extends RectangleComponent with Fuse {
  @override
  FutureOr<void> fuse() {
    anchor = Anchor.center;
    paint = Paint() //
      ..color = Colors.green;

    fuseUpdate((dt) {
      angle += (pi / 2) * dt;
    });
  }
}
