import 'package:flame/events.dart';
import 'package:flame_fuse/src/core.dart';
import 'package:flutter/foundation.dart';

typedef FuseDoubleTapDownFn = Function(DoubleTapDownEvent event);
typedef FuseDoubleTapFn = Function(DoubleTapEvent event);
typedef FuseDoubleTapCancelFn = Function(DoubleTapCancelEvent event);

/// Mixin that enables the usage of `fuseDoubleTap*` fuses.
mixin FuseDoubleTaps on Fuse, DoubleTapCallbacks {
  final _tapDownFns = <FuseDoubleTapDownFn>[];
  final _tapUpFns = <FuseDoubleTapFn>[];
  final _tapCancelFns = <FuseDoubleTapCancelFn>[];

  @override
  @mustCallSuper
  void onDoubleTapDown(DoubleTapDownEvent event) {
    for (final fn in _tapDownFns) {
      fn(event);
    }
  }

  @override
  @mustCallSuper
  void onDoubleTapUp(DoubleTapEvent event) {
    for (final fn in _tapUpFns) {
      fn(event);
    }
  }

  @override
  @mustCallSuper
  void onDoubleTapCancel(DoubleTapCancelEvent event) {
    for (final fn in _tapCancelFns) {
      fn(event);
    }
  }
}

/// Calls [fn] when a double-tap down event occurs.
void fuseDoubleTapDown(FuseDoubleTapDownFn fn) {
  final component = fuseComponent<FuseDoubleTaps>();
  component._tapDownFns.add(fn);
}

/// Calls [fn] when a double-tap up event occurs.
void fuseDoubleTapUp(FuseDoubleTapFn fn) {
  final component = fuseComponent<FuseDoubleTaps>();
  component._tapUpFns.add(fn);
}

/// Calls [fn] when a double-tap cancel event occurs.
void fuseDoubleTapCancel(FuseDoubleTapCancelFn fn) {
  final component = fuseComponent<FuseDoubleTaps>();
  component._tapCancelFns.add(fn);
}
