import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Future<UserEntity?> signIn(String email, String password) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final User? user = credential.user;
    if (user == null) {
      return null;
    }

    await _firestore.collection('users').doc(user.uid).set(<String, dynamic>{
      'lastActiveAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isEmailVerified': user.emailVerified,
    }, SetOptions(merge: true));

    return _toUserEntity(user);
  }

  Future<UserEntity?> signUp(String email, String password) async {
    final UserCredential credential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);

    final User? user = credential.user;
    if (user == null) {
      return null;
    }

    final String fallbackName = email.split('@').first;
    await _firestore.collection('users').doc(user.uid).set(<String, dynamic>{
      'uid': user.uid,
      'email': user.email ?? email,
      'displayName': user.displayName ?? fallbackName,
      'photoURL': user.photoURL,
      'phoneNumber': user.phoneNumber,
      'isEmailVerified': user.emailVerified,
      'isOnboardingComplete': false,
      'currency': 'INR',
      'notificationsEnabled': true,
      'biometricEnabled': false,
      'theme': 'system',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'lastActiveAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return _toUserEntity(user);
  }

  Future<void> signOut() => _auth.signOut();

  Stream<UserEntity?> watchAuthState() =>
      _auth.authStateChanges().map((User? user) {
        if (user == null) {
          return null;
        }
        return _toUserEntity(user);
      });

  UserEntity _toUserEntity(User user) {
    final String email = user.email ?? '';
    return UserEntity(
      id: user.uid,
      email: email,
      displayName: user.displayName ?? email.split('@').first,
    );
  }
}
