import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class VideoInsightsScreen extends StatelessWidget {
  const VideoInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Video Insights')),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        children: <Widget>[
          Row(
            children: <Widget>[
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.ondemand_video,
                      color: Colors.redAccent,
                    ),
                    hintText: 'Paste YouTube URL...',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: () {}, child: const Text('Analyze')),
            ],
          ),
          const SizedBox(height: 18),
          const Text('Previously Analyzed', style: AppTextStyles.titleLarge),
          const SizedBox(height: 10),
          ...List<Widget>.generate(3, (int i) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
              child: const ListTile(
                leading: SizedBox(
                  width: 54,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: AppColors.surfaceElevated),
                    child: Icon(
                      Icons.play_circle_fill,
                      color: AppColors.accentGold,
                    ),
                  ),
                ),
                title: Text(
                  'How to Build an Emergency Fund',
                  style: AppTextStyles.titleLarge,
                ),
                subtitle: Text(
                  'Finance Today • 92% relevant',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
