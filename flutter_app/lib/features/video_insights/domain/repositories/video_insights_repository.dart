import '../entities/video_insight.dart';

abstract class VideoInsightsRepository {
  Future<List<VideoInsight>> getVideoInsights();
}
