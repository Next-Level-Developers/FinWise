import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'or continue with',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}
