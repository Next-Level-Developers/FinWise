import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({
    super.key,
    required this.sectionTitle,
    required this.fields,
    this.onEdit,
  });

  final String sectionTitle;
  final VoidCallback? onEdit;
  final List<ProfileField> fields;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(sectionTitle, style: AppTextStyles.titleLarge),
            if (onEdit != null)
              GestureDetector(
                onTap: onEdit,
                child: Text(
                  'Edit',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          ),
          child: Column(
            children: fields.asMap().entries.map((
              MapEntry<int, ProfileField> entry,
            ) {
              final bool isLast = entry.key == fields.length - 1;
              return Column(
                children: <Widget>[
                  _ProfileFieldTile(field: entry.value),
                  if (!isLast)
                    const Divider(
                      height: 1,
                      indent: 52,
                      endIndent: 0,
                      color: AppColors.divider,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ProfileFieldTile extends StatelessWidget {
  const _ProfileFieldTile({required this.field});

  final ProfileField field;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingM,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            field.icon,
            size: AppDimensions.iconS,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(field.label, style: AppTextStyles.fieldLabel),
                const SizedBox(height: 2),
                Text(field.value, style: AppTextStyles.fieldValue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileField {
  const ProfileField({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}
