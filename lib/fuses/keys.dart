import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_fuse/fuses/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef FuseKeyEventFn = bool? Function(
  KeyEvent event,
  Set<LogicalKeyboardKey> keysPressed,
);

/// Mixin that enables the usage of key fuses:
///
///   - [fuseKeyEvent]
///
/// Note that the normal requirements for [KeyboardHandler] components still apply.
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

void _fuseKeysCheck() {
  final game = fuseGame();

  assert(
    game is HasKeyboardHandlerComponents,
    'Key fuses are only available in games that use the `HasKeyboardHandlerComponents` mixin.',
  );
}

/// Calls function [fn] when a key event occurs.
void fuseKeyEvent(FuseKeyEventFn fn) {
  _fuseKeysCheck();
  final component = fuseComponent<FuseKeys>();
  component._keyEventFns.add(fn);
}
