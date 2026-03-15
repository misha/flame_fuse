import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

import 'package:flame_fuse/src/core.dart';

typedef FuseHoverEnterFn = Function();
typedef FuseHoverExitFn = Function();
typedef FuseHoverUpdateFn = Function(double dt);
typedef FuseHoverEffectFn = Function()? Function();

/// Mixin that enables the usage of `fuseHover*` fuses.
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

  fuseHoverEnter(() {
    enabled = true;
  });

  fuseHoverExit(() {
    enabled = false;
  });

  fuseUpdate((dt) {
    if (enabled) {
      fn(dt);
    }
  });
}

/// Calls [fn] when hover enters this component.
///
/// /// The [fn] may optionally return a cleanup function that is called when the hover exits.
void fuseHoverEffect(FuseHoverEffectFn fn) {
  Function()? cleanup;

  fuseHoverEnter(() {
    cleanup = fn();
  });

  fuseHoverExit(() {
    cleanup?.call();
    cleanup = null;
  });
}
