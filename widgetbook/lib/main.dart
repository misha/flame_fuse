import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

// ignore: always_use_package_imports
import 'main.directories.g.dart';

void main() async {
  runApp(const FuseWidgetbookApp());
}

@App()
class FuseWidgetbookApp extends StatelessWidget {
  const FuseWidgetbookApp();

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      themeMode: .dark,
      darkTheme: .dark(),
      addons: [InspectorAddon()],
    );
  }
}
