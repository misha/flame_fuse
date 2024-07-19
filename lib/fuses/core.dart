import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:fuse/fuse.dart';

typedef FuseUpdateFn = dynamic Function(double dt);
typedef FuseRemoveFn = dynamic Function();
typedef FuseResizeFn = dynamic Function(Vector2 size);

/// Adds a [fuse] method to a Flame component. While inside this method,
/// behavior may be composed by calling any number of fuse* functions.
///
/// The following core fuses are immediately available:
///
///   - [fuseComponent]
///   - [fuseGame]
///   - [fuseCamera]
///   - [fuseUpdate]
///   - [fuseRemove]
///   - [fuseResize]
///   - [fuseTimer]
///
/// The following mixins are also available for additional fuses:
///
///   - [FuseCollisions]
///   - [FuseHovers]
///   - [FuseKeys]
///   - [FusePointers]
///   - [FuseTaps]
///   - [FuseDoubleTaps]
mixin Fuse on Component {
  final _updateFns = <FuseUpdateFn>[];
  final _removeFns = <FuseRemoveFn>[];
  final _resizeFns = <FuseResizeFn>[];

  @override
  @mustCallSuper
  Future<void> onLoad() async {
    await super.onLoad();
    await runZoned(fuse, zoneValues: {
      #component: this,
    });
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

/// Returns the current Flame game.
G fuseGame<G extends FlameGame>() {
  final component = fuseComponent();
  final game = component.findGame();

  assert(
    game != null,
    '`fuseGame` must be used after the component is added to Flame game.',
  );

  assert(
    game is G,
    'This fuse requires Flame game of type `$G`.',
  );

  return game! as G;
}

/// Returns the current Flame game's camera.
CameraComponent fuseCamera() {
  final game = fuseGame();
  return game.camera;
}

/// Returns the current Flame game's world.
World fuseWorld() {
  final game = fuseGame();
  return game.world;
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
