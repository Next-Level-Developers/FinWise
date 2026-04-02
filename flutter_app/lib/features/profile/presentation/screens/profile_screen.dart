import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_avatar_section.dart';
import '../widgets/profile_info_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<dynamic> profile = ref.watch(profileInfoProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: profile.when(
          data: (dynamic data) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingL,
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(height: AppDimensions.paddingL),
                const ProfileAvatarSection(),
                const SizedBox(height: AppDimensions.paddingXL),
                ProfileInfoCard(
                  sectionTitle: 'Personal info',
                  onEdit: () {},
                  fields: <ProfileField>[
                    ProfileField(
                      icon: Icons.person_outline_rounded,
                      label: 'Name',
                      value: data.name as String,
                    ),
                    ProfileField(
                      icon: Icons.email_outlined,
                      label: 'E-mail',
                      value: data.email as String,
                    ),
                    ProfileField(
                      icon: Icons.phone_outlined,
                      label: 'Phone number',
                      value: data.phone as String,
                    ),
                    ProfileField(
                      icon: Icons.home_outlined,
                      label: 'Home address',
                      value: data.address as String,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingM),
                const ProfileInfoCard(
                  sectionTitle: 'Account info',
                  fields: <ProfileField>[
                    ProfileField(
                      icon: Icons.badge_outlined,
                      label: 'Account type',
                      value: 'FinWise Pro',
                    ),
                    ProfileField(
                      icon: Icons.calendar_today_outlined,
                      label: 'Member since',
                      value: 'January 2024',
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingM),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Your Scheme Eligibility',
                        style: AppTextStyles.titleLarge,
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          Chip(label: Text('Salaried')),
                          Chip(label: Text('Tax Saver')),
                          Chip(label: Text('Emergency Fund')),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingM),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    side: const BorderSide(color: AppColors.error),
                  ),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Text('Could not load profile: $error'),
            ),
          ),
        ),
      ),
    );
  }
}
