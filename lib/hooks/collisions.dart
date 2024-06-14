import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_hooks/flame_hooks.dart';
import 'package:flutter/foundation.dart';

typedef FlameHookCollisionFn<C extends PositionComponent> = //
    void Function(C other);

typedef FlameHookCollisionPointsFn<C extends PositionComponent> = //
    void Function(C other, Set<Vector2> points);

typedef FlameHookCollisionEndFn<C extends PositionComponent> = //
    void Function(C other);

/// Mixin that enables usage of collision-related hooks:
///
///   - [useFlameCollision]
mixin FlameCollisionHooks on FlameHooks, CollisionCallbacks {
  final _collisionFns = <FlameHookCollisionFn>[];
  final _collisionPointsFns = <FlameHookCollisionPointsFn>[];
  final _collisionStartFns = <FlameHookCollisionFn>[];
  final _collisionStartPointsFns = <FlameHookCollisionPointsFn>[];
  final _collisionEndFns = <FlameHookCollisionEndFn>[];

  @override
  @mustCallSuper
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    for (final fn in _collisionFns) {
      fn(other);
    }

    for (final fn in _collisionPointsFns) {
      fn(other, intersectionPoints);
    }
  }

  @override
  @mustCallSuper
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    for (final fn in _collisionStartFns) {
      fn(other);
    }

    for (final fn in _collisionStartPointsFns) {
      fn(other, intersectionPoints);
    }
  }

  @override
  @mustCallSuper
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    for (final fn in _collisionEndFns) {
      fn(other);
    }
  }
}

void _useFlameCollisionHooksCheck() {
  final game = useFlameGame();

  assert(
    game is HasCollisionDetection,
    '`useFlameCollision` is only available in games that use the `HasCollisionDetection` mixin.',
  );
}

/// Calls [fn] when this component is colliding with another component of type [C].
void useFlameCollision<C extends PositionComponent>(FlameHookCollisionFn<C> fn) {
  _useFlameCollisionHooksCheck();
  final component = useFlameComponent<FlameCollisionHooks>();

  component._collisionFns.add((target) {
    if (target is C) {
      fn(target);
    }
  });
}

/// Calls [fn] when this component is colliding with another component of type [C].
///
/// This version also returns the points at which the collision occurred.
void useFlameCollisionPoints<C extends PositionComponent>(FlameHookCollisionPointsFn<C> fn) {
  _useFlameCollisionHooksCheck();
  final component = useFlameComponent<FlameCollisionHooks>();

  component._collisionPointsFns.add((target, points) {
    if (target is C) {
      fn(target, points);
    }
  });
}

/// Calls [fn] when this component collides with another component of type [C].
void useFlameCollisionStart<C extends PositionComponent>(FlameHookCollisionFn<C> fn) {
  _useFlameCollisionHooksCheck();
  final component = useFlameComponent<FlameCollisionHooks>();

  component._collisionStartFns.add((target) {
    if (target is C) {
      fn(target);
    }
  });
}

/// Calls [fn] when this component collides with another component of type [C].
///
/// This version also returns the points at which the collision occurred.
void useFlameCollisionStartPoints<C extends PositionComponent>(FlameHookCollisionPointsFn<C> fn) {
  _useFlameCollisionHooksCheck();
  final component = useFlameComponent<FlameCollisionHooks>();

  component._collisionStartPointsFns.add((target, points) {
    if (target is C) {
      fn(target, points);
    }
  });
}

void useFlameCollisionEnd<C extends PositionComponent>(FlameHookCollisionEndFn<C> fn) {
  _useFlameCollisionHooksCheck();
  final component = useFlameComponent<FlameCollisionHooks>();

  component._collisionEndFns.add((target) {
    if (target is C) {
      fn(target);
    }
  });
}
