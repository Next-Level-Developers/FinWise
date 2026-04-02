import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goals_repository.dart';

class GoalsRepositoryException implements Exception {
  const GoalsRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

class GoalsRepositoryImpl implements GoalsRepository {
  GoalsRepositoryImpl()
    : _firestore = FirebaseFirestore.instance,
      _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Stream<List<GoalEntity>> watchAll() {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw const GoalsRepositoryException('User not signed in');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('goals')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
          return snapshot.docs.map(_toGoalEntity).toList();
        })
        .handleError((Object error) {
          if (error is FirebaseException &&
              error.code == 'failed-precondition') {
            throw const GoalsRepositoryException(
              'Setting up goals data... please wait',
            );
          }
          if (error is FirebaseException) {
            throw GoalsRepositoryException(
              error.message ?? 'Unable to load goals right now.',
            );
          }
        });
  }

  @override
  Stream<GoalEntity?> watchGoalById(String goalId) {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw const GoalsRepositoryException('User not signed in');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('goals')
        .doc(goalId)
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> doc) {
          if (!doc.exists || doc.data() == null) {
            return null;
          }
          return _toGoalEntity(doc, id: doc.id);
        })
        .handleError((Object error) {
          if (error is FirebaseException &&
              error.code == 'failed-precondition') {
            throw const GoalsRepositoryException(
              'Setting up goals data... please wait',
            );
          }
          if (error is FirebaseException) {
            throw GoalsRepositoryException(
              error.message ?? 'Unable to load goal details right now.',
            );
          }
        });
  }

  @override
  Future<void> addContribution({
    required String goalId,
    required double amount,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw const GoalsRepositoryException('User not signed in');
    }

    final DocumentReference<Map<String, dynamic>> goalRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('goals')
        .doc(goalId);

    await _firestore.runTransaction((Transaction transaction) async {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await transaction
          .get(goalRef);
      if (!snapshot.exists || snapshot.data() == null) {
        throw const GoalsRepositoryException('Goal not found');
      }

      final Map<String, dynamic> data = snapshot.data()!;
      final double currentAmount =
          (data['currentAmount'] as num?)?.toDouble() ?? 0;
      final double targetAmount =
          (data['targetAmount'] as num?)?.toDouble() ?? 0;
      final double nextAmount = currentAmount + amount;
      final bool isCompleted = targetAmount > 0 && nextAmount >= targetAmount;

      transaction.update(goalRef, <String, dynamic>{
        'currentAmount': nextAmount,
        'progressPercent': targetAmount > 0
            ? ((nextAmount / targetAmount) * 100).clamp(0, 100)
            : 0,
        'completedDate': isCompleted ? FieldValue.serverTimestamp() : null,
        'status': isCompleted ? 'completed' : data['status'] ?? 'active',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  @override
  Future<void> createGoal(GoalEntity goal) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw const GoalsRepositoryException('User not signed in');
    }

    final CollectionReference<Map<String, dynamic>> goalsRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('goals');

    await goalsRef.add(_toMap(goal));
  }

  GoalEntity _toGoalEntity(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    String? id,
  }) {
    final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};
    final double targetAmount = (data['targetAmount'] as num?)?.toDouble() ?? 0;
    final double currentAmount =
        (data['currentAmount'] as num?)?.toDouble() ?? 0;
    final double progressPercent =
        (data['progressPercent'] as num?)?.toDouble() ??
        (targetAmount > 0 ? (currentAmount / targetAmount) * 100 : 0);

    return GoalEntity(
      id: id ?? doc.id,
      title: data['title'] as String? ?? 'Goal',
      emoji: data['emoji'] as String? ?? '🎯',
      category: data['category'] as String? ?? 'custom',
      target: targetAmount,
      currentAmount: currentAmount,
      progressPercent: progressPercent,
      startDate: (data['startDate'] as Timestamp?)?.toDate(),
      targetDate: (data['targetDate'] as Timestamp?)?.toDate(),
      completedDate: (data['completedDate'] as Timestamp?)?.toDate(),
      monthlyContribution: (data['monthlyContribution'] as num?)?.toDouble(),
      autoDeductFromBudget: data['autoDeductFromBudget'] as bool? ?? false,
      status: data['status'] as String? ?? 'active',
      priority: data['priority'] as String? ?? 'medium',
      aiSuggestion: data['aiSuggestion'] as String?,
      aiSuggestionAt: (data['aiSuggestionAt'] as Timestamp?)?.toDate(),
      milestones: _toMilestones(data['milestones'] as List<dynamic>?),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> _toMap(GoalEntity goal) {
    return <String, dynamic>{
      'id': goal.id.isEmpty ? null : goal.id,
      'title': goal.title,
      'emoji': goal.emoji,
      'category': goal.category,
      'targetAmount': goal.target,
      'currentAmount': goal.currentAmount,
      'progressPercent': goal.progressPercent,
      'startDate': goal.startDate != null
          ? Timestamp.fromDate(goal.startDate!)
          : FieldValue.serverTimestamp(),
      'targetDate': goal.targetDate != null
          ? Timestamp.fromDate(goal.targetDate!)
          : null,
      'completedDate': goal.completedDate != null
          ? Timestamp.fromDate(goal.completedDate!)
          : null,
      'monthlyContribution': goal.monthlyContribution,
      'autoDeductFromBudget': goal.autoDeductFromBudget,
      'status': goal.status,
      'priority': goal.priority,
      'aiSuggestion': goal.aiSuggestion,
      'aiSuggestionAt': goal.aiSuggestionAt != null
          ? Timestamp.fromDate(goal.aiSuggestionAt!)
          : null,
      'milestones': goal.milestones
          .map(
            (GoalMilestone milestone) => <String, dynamic>{
              'percent': milestone.percent,
              'reached': milestone.reached,
              'reachedAt': milestone.reachedAt != null
                  ? Timestamp.fromDate(milestone.reachedAt!)
                  : null,
              'celebrated': milestone.celebrated,
            },
          )
          .toList(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  List<GoalMilestone> _toMilestones(List<dynamic>? milestones) {
    if (milestones == null) {
      return <GoalMilestone>[];
    }
    return milestones.map((dynamic item) {
      final Map<String, dynamic> data = item as Map<String, dynamic>;
      return GoalMilestone(
        percent: (data['percent'] as num?)?.toInt() ?? 0,
        reached: data['reached'] as bool? ?? false,
        reachedAt: (data['reachedAt'] as Timestamp?)?.toDate(),
        celebrated: data['celebrated'] as bool? ?? false,
      );
    }).toList();
  }
}
