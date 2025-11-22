import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';

class SwipeableMessage extends StatelessWidget {
  final Widget child;
  final VoidCallback onReply;

  const SwipeableMessage({
    super.key,
    required this.child,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(child.hashCode),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.2,
        children: [
          CustomSlidableAction(
            onPressed: (context) => onReply(),
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.electricBlue,
            child: const Icon(LucideIcons.reply, size: 24),
          ),
        ],
      ),
      child: child,
    );
  }
}
