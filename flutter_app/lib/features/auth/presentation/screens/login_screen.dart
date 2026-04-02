import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  static const String _demoEmail = 'projects.nextleveldevelopers@gmail.com';
  static const String _demoPassword = 'Pushkar@123';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _attemptSignIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _showMessage('Email and password are required.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signInWithEmail(email, password);
      if (!mounted) {
        return;
      }
      context.go(AppRoutes.dashboard);
    } on FirebaseAuthException catch (error) {
      _showMessage(_mapFirebaseAuthError(error));
    } catch (_) {
      _showMessage('Sign in failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signIn() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    await _attemptSignIn(email, password);
  }

  Future<void> _demoSignIn() async {
    await _attemptSignIn(_demoEmail, _demoPassword);
  }

  String _mapFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Invalid email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return error.message ?? 'Sign in failed.';
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 36),
              const Text(
                'FinWise',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isLoading ? null : _signIn,
                child: Text(_isLoading ? 'Signing In...' : 'Sign In'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _isLoading ? null : _demoSignIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  shadowColor: AppColors.primary.withAlpha((0.6 * 255).round()),
                  side: const BorderSide(color: AppColors.primary, width: 1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(_isLoading ? 'Signing In...' : 'Demo Login'),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => context.push(AppRoutes.register),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
