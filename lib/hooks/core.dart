import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_hooks/hooks/keys.dart';
import 'package:flutter/foundation.dart';

typedef FlameHookUpdateFn = void Function(double dt);
typedef FlameHookRemoveFn = void Function();

/// Adds a [hook] method to a Flame component in which you may use Flame hooks.
///
/// The following hooks are immediately available:
///
///   - [useFlameComponent]
///   - [useFlameGame]
///   - [useFlameCamera]
///   - [useFlameUpdate]
///   - [useFlameRemove]
///
/// The following mixins are also available for additional hooks:
///
///   - [FlameKeyHooks]
mixin FlameHooks on Component {
  static Component? _component;
  final _updateFns = <FlameHookUpdateFn>[];
  final _removeFns = <FlameHookRemoveFn>[];

  @override
  @mustCallSuper
  Future<void> onLoad() async {
    await super.onLoad();

    try {
      _component = this;
      await hook();
    } finally {
      _component = null;
    }
  }

  @override
  @mustCallSuper
  void update(double dt) {
    super.update(dt);

    for (final fn in _updateFns) {
      try {
        _component = this;
        fn(dt);
      } finally {
        _component = null;
      }
    }
  }

  @override
  @mustCallSuper
  void onRemove() {
    super.onRemove();

    for (final fn in _removeFns) {
      try {
        _component = this;
        fn();
      } finally {
        _component = null;
      }
    }
  }

  /// Use to set up this component with various Flame hooks.
  FutureOr<void>? hook();
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
    'This usage of `useFlameComponent` expected a component satsifying the type `$C`.',
  );

  return component as C;
}

G useFlameGame<G extends FlameGame>() {
  final component = useFlameComponent();
  final game = component.findGame();

  assert(
    game != null,
    '`useFlameGame` must be used after the component is added to Flame game.',
  );

  assert(
    game is G,
    'This usage of `useFlameGame` expected a game satisfying the type `$G`.',
  );

  return game! as G;
}

/// Returns the current Flame game's camera.
CameraComponent useFlameCamera() {
  final game = useFlameGame();
  return game.camera;
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
