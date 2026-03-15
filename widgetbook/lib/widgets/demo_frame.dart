import 'package:flutter/material.dart';

import 'package:flame_fuse_widgetbook/widgets/source_code_button.dart';

class DemoFrame extends StatelessWidget {
  const DemoFrame({
    required this.name,
    required this.child,
  });

  final String name;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: child),
        Align(
          alignment: .bottomCenter,
          child: Padding(
            padding: .all(20),
            child: SourceCodeButton(name),
          ),
        ),
      ],
    );
  }
}
