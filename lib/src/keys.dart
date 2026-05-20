import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';

import 'package:flame_fuse/src/core.dart';
import 'package:flutter/widgets.dart';

typedef FuseKeyEventFn = bool? Function(KeyEvent event, Set<LogicalKeyboardKey> keysPressed);

/// Mixin that enables the usage of `fuseKey*` fuses in non-[Game] components.
mixin FuseKeys on Fuse, KeyboardHandler {
  final _keyEventFns = <FuseKeyEventFn>[];

  @override
  @mustCallSuper
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    var handled = false;

    for (final fn in _keyEventFns) {
      handled |= fn(event, keysPressed) ?? true;
    }

    return handled;
  }
}

/// Calls function [fn] when a key event occurs.
void fuseKeyEvent(FuseKeyEventFn fn) {
  final component = fuseComponent<FuseKeys>();
  component._keyEventFns.add(fn);
}

/// Mixin that enables the usage of `fuseKey*` fuses in [Game] components.
mixin FuseGameKeys on Fuse, KeyboardEvents {
  final _keyEventFns = <FuseKeyEventFn>[];

  @override
  @mustCallSuper
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    var handled = false;

    for (final fn in _keyEventFns) {
      handled |= fn(event, keysPressed) ?? true;
    }

    return handled ? .handled : .ignored;
  }
}

/// Calls function [fn] when a key event occurs in this [Game].
void fuseGameKeyEvent(FuseKeyEventFn fn) {
  final component = fuseComponent<FuseGameKeys>();
  component._keyEventFns.add(fn);
}
