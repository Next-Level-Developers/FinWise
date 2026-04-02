class SchemeEntity {
  const SchemeEntity({
    required this.id,
    required this.name,
    required this.tagline,
    required this.emoji,
    required this.matchScore,
  });

  final String id;
  final String name;
  final String tagline;
  final String emoji;
  final int matchScore;
}
