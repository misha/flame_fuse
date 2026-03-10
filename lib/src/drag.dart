import 'package:flame/events.dart';
import 'package:flame_fuse/src/core.dart';
import 'package:flutter/foundation.dart';

typedef FuseDragStartFn = void Function(DragStartEvent event);
typedef FuseDragUpdateFn = void Function(DragUpdateEvent event);
typedef FuseDragEndFn = void Function(DragEndEvent event);
typedef FuseDragCancelFn = void Function(DragCancelEvent event);

/// Mixin that enables the usage of drag fuses:
///
///   - [fuseDragStart]
///   - [fuseDragUpdate]
///   - [fuseDragEnd]
///   - [fuseDragCancel]
mixin FuseDrags on Fuse, DragCallbacks {
  final _dragStartFns = <FuseDragStartFn>[];
  final _dragUpdateFns = <FuseDragUpdateFn>[];
  final _dragEndFns = <FuseDragEndFn>[];
  final _dragCancelFns = <FuseDragCancelFn>[];

  @override
  @mustCallSuper
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    for (final fn in _dragStartFns) {
      fn(event);
    }
  }

  @override
  @mustCallSuper
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    for (final fn in _dragUpdateFns) {
      fn(event);
    }
  }

  @override
  @mustCallSuper
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    for (final fn in _dragEndFns) {
      fn(event);
    }
  }

  @override
  @mustCallSuper
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    for (final fn in _dragCancelFns) {
      fn(event);
    }
  }
}

/// Calls [fn] when a drag start event occurs.
void fuseDragStart(FuseDragStartFn fn) {
  final component = fuseComponent<FuseDrags>();
  component._dragStartFns.add(fn);
}

/// Calls [fn] when a drag update event occurs.
void fuseDragUpdate(FuseDragUpdateFn fn) {
  final component = fuseComponent<FuseDrags>();
  component._dragUpdateFns.add(fn);
}

/// Calls [fn] when a drag end event occurs.
void fuseDragEnd(FuseDragEndFn fn) {
  final component = fuseComponent<FuseDrags>();
  component._dragEndFns.add(fn);
}

/// Calls [fn] when a drag cancel event occurs.
void fuseDragCancel(FuseDragCancelFn fn) {
  final component = fuseComponent<FuseDrags>();
  component._dragCancelFns.add(fn);
}
