import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';
import 'package:flame_fuse/fuses/core.dart';

typedef FusePointerMoveFn = dynamic Function(PointerMoveEvent event);
typedef FusePointerMoveStopFn = dynamic Function(PointerMoveEvent event);

/// Mixin that enables the usage of pointer fuses:
///
///   - [fusePointerMove]
///   - [fusePointerMoveStop]
mixin FusePointers on Fuse, PointerMoveCallbacks {
  final _moveFns = <FusePointerMoveFn>[];
  final _stopFns = <FusePointerMoveStopFn>[];

  @override
  @mustCallSuper
  void onPointerMove(PointerMoveEvent event) {
    for (final fn in _moveFns) {
      fn(event);
    }
  }

  @override
  @mustCallSuper
  void onPointerMoveStop(PointerMoveEvent event) {
    for (final fn in _stopFns) {
      fn(event);
    }
  }
}

/// Calls [fn] when the pointer moves.
void fusePointerMove(FusePointerMoveFn fn) {
  final component = fuseComponent<FusePointers>();
  component._moveFns.add(fn);
}

/// Calls [fn] when the pointer stops.
void fusePointerMoveStop(FusePointerMoveStopFn fn) {
  final component = fuseComponent<FusePointers>();
  component._stopFns.add(fn);
}
