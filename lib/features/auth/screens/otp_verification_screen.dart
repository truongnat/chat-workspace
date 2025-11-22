import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_input.dart';
import '../../../widgets/common_app_bar.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onVerify() async {
    setState(() => _isLoading = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      context.push('/auth/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: ''),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Code',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'We sent a code to your phone',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            CustomTextField(
              hintText: '000000',
              controller: _otpController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.lock_clock_outlined),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Resend Code',
                  style: TextStyle(color: AppColors.electricBlue),
                ),
              ),
            ),
            const Spacer(),
            GradientButton(
              text: 'Verify',
              onPressed: _onVerify,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
