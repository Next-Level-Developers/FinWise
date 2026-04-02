import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/learning_module.dart';
import '../../domain/repositories/learn_repository.dart';

class LearnRepositoryException implements Exception {
  const LearnRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

class LearnRepositoryImpl implements LearnRepository {
  LearnRepositoryImpl()
    : _firestore = FirebaseFirestore.instance,
      _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Future<List<LearningModule>> getModules() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('learning_modules')
          .where('isPublished', isEqualTo: true)
          .orderBy('sortOrder')
          .get();

      return snapshot.docs.map((
        QueryDocumentSnapshot<Map<String, dynamic>> doc,
      ) {
        final Map<String, dynamic> data = doc.data();
        return LearningModule(
          id: doc.id,
          title: (data['title'] as String?) ?? 'Untitled module',
          description: (data['description'] as String?) ?? '',
          lessonCount: (data['lessonCount'] as num?)?.toInt() ?? 0,
          estimatedMins: (data['estimatedMins'] as num?)?.toInt() ?? 0,
          hasQuiz: (data['hasQuiz'] as bool?) ?? false,
          progressPercent: 0,
        );
      }).toList();
    } on FirebaseException catch (error) {
      throw _mapFirestoreError(error);
    }
  }

  @override
  Future<LearningModule?> getModuleById({required String moduleId}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('learning_modules')
          .doc(moduleId)
          .get();

      if (!doc.exists) {
        return null;
      }

      final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};
      return LearningModule(
        id: doc.id,
        title: (data['title'] as String?) ?? 'Untitled module',
        description: (data['description'] as String?) ?? '',
        lessonCount: (data['lessonCount'] as num?)?.toInt() ?? 0,
        estimatedMins: (data['estimatedMins'] as num?)?.toInt() ?? 0,
        hasQuiz: (data['hasQuiz'] as bool?) ?? false,
        progressPercent: 0,
      );
    } on FirebaseException catch (error) {
      throw _mapFirestoreError(error);
    }
  }

  @override
  Future<List<LessonEntity>> getLessons({required String moduleId}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('learning_modules')
          .doc(moduleId)
          .collection('lessons')
          .orderBy('sortOrder')
          .get();

      return snapshot.docs.map((
        QueryDocumentSnapshot<Map<String, dynamic>> doc,
      ) {
        final Map<String, dynamic> data = doc.data();
        return LessonEntity(
          id: doc.id,
          moduleId: moduleId,
          title: (data['title'] as String?) ?? 'Untitled lesson',
          content: (data['content'] as String?) ?? '',
          sortOrder: (data['sortOrder'] as num?)?.toInt() ?? 0,
          readTimeSec: (data['readTimeSec'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    } on FirebaseException catch (error) {
      throw _mapFirestoreError(error);
    }
  }

  @override
  Future<QuizEntity?> getQuiz({required String moduleId}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('learning_modules')
          .doc(moduleId)
          .collection('quizzes')
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      final QueryDocumentSnapshot<Map<String, dynamic>> doc =
          snapshot.docs.first;
      final Map<String, dynamic> data = doc.data();
      final List<dynamic> rawQuestions =
          (data['questions'] as List<dynamic>?) ?? <dynamic>[];

      final List<QuizQuestionEntity> questions = rawQuestions.map((
        dynamic item,
      ) {
        final Map<String, dynamic> question = (item as Map<String, dynamic>);
        return QuizQuestionEntity(
          id: (question['id'] as String?) ?? '',
          questionText: (question['questionText'] as String?) ?? '',
          options: ((question['options'] as List<dynamic>?) ?? <dynamic>[])
              .map((dynamic option) => option.toString())
              .toList(),
          correctIndex: (question['correctIndex'] as num?)?.toInt() ?? 0,
          explanation: (question['explanation'] as String?) ?? '',
        );
      }).toList();

      return QuizEntity(
        id: doc.id,
        moduleId: moduleId,
        questions: questions,
        totalQuestions:
            (data['totalQuestions'] as num?)?.toInt() ?? questions.length,
        passingScore: (data['passingScore'] as num?)?.toInt() ?? 70,
      );
    } on FirebaseException catch (error) {
      throw _mapFirestoreError(error);
    }
  }

  @override
  Future<Map<String, LearningProgressEntity>> getAllProgress() async {
    final User user = _currentUser();

    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('learning_progress')
          .get();

      final Map<String, LearningProgressEntity> progressByModule =
          <String, LearningProgressEntity>{};
      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in snapshot.docs) {
        progressByModule[doc.id] = _mapProgressDoc(doc.id, doc.data());
      }
      return progressByModule;
    } on FirebaseException catch (error) {
      throw _mapFirestoreError(error);
    }
  }

  @override
  Future<LearningProgressEntity> getProgress({required String moduleId}) async {
    final User user = _currentUser();

    try {
      final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('learning_progress')
          .doc(moduleId)
          .get();

      if (!doc.exists) {
        return LearningProgressEntity(
          moduleId: moduleId,
          completedLessons: const <String>[],
          totalLessons: 0,
          progressPercent: 0,
          status: 'not_started',
        );
      }

      return _mapProgressDoc(moduleId, doc.data() ?? <String, dynamic>{});
    } on FirebaseException catch (error) {
      throw _mapFirestoreError(error);
    }
  }

  @override
  Future<void> completeLesson({
    required String moduleId,
    required String lessonId,
    required int totalLessons,
  }) async {
    final User user = _currentUser();
    final DocumentReference<Map<String, dynamic>> progressRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('learning_progress')
        .doc(moduleId);

    try {
      await _firestore.runTransaction((Transaction transaction) async {
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await transaction.get(progressRef);

        final Map<String, dynamic> existing =
            snapshot.data() ?? <String, dynamic>{};
        final List<String> completedLessons =
            ((existing['completedLessons'] as List<dynamic>?) ?? <dynamic>[])
                .map((dynamic id) => id.toString())
                .toSet()
                .toList();

        if (!completedLessons.contains(lessonId)) {
          completedLessons.add(lessonId);
        }

        final int safeTotalLessons = totalLessons > 0
            ? totalLessons
            : ((existing['totalLessons'] as num?)?.toInt() ?? 0);
        final double progressPercent = safeTotalLessons == 0
            ? 0
            : (completedLessons.length / safeTotalLessons) * 100;

        final String status = progressPercent >= 100
            ? 'completed'
            : (completedLessons.isEmpty ? 'not_started' : 'in_progress');

        transaction.set(progressRef, <String, dynamic>{
          'moduleId': moduleId,
          'status': status,
          'completedLessons': completedLessons,
          'totalLessons': safeTotalLessons,
          'progressPercent': progressPercent,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });
    } on FirebaseException catch (error) {
      throw _mapFirestoreError(error);
    }
  }

  LearningProgressEntity _mapProgressDoc(
    String moduleId,
    Map<String, dynamic> data,
  ) {
    return LearningProgressEntity(
      moduleId: moduleId,
      completedLessons:
          ((data['completedLessons'] as List<dynamic>?) ?? <dynamic>[])
              .map((dynamic id) => id.toString())
              .toList(),
      totalLessons: (data['totalLessons'] as num?)?.toInt() ?? 0,
      progressPercent: (data['progressPercent'] as num?)?.toDouble() ?? 0,
      status: (data['status'] as String?) ?? 'not_started',
    );
  }

  LearnRepositoryException _mapFirestoreError(FirebaseException error) {
    if (error.code == 'failed-precondition' ||
        (error.message ?? '').contains('failed-precondition')) {
      return const LearnRepositoryException(
        'Setting up learning content… please wait',
      );
    }

    return LearnRepositoryException(
      error.message ?? 'Unable to load learning content right now.',
    );
  }

  User _currentUser() {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw StateError('User not signed in');
    }
    return user;
  }
}
