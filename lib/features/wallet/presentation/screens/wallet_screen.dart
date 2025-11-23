import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../theme/app_colors.dart';
import '../providers/wallet_providers.dart';
import 'send_screen.dart';
import 'receive_screen.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(walletControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Wallet'),
      ),
      body: walletState.when(
        data: (wallet) {
          if (wallet == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.wallet, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  const Text(
                    'No Wallet Found',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create a new wallet to start using crypto features.',
                    style: TextStyle(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      final pinController = TextEditingController();
                      final confirmPinController = TextEditingController();
                      
                      final bool? isCreated = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppColors.surface,
                          title: const Text('Set Wallet PIN', style: TextStyle(color: AppColors.textPrimary)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Create a 6-digit PIN to secure your wallet.',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: pinController,
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                maxLength: 6,
                                style: const TextStyle(color: AppColors.textPrimary),
                                decoration: const InputDecoration(
                                  labelText: 'PIN',
                                  labelStyle: TextStyle(color: AppColors.textSecondary),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textSecondary)),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                                ),
                              ),
                              TextField(
                                controller: confirmPinController,
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                maxLength: 6,
                                style: const TextStyle(color: AppColors.textPrimary),
                                decoration: const InputDecoration(
                                  labelText: 'Confirm PIN',
                                  labelStyle: TextStyle(color: AppColors.textSecondary),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textSecondary)),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                if (pinController.text.length < 4) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN must be at least 4 digits')));
                                  return;
                                }
                                if (pinController.text != confirmPinController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PINs do not match')));
                                  return;
                                }
                                Navigator.pop(context, true);
                              },
                              child: const Text('Set PIN'),
                            ),
                          ],
                        ),
                      );

                      if (isCreated == true) {
                        await ref.read(walletControllerProvider.notifier).createWallet();
                        await ref.read(walletControllerProvider.notifier).setPin(pinController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Create Wallet', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _BalanceCard(balance: wallet.balance, address: wallet.address),
                const SizedBox(height: 24),
                _AddressCard(address: wallet.address),
                const SizedBox(height: 24),
                const _SecuritySection(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double balance;
  final String address;

  const _BalanceCard({required this.balance, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '${balance.toStringAsFixed(4)} ETH',
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ActionButton(
                icon: LucideIcons.arrowUp,
                label: 'Send',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SendScreen()),
                  );
                },
              ),
              _ActionButton(
                icon: LucideIcons.arrowDown,
                label: 'Receive',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReceiveScreen(address: address),
                    ),
                  );
                },
              ),
              _ActionButton(icon: LucideIcons.history, label: 'History', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final String address;

  const _AddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Wallet Address', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(color: AppColors.textPrimary, fontFamily: 'Monospace'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.copy, color: AppColors.primary, size: 20),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: address));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Address copied to clipboard')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SecuritySection extends ConsumerWidget {
  const _SecuritySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Security', style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(LucideIcons.key, color: AppColors.primary),
          title: const Text('Reveal Seed Phrase', style: TextStyle(color: AppColors.textPrimary)),
          trailing: const Icon(LucideIcons.chevronRight, color: AppColors.textSecondary),
          onTap: () async {
            final pinController = TextEditingController();
            final bool? isVerified = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: AppColors.surface,
                title: const Text('Enter PIN', style: TextStyle(color: AppColors.textPrimary)),
                content: TextField(
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 6,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Enter your 6-digit PIN',
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textSecondary)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final isValid = await ref.read(walletControllerProvider.notifier).verifyPin(pinController.text);
                      if (context.mounted) {
                        if (isValid) {
                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invalid PIN')),
                          );
                        }
                      }
                    },
                    child: const Text('Verify'),
                  ),
                ],
              ),
            );

            if (isVerified == true) {
              final mnemonic = await ref.read(walletControllerProvider.notifier).getMnemonic();
              if (context.mounted && mnemonic != null) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppColors.surface,
                    title: const Text('Seed Phrase', style: TextStyle(color: AppColors.textPrimary)),
                    content: SelectableText(mnemonic, style: const TextStyle(color: AppColors.textPrimary)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
