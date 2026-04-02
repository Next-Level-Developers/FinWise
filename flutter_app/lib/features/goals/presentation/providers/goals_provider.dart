import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<List<String>> goalsProvider = StateProvider<List<String>>(
  (Ref ref) => <String>[],
);
