class VideoInsight {
  const VideoInsight({
    required this.id,
    required this.title,
    required this.channelName,
    required this.relevanceScore,
  });

  final String id;
  final String title;
  final String channelName;
  final double relevanceScore;
}
