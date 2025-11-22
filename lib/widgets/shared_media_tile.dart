import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SharedMediaTile extends StatelessWidget {
  final List<String> mediaThumbnails;
  final int totalCount;
  final VoidCallback onViewAll;

  const SharedMediaTile({
    super.key,
    required this.mediaThumbnails,
    required this.totalCount,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final displayThumbnails = mediaThumbnails.take(3).toList();
    final remainingCount = totalCount - displayThumbnails.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shared Media',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.electricBlue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ...displayThumbnails.asMap().entries.map((entry) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: entry.key < displayThumbnails.length - 1 ? 8 : 0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient.scale(0.3),
                          ),
                          child: const Icon(
                            Icons.image,
                            color: Colors.white54,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
              if (remainingCount > 0)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      onTap: onViewAll,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '+$remainingCount',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
