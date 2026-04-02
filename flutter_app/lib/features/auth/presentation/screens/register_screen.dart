import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/app_routes.dart';
import '../widgets/auth_divider.dart';
import '../widgets/google_sign_in_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
              IconButton(
                onPressed: context.pop,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create Account',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Set up your FinWise profile in a minute.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              const TextField(
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(hintText: 'Name'),
              ),
              const SizedBox(height: 12),
              const TextField(
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(hintText: 'Email'),
              ),
              const SizedBox(height: 12),
              const TextField(
                obscureText: true,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(hintText: 'Password'),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: const LinearProgressIndicator(
                  value: 0.62,
                  minHeight: 8,
                  backgroundColor: Color(0x22F87171),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.accentGold,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Password strength: Fair',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.onboarding),
                child: const Text('Create Account'),
              ),
              const SizedBox(height: 18),
              const AuthDivider(),
              const SizedBox(height: 18),
              GoogleSignInButton(
                onPressed: () => context.go(AppRoutes.onboarding),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: context.pop,
                  child: const Text(
                    'Already have an account? Sign In',
                    style: TextStyle(color: AppColors.textSecondary),
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
