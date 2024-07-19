import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';
import 'package:flame_fuse/fuses/core.dart';

typedef FuseHoverEnterFn = dynamic Function();
typedef FuseHoverExitFn = dynamic Function();
typedef FuseHoverUpdateFn = dynamic Function(double dt);

/// Mixin that enables the usage of hover fuses:
///
///   - [fuseHoverEnter]
///   - [fuseHoverExit]
///   - [fuseHoverUpdate]
mixin FuseHovers on Fuse, HoverCallbacks {
  final _enterFns = <FuseHoverEnterFn>[];
  final _exitFns = <FuseHoverExitFn>[];

  @override
  @mustCallSuper
  void onHoverEnter() {
    for (final fn in _enterFns) {
      fn();
    }
  }

  @override
  @mustCallSuper
  void onHoverExit() {
    for (final fn in _exitFns) {
      fn();
    }
  }
}

/// Calls [fn] when hover enters this component.
void fuseHoverEnter(FuseHoverEnterFn fn) {
  final component = fuseComponent<FuseHovers>();
  component._enterFns.add(fn);
}

/// Calls [fn] when hover exits this component.
void fuseHoverExit(FuseHoverExitFn fn) {
  final component = fuseComponent<FuseHovers>();
  component._exitFns.add(fn);
}

/// Calls [fn] while hovering over this component.
void fuseHoverUpdate(FuseHoverUpdateFn fn) {
  var enabled = false;
  fuseHoverEnter(() => enabled = true);
  fuseHoverExit(() => enabled = false);
  fuseUpdate((dt) {
    if (enabled) {
      fn(dt);
    }
  });
}
