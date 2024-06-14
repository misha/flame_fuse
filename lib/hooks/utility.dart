import 'package:flame/timer.dart';
import 'package:flame_hooks/flame_hooks.dart';

typedef FlameHookTimerFn = void Function();

Timer useFlameTimer(
  double limit,
  FlameHookTimerFn fn, {
  bool repeat = true,
}) {
  final timer = Timer(
    limit,
    onTick: fn,
    repeat: repeat,
  );

  useFlameUpdate(timer.update);
  return timer;
}
