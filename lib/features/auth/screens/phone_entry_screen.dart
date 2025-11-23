import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/providers/auth_providers.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_input.dart';
import '../../../widgets/common_app_bar.dart';

class PhoneEntryScreen extends ConsumerStatefulWidget {
  const PhoneEntryScreen({super.key});

  @override
  ConsumerState<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends ConsumerState<PhoneEntryScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final phone = _phoneController.text.trim();
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid phone number format')),
      );
      return;
    }

    ref.read(authControllerProvider.notifier).sendOtp(phone);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (previous, next) {
      next.when(
        data: (_) {
          // Only navigate if we were loading (successful completion of action)
          if (previous?.isLoading == true) {
             context.push('/auth/otp');
          }
        },
        error: (err, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $err')),
          );
        },
        loading: () {},
      );
    });

    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: '',
        showBackButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your phone number',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'We will send you a confirmation code',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            CustomTextField(
              hintText: 'Phone Number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone_android_rounded),
              onChanged: (value) {
                 // Optional: Real-time validation feedback
              },
            ),
            const Spacer(),
            GradientButton(
              text: 'Continue',
              onPressed: _onContinue,
              isLoading: authState.isLoading,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
