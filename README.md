# Fuse

Fuse is a library for writing [Flame](https://github.com/flame-engine/flame) component behavior in a composable way.

## Naming

The name `fuse` was selected because this method of functional composition is shared with React and Flutter hooks. With hooks, you `use` functions. With Flame hooks, you `fuse` functions instead.

## Usage

Instead of implementing callbacks, all behavior is added in the `fuse` method at load time. Any Flame component may use the `Fuse` mixin to gain access to this special method. All functions that add behavior inside the `fuse` method are prefixed with the word word `fuse*`.

TODO: further examples, comparisons, etc.

## Development

TODO.
