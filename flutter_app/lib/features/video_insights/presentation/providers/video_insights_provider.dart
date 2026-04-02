import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/video_insights_repository_impl.dart';
import '../../domain/entities/video_insight.dart';
import '../../domain/repositories/video_insights_repository.dart';

final Provider<VideoInsightsRepository> videoInsightsRepositoryProvider =
    Provider<VideoInsightsRepository>((Ref ref) {
      return VideoInsightsRepositoryImpl();
    });

final FutureProvider<List<VideoInsight>> videoInsightsProvider =
    FutureProvider<List<VideoInsight>>((Ref ref) {
      return ref.watch(videoInsightsRepositoryProvider).getVideoInsights();
    });
