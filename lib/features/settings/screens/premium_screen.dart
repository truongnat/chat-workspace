import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/common_app_bar.dart';
import '../../../widgets/common_button.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Premium'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Icon(
                    LucideIcons.crown,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'SecureChat Premium',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unlock exclusive features',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildFeatureItem(
              icon: LucideIcons.shield,
              title: 'Enhanced Security',
              description: 'Advanced encryption and anti-screenshot protection',
            ),
            _buildFeatureItem(
              icon: LucideIcons.video,
              title: 'HD Video Calls',
              description: 'Crystal clear video calls with special effects',
            ),
            _buildFeatureItem(
              icon: LucideIcons.users,
              title: 'Group Chats',
              description: 'Create groups with up to 1000 members',
            ),
            _buildFeatureItem(
              icon: LucideIcons.cloud,
              title: 'Cloud Storage',
              description: '100GB of secure cloud storage',
            ),
            _buildFeatureItem(
              icon: LucideIcons.palette,
              title: 'Custom Themes',
              description: 'Personalize your chat experience',
            ),
            _buildFeatureItem(
              icon: LucideIcons.zap,
              title: 'Priority Support',
              description: '24/7 premium customer support',
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Monthly',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            '\$9.99',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'per month',
                            style: TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GradientButton(
                    text: 'Subscribe Now',
                    onPressed: () {},
                    icon: LucideIcons.crown,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Cancel anytime. Terms and conditions apply.',
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
