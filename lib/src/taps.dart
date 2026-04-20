import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

import 'package:flame_fuse/src/core.dart';

//
// Taps
//

typedef FuseTapDownFn = Function(TapDownEvent event);
typedef FuseTapUpFn = Function(TapUpEvent event);
typedef FuseTapCancelFn = Function(TapCancelEvent event);
typedef FuseLongTapDownFn = Function(TapDownEvent event);

/// Mixin that enables the usage of `fuseTap*` fuses.
mixin FuseTaps on Fuse, TapCallbacks {
  final _tapDownFns = <FuseTapDownFn>[];
  final _tapUpFns = <FuseTapUpFn>[];
  final _tapCancelFns = <FuseTapCancelFn>[];
  final _longTapDownFns = <FuseLongTapDownFn>[];

  @override
  @mustCallSuper
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    for (final fn in _tapDownFns) {
      fn(event);
    }
  }

  @override
  @mustCallSuper
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);

    for (final fn in _tapUpFns) {
      fn(event);
    }
  }

  @override
  @mustCallSuper
  void onTapCancel(TapCancelEvent event) {
    super.onTapCancel(event);

    for (final fn in _tapCancelFns) {
      fn(event);
    }
  }

  @override
  @mustCallSuper
  void onLongTapDown(TapDownEvent event) {
    super.onLongTapDown(event);

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

//
// Double Taps
//

typedef FuseDoubleTapDownFn = Function(DoubleTapDownEvent event);
typedef FuseDoubleTapUpFn = Function(DoubleTapEvent event);
typedef FuseDoubleTapCancelFn = Function(DoubleTapCancelEvent event);

/// Mixin that enables the usage of `fuseDoubleTap*` fuses.
mixin FuseDoubleTaps on Fuse, DoubleTapCallbacks {
  final _tapDownFns = <FuseDoubleTapDownFn>[];
  final _tapUpFns = <FuseDoubleTapUpFn>[];
  final _tapCancelFns = <FuseDoubleTapCancelFn>[];

  @override
  @mustCallSuper
  void onDoubleTapDown(DoubleTapDownEvent event) {
    super.onDoubleTapDown(event);

    for (final fn in _tapDownFns) {
      fn(event);
    }
  }

  @override
  @mustCallSuper
  void onDoubleTapUp(DoubleTapEvent event) {
    super.onDoubleTapUp(event);

    for (final fn in _tapUpFns) {
      fn(event);
    }
  }

  @override
  @mustCallSuper
  void onDoubleTapCancel(DoubleTapCancelEvent event) {
    super.onDoubleTapCancel(event);

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

/// Calls [fn] when a double-tap (up) event occurs.
void fuseDoubleTapUp(FuseDoubleTapUpFn fn) {
  final component = fuseComponent<FuseDoubleTaps>();
  component._tapUpFns.add(fn);
}

/// Calls [fn] when a double-tap cancel event occurs.
void fuseDoubleTapCancel(FuseDoubleTapCancelFn fn) {
  final component = fuseComponent<FuseDoubleTaps>();
  component._tapCancelFns.add(fn);
}

//
// Secondary Taps
//

typedef FuseSecondaryTapDownFn = Function(SecondaryTapDownEvent event);
typedef FuseSecondaryTapUpFn = Function(SecondaryTapUpEvent event);
typedef FuseSecondaryTapCancelFn = Function(SecondaryTapCancelEvent event);

/// Mixin that enables the usage of `fuseSecondaryTap*` fuses.
mixin FuseSecondaryTaps on Fuse, SecondaryTapCallbacks {
  final _tapDownFns = <FuseSecondaryTapDownFn>[];
  final _tapUpFns = <FuseSecondaryTapUpFn>[];
  final _tapCancelFns = <FuseSecondaryTapCancelFn>[];

  @override
  @mustCallSuper
  void onSecondaryTapDown(SecondaryTapDownEvent event) {
    super.onSecondaryTapDown(event);

    for (final fn in _tapDownFns) {
      fn(event);
    }
  }

  @override
  @mustCallSuper
  void onSecondaryTapUp(SecondaryTapUpEvent event) {
    super.onSecondaryTapUp(event);

    for (final fn in _tapUpFns) {
      fn(event);
    }
  }

  @override
  @mustCallSuper
  void onSecondaryTapCancel(SecondaryTapCancelEvent event) {
    super.onSecondaryTapCancel(event);

    for (final fn in _tapCancelFns) {
      fn(event);
    }
  }
}

/// Calls [fn] when a secondary tap down event occurs.
void fuseSecondaryTapDown(FuseSecondaryTapDownFn fn) {
  final component = fuseComponent<FuseSecondaryTaps>();
  component._tapDownFns.add(fn);
}

/// Calls [fn] when a secondary tap up event occurs.
void fuseSecondaryTapUp(FuseSecondaryTapUpFn fn) {
  final component = fuseComponent<FuseSecondaryTaps>();
  component._tapUpFns.add(fn);
}

/// Calls [fn] when a secondary tap cancel event occurs.
void fuseSecondaryTapCancel(FuseSecondaryTapCancelFn fn) {
  final component = fuseComponent<FuseSecondaryTaps>();
  component._tapCancelFns.add(fn);
}
