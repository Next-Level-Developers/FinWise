import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        Icons.g_mobiledata_rounded,
        size: 26,
        color: AppColors.textPrimary,
      ),
      label: const Text(
        'Continue with Google',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
