import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/common_app_bar.dart';
import '../../../widgets/settings_tile.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _twoStepVerification = false;
  bool _antiScreenshot = true;
  bool _biometricLock = true;
  bool _appLock = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Security'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Account Security',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                ),
          ),
          const SizedBox(height: 12),
          SettingsTile(
            title: 'Two-Step Verification',
            subtitle: _twoStepVerification ? 'Enabled' : 'Disabled',
            icon: LucideIcons.shieldCheck,
            iconColor: AppColors.success,
            trailing: Switch(
              value: _twoStepVerification,
              onChanged: (value) => setState(() => _twoStepVerification = value),
              activeColor: AppColors.electricBlue,
            ),
            showArrow: false,
            onTap: () {},
          ),
          SettingsTile(
            title: 'Change Number',
            subtitle: 'Update your phone number',
            icon: LucideIcons.phone,
            onTap: () {},
          ),
          const SizedBox(height: 24),
          Text(
            'App Security',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                ),
          ),
          const SizedBox(height: 12),
          SettingsTile(
            title: 'Anti-Screenshot Mode',
            subtitle: _antiScreenshot ? 'Protected' : 'Not Protected',
            icon: LucideIcons.shieldAlert,
            iconColor: AppColors.violet,
            trailing: Switch(
              value: _antiScreenshot,
              onChanged: (value) => setState(() => _antiScreenshot = value),
              activeColor: AppColors.electricBlue,
            ),
            showArrow: false,
            onTap: () {},
          ),
          SettingsTile(
            title: 'Biometric Lock',
            subtitle: _biometricLock ? 'Face ID Enabled' : 'Disabled',
            icon: LucideIcons.fingerprint,
            trailing: Switch(
              value: _biometricLock,
              onChanged: (value) => setState(() => _biometricLock = value),
              activeColor: AppColors.electricBlue,
            ),
            showArrow: false,
            onTap: () {},
          ),
          SettingsTile(
            title: 'App Lock PIN',
            subtitle: _appLock ? 'Enabled' : 'Disabled',
            icon: LucideIcons.lock,
            trailing: Switch(
              value: _appLock,
              onChanged: (value) => setState(() => _appLock = value),
              activeColor: AppColors.electricBlue,
            ),
            showArrow: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
