import 'package:flame/events.dart';
import 'package:flame_fuse/fuses/core.dart';
import 'package:flutter/foundation.dart';

typedef FuseTapDownFn = void Function(TapDownEvent event);
typedef FuseTapUpFn = void Function(TapUpEvent event);
typedef FuseTapCancelFn = void Function(TapCancelEvent event);
typedef FuseLongTapDownFn = void Function(TapDownEvent event);

/// Mixin that enables the usage of tap fuses:
///
///   - [fuseTapDown]
///   - [fuseTapUp]
///   - [fuseTapCancel]
///   - [fuseLongTapDown]
mixin FuseTaps on Fuse, TapCallbacks {
  final _tapDownFns = <FuseTapDownFn>[];
  final _tapUpFns = <FuseTapUpFn>[];
  final _tapCancelFns = <FuseTapCancelFn>[];
  final _longTapDownFns = <FuseLongTapDownFn>[];

  @override
  @mustCallSuper
  void onTapDown(TapDownEvent event) {
    for (final fn in _tapDownFns) {
      fn(event);
    }
  }

  @override
  @mustCallSuper
  void onTapUp(TapUpEvent event) {
    for (final fn in _tapUpFns) {
      fn(event);
    }
  }

  @override
  @mustCallSuper
  void onTapCancel(TapCancelEvent event) {
    for (final fn in _tapCancelFns) {
      fn(event);
    }
  }

  @override
  @mustCallSuper
  void onLongTapDown(TapDownEvent event) {
    for (final fn in _longTapDownFns) {
      fn(event);
    }
  }
}

/// Calls [fn] when a tap down event occurs.
void fuseTapDown(FuseTapDownFn fn) {
  final component = fuseComponent<FuseTaps>();
  component._tapDownFns.add(fn);
}

/// Calls [fn] when a tap up event occurs.
void fuseTapUp(FuseTapUpFn fn) {
  final component = fuseComponent<FuseTaps>();
  component._tapUpFns.add(fn);
}

/// Calls [fn] when a tap cancel event occurs.
void fuseTapCancel(FuseTapCancelFn fn) {
  final component = fuseComponent<FuseTaps>();
  component._tapCancelFns.add(fn);
}

/// Calls [fn] when a long tap down event occurs.
void fuseLongTapDown(FuseLongTapDownFn fn) {
  final component = fuseComponent<FuseTaps>();
  component._longTapDownFns.add(fn);
}
