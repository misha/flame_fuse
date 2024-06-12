import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_hooks/flame_hooks.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

final SPINNING_SQUARE_STORY = Story(
  name: 'Spinning Square',
  builder: (context) {
    return Center(
      child: SizedBox(
        width: 400,
        height: 400,
        child: GameWidget(
          game: FlameGame() //
            ..add(SpinningSquareComponent() //
              ..size = Vector2.all(100)
              ..position = Vector2.all(200)),
        ),
      ),
    );
  },
);

class SpinningSquareComponent extends RectangleComponent with FlameHooks {
  @override
  FutureOr<void> load() {
    anchor = Anchor.center;
    paint = Paint() //
      ..color = Colors.green;

    useFlameUpdate((dt) {
      angle += (pi / 2) * dt;
    });
  }
}
