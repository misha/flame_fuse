import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';

import 'package:flame_fuse/src/collisions.dart';
import 'package:flame_fuse/src/drag.dart';
import 'package:flame_fuse/src/hover.dart';
import 'package:flame_fuse/src/keys.dart';
import 'package:flame_fuse/src/pointers.dart';
import 'package:flame_fuse/src/taps.dart';
import 'package:flame_fuse/src/taps2.dart';

typedef FuseUpdateFn = Function(double dt);
typedef FuseMountFn = Function();
typedef FuseRemoveFn = Function();
typedef FuseResizeFn = Function(Vector2 size);
typedef FuseParentResizeFn = Function(Vector2 maxSize);

/// Adds a [fuse] method to a Flame component. While inside this method,
/// behavior may be composed by calling any number of fuse* functions.
///
/// The following core fuses are immediately available:
///
///   - [fuseComponent]
///   - [fuseGame]
///   - [fuseCamera]
///   - [fuseMount]
///   - [fuseUpdate]
///   - [fuseRemove]
///   - [fuseResize]
///   - [fuseParentResize]
///
/// The following mixins are also available for additional fuses:
///
///   - [FuseCollisions]
///   - [FuseDrags]
///   - [FuseHovers]
///   - [FuseKeys]
///   - [FusePointers]
///   - [FuseTaps]
///   - [FuseDoubleTaps]
mixin Fuse on Component {
  final _mountFns = <FuseMountFn>[];
  final _updateFns = <FuseUpdateFn>[];
  final _removeFns = <FuseRemoveFn>[];
  final _resizeFns = <FuseResizeFn>[];
  final _parentResizeFns = <FuseParentResizeFn>[];

  @override
  @mustCallSuper
  Future<void> onLoad() async {
    await super.onLoad();
    await runZoned(fuse, zoneValues: {#component: this});
  }

  @override
  @mustCallSuper
  void onMount() {
    super.onMount();

    for (final fn in _mountFns) {
      fn();
    }
  }

  @override
  @mustCallSuper
  void update(double dt) {
    super.update(dt);

    for (final fn in _updateFns) {
      fn(dt);
    }
  }

  @override
  @mustCallSuper
  void onRemove() {
    super.onRemove();

    for (final fn in _removeFns) {
      fn();
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    for (final fn in _resizeFns) {
      fn(size);
    }
  }

  @override
  void onParentResize(Vector2 maxSize) {
    super.onParentResize(maxSize);

    for (final fn in _parentResizeFns) {
      fn(maxSize);
    }
  }

  /// Enables usage of fuse* functions to compose this component's behavior.
  ///
  /// This method is called exactly once during the component's [onLoad] callback.
  @visibleForOverriding
  FutureOr<void> fuse();
}

/// Returns the current Flame component.
C fuseComponent<C extends Fuse>() {
  final component = Zone.current[#component];

  assert(
    component != null,
    'Fuses must be called inside the `fuse` method.',
  );

  assert(
    component is C,
    'This fuse requires a Flame component of type `$C`.',
  );

  return component as C;
}

/// Returns the current game.
G fuseGame<G extends Game>() {
  final component = fuseComponent();
  final game = component.findGame();

  assert(
    game != null,
    '`fuseGame` must be used after the component is added to the game.',
  );

  assert(
    game is G,
    'This fuse requires a game of type `$G`.',
  );

  return game! as G;
}

/// Returns the current Flame game's camera.
CameraComponent fuseCamera() {
  final game = fuseGame<FlameGame>();
  return game.camera;
}

/// Returns the current Flame game's world.
World fuseWorld() {
  final game = fuseGame<FlameGame>();
  return game.world;
}

/// Calls function [fn] when the current Flame component is mounted.
void fuseMount(FuseMountFn fn) {
  final component = fuseComponent();
  component._mountFns.add(fn);
}

/// Calls function [fn] on every Flame game update.
void fuseUpdate(FuseUpdateFn fn) {
  final component = fuseComponent();
  component._updateFns.add(fn);
}

/// Calls function [fn] when the current Flame component is removed.
void fuseRemove(FuseRemoveFn fn) {
  final component = fuseComponent();
  component._removeFns.add(fn);
}

/// Calls function [fn] when the current Flame game is resized.
void fuseResize(FuseResizeFn fn) {
  final component = fuseComponent();
  component._resizeFns.add(fn);
}

/// Calls function [fn] whenever the parent component is resized.
void fuseParentResize(FuseParentResizeFn fn) {
  final component = fuseComponent();
  component._parentResizeFns.add(fn);
}
