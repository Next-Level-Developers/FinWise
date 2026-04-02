import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class AiChatListScreen extends StatelessWidget {
  const AiChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Assistant'),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.auto_awesome, color: AppColors.accentPurple),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accentPurple,
        onPressed: () {},
        label: const Text('New Chat', style: TextStyle(color: Colors.black)),
        icon: const Icon(Icons.auto_awesome, color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: const ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0x26A78BFA),
                child: Icon(Icons.smart_toy, color: AppColors.accentPurple),
              ),
              title: Text(
                'Budget Analysis - October',
                style: AppTextStyles.titleLarge,
              ),
              subtitle: Text(
                'You can reduce food spend by 8% and shift that room into your emergency fund.',
                style: TextStyle(color: AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                'Budget',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
