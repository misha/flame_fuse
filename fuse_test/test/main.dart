import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import 'stories/spinning_square_story.dart';

const _SHARED_PREFERENCES_KEY_STORY = '_story';

void main() async {
  final sp = await SharedPreferences.getInstance();
  runApp(FuseStorybook(sp));
}

class FuseStorybook extends StatelessWidget {
  final SharedPreferences sp;

  const FuseStorybook(this.sp);

  @override
  Widget build(BuildContext context) {
    return Storybook(
      initialStory: sp.getString(_SHARED_PREFERENCES_KEY_STORY),
      wrapperBuilder: (context, child) {
        final notifier = context.read<StoryNotifier>();
        sp.setString(_SHARED_PREFERENCES_KEY_STORY, notifier.currentStoryName ?? '');
        return SafeArea(child: child!);
      },
      stories: [
        SPINNING_SQUARE_STORY,
      ]..sort((a, b) => a.name.compareTo(b.name)),
    );
  }
}
