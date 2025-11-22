import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

class ReactionPicker extends StatelessWidget {
  final VoidCallback onDismiss;
  final Function(String) onReactionSelected;

  const ReactionPicker({
    super.key,
    required this.onDismiss,
    required this.onReactionSelected,
  });

  static final List<String> reactions = ['❤️', '😂', '😮', '😢', '😡', '👍'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent dismissal when tapping the picker
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: reactions.map((reaction) {
                  return GestureDetector(
                    onTap: () {
                      onReactionSelected(reaction);
                      onDismiss();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        reaction,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                  duration: 200.ms,
                  curve: Curves.easeOutBack,
                )
                .fadeIn(duration: 200.ms),
          ),
        ),
      ),
    );
  }

  static void show(
    BuildContext context, {
    required Function(String) onReactionSelected,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => ReactionPicker(
        onDismiss: () => Navigator.of(context).pop(),
        onReactionSelected: onReactionSelected,
      ),
    );
  }
}
