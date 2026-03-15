// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flame_fuse_widgetbook/stories/demos/bouncing_balls.dart'
    as _flame_fuse_widgetbook_stories_demos_bouncing_balls;
import 'package:flame_fuse_widgetbook/stories/demos/spinning_square.dart'
    as _flame_fuse_widgetbook_stories_demos_spinning_square;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookComponent(
    name: 'Fuse',
    useCases: [
      _widgetbook.WidgetbookUseCase(
        name: 'Bouncing Balls',
        builder: _flame_fuse_widgetbook_stories_demos_bouncing_balls
            .buildBouncingBallsDemo,
      ),
      _widgetbook.WidgetbookUseCase(
        name: 'Spinning Square',
        builder: _flame_fuse_widgetbook_stories_demos_spinning_square
            .buildSpinningSquareDemo,
      ),
    ],
  ),
];
