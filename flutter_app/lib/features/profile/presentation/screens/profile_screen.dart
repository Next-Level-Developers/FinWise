import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/profile_info.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_avatar_section.dart';
import '../widgets/profile_info_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ProfileInfo> profile = ref.watch(profileInfoProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: profile.when(
          data: (ProfileInfo data) => SingleChildScrollView(
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
                      value: data.name,
                    ),
                    ProfileField(
                      icon: Icons.email_outlined,
                      label: 'E-mail',
                      value: data.email,
                    ),
                    ProfileField(
                      icon: Icons.phone_outlined,
                      label: 'Phone number',
                      value: data.phone,
                    ),
                    ProfileField(
                      icon: Icons.home_outlined,
                      label: 'Home address',
                      value: data.address,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingM),
                ProfileInfoCard(
                  sectionTitle: 'Account info',
                  fields: <ProfileField>[
                    ProfileField(
                      icon: Icons.badge_outlined,
                      label: 'Account type',
                      value: data.accountType,
                    ),
                    ProfileField(
                      icon: Icons.calendar_today_outlined,
                      label: 'Member since',
                      value: data.memberSince,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Your Scheme Eligibility',
                        style: AppTextStyles.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: data.eligibilityTags.isEmpty
                            ? const <Widget>[Chip(label: Text('No tags yet'))]
                            : data.eligibilityTags
                                  .map<Widget>(
                                    (String tag) => Chip(label: Text(tag)),
                                  )
                                  .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingM),
                OutlinedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      context.go(AppRoutes.login);
                    }
                  },
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
