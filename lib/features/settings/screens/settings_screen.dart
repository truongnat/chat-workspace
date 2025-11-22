import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          InkWell(
            onTap: () => context.push('/settings/account'),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.user,
                      size: 32,
                      color: AppColors.electricBlue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '+1 234 567 8900',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    LucideIcons.chevronRight,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Account Settings
          Text(
            'Account',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                ),
          ),
          const SizedBox(height: 12),
          SettingsTile(
            title: 'Privacy',
            subtitle: 'Block contacts, disappearing messages',
            icon: LucideIcons.lock,
            onTap: () => context.push('/settings/privacy'),
          ),
          SettingsTile(
            title: 'Security',
            subtitle: 'Two-step verification, change number',
            icon: LucideIcons.shield,
            onTap: () => context.push('/settings/security'),
          ),
          SettingsTile(
            title: 'Notifications',
            subtitle: 'Message, group & call tones',
            icon: LucideIcons.bell,
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // Premium
          Text(
            'Premium',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                ),
          ),
          const SizedBox(height: 12),
          SettingsTile(
            title: 'Upgrade to Premium',
            subtitle: 'Unlock exclusive features',
            icon: LucideIcons.crown,
            iconColor: AppColors.violet,
            onTap: () => context.push('/settings/premium'),
          ),

          const SizedBox(height: 24),

          // Other
          Text(
            'Other',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                ),
          ),
          const SizedBox(height: 12),
          SettingsTile(
            title: 'Help',
            subtitle: 'Help center, contact us',
            icon: LucideIcons.helpCircle,
            onTap: () {},
          ),
          SettingsTile(
            title: 'About',
            subtitle: 'Version 1.0.0',
            icon: LucideIcons.info,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
