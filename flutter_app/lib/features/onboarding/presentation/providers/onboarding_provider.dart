import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<int> onboardingStepProvider = StateProvider<int>(
  (Ref ref) => 0,
);
