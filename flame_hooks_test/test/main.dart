import 'package:flutter/widgets.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import 'stories/spinning_square_story.dart';

void main() {
  runApp(FlameHooksStorybook());
}

class FlameHooksStorybook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Storybook(
      stories: [
        SPINNING_SQUARE_STORY,
      ],
    );
  }
}
