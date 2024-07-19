import 'package:flame/timer.dart';
import 'package:flame_fuse/fuse.dart';

typedef FuseTimerFn = void Function();

/// Adds a Flame [Timer] to a [Fuse] component.
Timer fuseTimer(
  double limit,
  FuseTimerFn fn, {
  bool repeat = false,
  bool autoStart = true,
}) {
  final timer = Timer(
    limit,
    onTick: fn,
    repeat: repeat,
    autoStart: autoStart,
  );

  fuseUpdate(timer.update);
  return timer;
}
