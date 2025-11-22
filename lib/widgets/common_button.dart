import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 56,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: onPressed != null ? AppColors.primaryGradient : null,
        color: onPressed == null ? AppColors.surfaceLight : null,
        borderRadius: borderRadius,
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: AppColors.electricBlue.withOpacity(0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: borderRadius,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: onPressed != null 
                                  ? Colors.white 
                                  : AppColors.textTertiary,
                            ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
