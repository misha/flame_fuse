# Changelog

## 3.0.1

* new: Loosened the constraints on `fuseGame` to allow for non-`FlameGame` access, e.g. a `Forge2DGame`. As a result, `fuseCamera` and `fuseWorld` now both require a `FlameGame` internally.

## 3.0.0

* new: Implement `fuseCollisionEffect`, `fuseCollisionEffectPoints`, `fuseDragEffect`, and `fuseHoverEffect`. These are the `useEffect` equivalents of this library, allowing you to return a cleanup function that is called automatically.
* new: Implement `fuseParentResize`.
* remove: The `fuseTimer` fuse was pointless and has been removed. Add timers to the component tree instead.
* refactor: Fuses that were previously `void` are now `dynamic`.
* docs: Improve the documentation on various functions.
* docs: Simplify documentation on fuse mixins for maintenance purposes.
* docs: Rewrite the Storybook into a combination documentation/usage example Widgetbook deployed to `misha.jp`.

## 2.0.1

* new: Implement `fuseMount` for adding callbacks to `onMount`.

## 2.0.0

* refactor: Move private classes, etc. into `src/` and expose the main library from `flame_fuse.dart` per standard Dart library conventions.
* new: Implement fuses for managing drags.

## 1.0.3

* revert: Reverts the zone removal in change 1.0.2 as it seems to break `async` components occasionally.

## 1.0.2

* refactor: Remove zone-based `fuseComponent` implementation in favor of a global variable.

## 1.0.1

* fix: Forgot to implement `fuseResize`.

## 1.0.0

* new: Write the original set of fuses and first version of the README as documentation.
