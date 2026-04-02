class LearningModule {
  const LearningModule({
    required this.id,
    required this.title,
    required this.description,
    required this.lessonCount,
    required this.estimatedMins,
    required this.hasQuiz,
    required this.progressPercent,
  });

  final String id;
  final String title;
  final String description;
  final int lessonCount;
  final int estimatedMins;
  final bool hasQuiz;
  final double progressPercent;

  LearningModule copyWith({double? progressPercent}) {
    return LearningModule(
      id: id,
      title: title,
      description: description,
      lessonCount: lessonCount,
      estimatedMins: estimatedMins,
      hasQuiz: hasQuiz,
      progressPercent: progressPercent ?? this.progressPercent,
    );
  }
}

class LessonEntity {
  const LessonEntity({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.content,
    required this.sortOrder,
    required this.readTimeSec,
  });

  final String id;
  final String moduleId;
  final String title;
  final String content;
  final int sortOrder;
  final int readTimeSec;
}

class QuizQuestionEntity {
  const QuizQuestionEntity({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String id;
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

class QuizEntity {
  const QuizEntity({
    required this.id,
    required this.moduleId,
    required this.questions,
    required this.totalQuestions,
    required this.passingScore,
  });

  final String id;
  final String moduleId;
  final List<QuizQuestionEntity> questions;
  final int totalQuestions;
  final int passingScore;
}

class LearningProgressEntity {
  const LearningProgressEntity({
    required this.moduleId,
    required this.completedLessons,
    required this.totalLessons,
    required this.progressPercent,
    required this.status,
  });

  final String moduleId;
  final List<String> completedLessons;
  final int totalLessons;
  final double progressPercent;
  final String status;
}
