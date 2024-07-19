import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

KnobsBuilder useKnobs() {
  return useContext().knobs;
}
