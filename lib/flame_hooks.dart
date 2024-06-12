library flame_hooks;

import 'dart:async';

import 'package:flame/components.dart';

typedef FlameHookUpdateFn = void Function(double dt);
typedef FlameHookRemoveFn = void Function();

/// Adds a [load] method to a Flame component in which you may use Flame hooks.
mixin FlameHooks on Component {
  static Component? _component;
  final _updateFns = <FlameHookUpdateFn>[];
  final _removeFns = <FlameHookRemoveFn>[];

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    try {
      _component = this;
      load();
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
  FutureOr<void> load();
}

W useFlameWorld<W extends World>() {
  throw UnimplementedError();
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
    'This usage of `useFlameComponent` needs a $C, but component is of type ${component.runtimeType}.',
  );

  return component as C;
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

// useFlameState
// useFlameEffect
// useFlameResize

