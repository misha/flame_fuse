import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

const _SOURCE_BASE_URL = 'https://github.com/misha/flame_fuse/blob/master/widgetbook/lib/stories';

class SourceCodeButton extends StatelessWidget {
  const SourceCodeButton(this.name) : url = '$_SOURCE_BASE_URL/$name.dart';

  final String name;
  final String url;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () => launchUrlString(url),
      child: Text('Source Code'),
    );
  }
}
