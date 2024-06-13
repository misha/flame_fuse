import 'package:flutter/widgets.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import 'stories/snake_game_story.dart';
import 'stories/spinning_square_story.dart';

void main() {
  runApp(FlameHooksStorybook());
}

class FlameHooksStorybook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Storybook(
      initialStory: SNAKE_GAME_STORY.name,
      stories: [
        SNAKE_GAME_STORY,
        SPINNING_SQUARE_STORY,
      ],
    );
  }
}
