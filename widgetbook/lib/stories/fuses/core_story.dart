import 'package:flame_fuse/flame_fuse.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default', type: Fuse)
Widget buildFuseStory(BuildContext context) {
  return Center(
    child: Text(
      'TODO',
      style: .new(color: Colors.white),
    ),
  );
}
