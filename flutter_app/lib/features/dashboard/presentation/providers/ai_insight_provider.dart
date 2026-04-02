import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/ai_insight.dart';

final FutureProvider<AiInsight> aiInsightProvider = FutureProvider<AiInsight>(
  (Ref ref) async => const AiInsight(summary: 'No insights yet.'),
);
