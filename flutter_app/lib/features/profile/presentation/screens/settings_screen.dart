import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometric = true;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        children: <Widget>[
          _section('APPEARANCE'),
          _tile(
            'Theme',
            trailing: const Text(
              'Dark',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
          _tile('Language', trailing: const Icon(Icons.chevron_right)),
          const SizedBox(height: 14),
          _section('SECURITY'),
          SwitchListTile(
            value: _biometric,
            onChanged: (bool value) => setState(() => _biometric = value),
            title: const Text('Biometric Login'),
            activeThumbColor: AppColors.primary,
          ),
          const SizedBox(height: 14),
          _section('NOTIFICATIONS'),
          SwitchListTile(
            value: _notifications,
            onChanged: (bool value) => setState(() => _notifications = value),
            title: const Text('Push Notifications'),
            activeThumbColor: AppColors.primary,
          ),
          const SizedBox(height: 14),
          _section('PREFERENCES'),
          _tile(
            'Currency Format',
            trailing: const Text(
              'INR (₹)',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 14),
          _section('LEGAL'),
          _tile('Privacy Policy', trailing: const Icon(Icons.open_in_new)),
          _tile('Terms of Service', trailing: const Icon(Icons.open_in_new)),
          const SizedBox(height: 14),
          _section('DANGER ZONE'),
          _tile(
            'Delete Account',
            titleColor: AppColors.error,
            trailing: const Icon(Icons.chevron_right, color: AppColors.error),
          ),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 11,
          letterSpacing: 0.8,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _tile(
    String title, {
    Widget? trailing,
    Color titleColor = AppColors.textPrimary,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: titleColor, fontWeight: FontWeight.w500),
            ),
          ),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
