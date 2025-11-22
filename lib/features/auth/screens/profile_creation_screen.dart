import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_input.dart';
import '../../../widgets/common_app_bar.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onComplete() async {
    setState(() => _isLoading = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile Setup'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.electricBlue, width: 2),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    size: 64,
                    color: AppColors.textTertiary,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.electricBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            CustomTextField(
              hintText: 'Full Name',
              controller: _nameController,
              prefixIcon: const Icon(Icons.person),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'Username (Optional)',
              prefixIcon: const Icon(Icons.alternate_email),
            ),
            const SizedBox(height: 48),
            GradientButton(
              text: 'Complete Setup',
              onPressed: _onComplete,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
