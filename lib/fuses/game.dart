import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_fuse/fuse.dart';

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
