import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<List<String>> chatSessionsProvider = StateProvider<List<String>>(
  (Ref ref) => <String>[],
);
