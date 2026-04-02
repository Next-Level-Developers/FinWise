import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Budget Analysis — Oct'),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Chip(label: Text('Budget')),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            color: AppColors.surfaceSubtle,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('General', style: AppTextStyles.bodySmall),
                Text('Budget', style: AppTextStyles.titleLarge),
                Text('Investment', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              children: const <Widget>[
                _Bubble(
                  text: 'Can you summarize my spending this month?',
                  isUser: true,
                ),
                SizedBox(height: 10),
                _Bubble(
                  text:
                      'Food and transport are leading. Reducing two delivery orders per week could free up around ₹1,200.',
                  isUser: false,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Ask FinWise...'),
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.send, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.isUser});

  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: isUser ? const Color(0x334ECDC4) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: isUser ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: AppColors.textPrimary, height: 1.45),
        ),
      ),
    );
  }
}
