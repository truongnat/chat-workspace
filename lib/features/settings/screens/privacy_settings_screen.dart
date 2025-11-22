import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/common_app_bar.dart';
import '../../../widgets/settings_tile.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _lastSeen = true;
  bool _profilePhoto = true;
  bool _readReceipts = true;
  bool _onlineStatus = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Privacy'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Who can see my personal info',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                ),
          ),
          const SizedBox(height: 12),
          SettingsTile(
            title: 'Last Seen',
            subtitle: _lastSeen ? 'Everyone' : 'Nobody',
            icon: LucideIcons.clock,
            trailing: Switch(
              value: _lastSeen,
              onChanged: (value) => setState(() => _lastSeen = value),
              activeColor: AppColors.electricBlue,
            ),
            showArrow: false,
            onTap: () {},
          ),
          SettingsTile(
            title: 'Profile Photo',
            subtitle: _profilePhoto ? 'Everyone' : 'My Contacts',
            icon: LucideIcons.image,
            trailing: Switch(
              value: _profilePhoto,
              onChanged: (value) => setState(() => _profilePhoto = value),
              activeColor: AppColors.electricBlue,
            ),
            showArrow: false,
            onTap: () {},
          ),
          SettingsTile(
            title: 'Online Status',
            subtitle: _onlineStatus ? 'Visible' : 'Hidden',
            icon: LucideIcons.eye,
            trailing: Switch(
              value: _onlineStatus,
              onChanged: (value) => setState(() => _onlineStatus = value),
              activeColor: AppColors.electricBlue,
            ),
            showArrow: false,
            onTap: () {},
          ),
          const SizedBox(height: 24),
          Text(
            'Messaging',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                ),
          ),
          const SizedBox(height: 12),
          SettingsTile(
            title: 'Read Receipts',
            subtitle: _readReceipts ? 'Enabled' : 'Disabled',
            icon: LucideIcons.checkCheck,
            trailing: Switch(
              value: _readReceipts,
              onChanged: (value) => setState(() => _readReceipts = value),
              activeColor: AppColors.electricBlue,
            ),
            showArrow: false,
            onTap: () {},
          ),
          SettingsTile(
            title: 'Blocked Contacts',
            subtitle: '0 contacts',
            icon: LucideIcons.userX,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
