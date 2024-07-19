import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:fuse/fuse.dart';

typedef FuseCollisionFn<C extends PositionComponent> = //
    void Function(C other);

typedef FuseCollisionPointsFn<C extends PositionComponent> = //
    void Function(C other, Set<Vector2> points);

typedef FuseCollisionEndFn<C extends PositionComponent> = //
    void Function(C other);

/// Mixin that enables the usage of collision fuses:
///
///   - [fuseCollision]
///   - [fuseCollisionPoints]
///   - [fuseCollisionStart]
///   - [fuseCollisionEnd]
///
/// Note that the normal requirements for [CollisionCallbacks] components still apply.
mixin FuseCollisions on Fuse, CollisionCallbacks {
  final _collisionFns = <FuseCollisionFn>[];
  final _collisionPointsFns = <FuseCollisionPointsFn>[];
  final _collisionStartFns = <FuseCollisionFn>[];
  final _collisionStartPointsFns = <FuseCollisionPointsFn>[];
  final _collisionEndFns = <FuseCollisionEndFn>[];

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

void _fuseCollisionsCheck() {
  final game = fuseGame();

  assert(
    game is HasCollisionDetection,
    'Collision fuses are only available in games that use the `HasCollisionDetection` mixin.',
  );
}

/// Calls [fn] when this component is colliding with another component of type [C].
void fuseCollision<C extends PositionComponent>(FuseCollisionFn<C> fn) {
  _fuseCollisionsCheck();
  final component = fuseComponent<FuseCollisions>();

  component._collisionFns.add((target) {
    if (target is C) {
      fn(target);
    }
  });
}

/// Calls [fn] when this component is colliding with another component of type [C].
///
/// This version also returns the points at which the collision occurred.
void fuseCollisionPoints<C extends PositionComponent>(FuseCollisionPointsFn<C> fn) {
  _fuseCollisionsCheck();
  final component = fuseComponent<FuseCollisions>();

  component._collisionPointsFns.add((target, points) {
    if (target is C) {
      fn(target, points);
    }
  });
}

/// Calls [fn] when this component collides with another component of type [C].
void fuseCollisionStart<C extends PositionComponent>(FuseCollisionFn<C> fn) {
  _fuseCollisionsCheck();
  final component = fuseComponent<FuseCollisions>();

  component._collisionStartFns.add((target) {
    if (target is C) {
      fn(target);
    }
  });
}

/// Calls [fn] when this component collides with another component of type [C].
///
/// This version also returns the points at which the collision occurred.
void fuseCollisionStartPoints<C extends PositionComponent>(FuseCollisionPointsFn<C> fn) {
  _fuseCollisionsCheck();
  final component = fuseComponent<FuseCollisions>();

  component._collisionStartPointsFns.add((target, points) {
    if (target is C) {
      fn(target, points);
    }
  });
}

void fuseCollisionEnd<C extends PositionComponent>(FuseCollisionEndFn<C> fn) {
  _fuseCollisionsCheck();
  final component = fuseComponent<FuseCollisions>();

  component._collisionEndFns.add((target) {
    if (target is C) {
      fn(target);
    }
  });
}
