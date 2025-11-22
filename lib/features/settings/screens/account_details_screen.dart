import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/common_app_bar.dart';
import '../../../widgets/common_input.dart';
import '../../../widgets/common_button.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final _nameController = TextEditingController(text: 'John Doe');
  final _usernameController = TextEditingController(text: '@johndoe');
  final _bioController = TextEditingController(text: 'Hey there! I am using SecureChat.');

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Account'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.electricBlue, width: 3),
                  ),
                  child: const Center(
                    child: Text(
                      'J',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.camera,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            CustomTextField(
              hintText: 'Name',
              controller: _nameController,
              prefixIcon: const Icon(LucideIcons.user),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'Username',
              controller: _usernameController,
              prefixIcon: const Icon(LucideIcons.atSign),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.phone,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone',
                          style: TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '+1 234 567 8900',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Change'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'About',
              controller: _bioController,
              prefixIcon: const Icon(LucideIcons.info),
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: 'Save Changes',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
