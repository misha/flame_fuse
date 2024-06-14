import 'package:flame/components.dart';
import 'package:flame_hooks/hooks/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef FlameHookKeyEventFn = bool? Function(KeyEvent event, Set<LogicalKeyboardKey> keysPressed);

/// Mixin that enables usage of key-related hooks:
///
///   - [useFlameKeyEvent]
mixin FlameKeyHooks on FlameHooks, KeyboardHandler {
  final _keyEventFns = <Set<LogicalKeyboardKey>, List<FlameHookKeyEventFn>>{};

  @override
  @mustCallSuper
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    var handled = false;

    for (final keys in _keyEventFns.keys) {
      if (keysPressed.containsAll(keys)) {
        for (final fn in _keyEventFns[keys]!) {
          handled |= fn(event, keysPressed) ?? true;
        }
      }
    }

    return handled;
  }
}

/// Calls function [fn] when all the given [keys] are pressed.
void useFlameKeyEvent(Set<LogicalKeyboardKey> keys, FlameHookKeyEventFn fn) {
  final component = useFlameComponent();

  assert(
    component is FlameKeyHooks,
    '`useFlameKeyEvent` may only be used in components with the `FlameKeyHooks` mixin.',
  );

  (component as FlameKeyHooks)._keyEventFns.putIfAbsent(keys, () => []).add(fn);
}
