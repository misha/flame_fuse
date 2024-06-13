library flame_hooks;

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';

typedef FlameHookUpdateFn = void Function(double dt);
typedef FlameHookRemoveFn = void Function();
typedef FlameHookKeyEventFn = bool? Function(KeyEvent event, Set<LogicalKeyboardKey> keysPressed);

/// Adds a [load] method to a Flame component in which you may use Flame hooks.
mixin FlameHooks on Component {
  static Component? _component;
  final _updateFns = <FlameHookUpdateFn>[];
  final _removeFns = <FlameHookRemoveFn>[];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    try {
      _component = this;
      await load();
    } finally {
      _component = null;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (final fn in _updateFns) {
      fn(dt);
    }
  }

  @override
  void onRemove() {
    super.onRemove();

    for (final fn in _removeFns) {
      fn();
    }
  }

  /// Use to set up this component with various Flame hooks.
  FutureOr<void>? load();
}

/// Returns the current Flame component.
C useFlameComponent<C extends FlameHooks>() {
  assert(
    FlameHooks._component != null,
    '`useFlameComponent` can only be called from the build method of a component with the FlameHooks mixin.',
  );

  final component = FlameHooks._component!;

  assert(
    component is C,
    'This usage of `useFlameComponent` needs to include the $C type or mixin.',
  );

  return component as C;
}

W useFlameWorld<W extends World>() {
  throw UnimplementedError();
}

CameraComponent useFlameCamera() {
  throw UnimplementedError();
}

/// Calls function [fn] on every update.
void useFlameUpdate(FlameHookUpdateFn fn) {
  final component = useFlameComponent();
  component._updateFns.add(fn);
}

/// Calls function [fn] when the current Flame component is removed.
void useFlameRemove(FlameHookRemoveFn fn) {
  final component = useFlameComponent();
  component._removeFns.add(fn);
}

mixin FlameKeyHooks on FlameHooks, KeyboardHandler {
  final _keyEventFns = <Set<LogicalKeyboardKey>, List<FlameHookKeyEventFn>>{};

  @override
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
