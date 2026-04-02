import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/video_insight.dart';
import '../providers/video_insights_provider.dart';

class VideoInsightsScreen extends ConsumerWidget {
  const VideoInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<VideoInsight>> insights = ref.watch(
      videoInsightsProvider,
    );

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
              ElevatedButton(onPressed: null, child: const Text('Analyze')),
            ],
          ),
          const SizedBox(height: 18),
          const Text('Previously Analyzed', style: AppTextStyles.titleLarge),
          const SizedBox(height: 10),
          ...insights.when(
            data: (List<VideoInsight> items) {
              if (items.isEmpty) {
                return const <Widget>[
                  Text(
                    'No analyzed videos yet.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ];
              }

              return items.map((VideoInsight insight) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  ),
                  child: ListTile(
                    leading: const SizedBox(
                      width: 54,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                        ),
                        child: Icon(
                          Icons.play_circle_fill,
                          color: AppColors.accentGold,
                        ),
                      ),
                    ),
                    title: Text(insight.title, style: AppTextStyles.titleLarge),
                    subtitle: Text(
                      '${insight.channelName} • ${(insight.relevanceScore * 100).round()}% relevant',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                );
              }).toList();
            },
            loading: () => const <Widget>[CircularProgressIndicator()],
            error: (Object error, StackTrace stackTrace) => const <Widget>[
              Text(
                'Could not load video insights right now.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
