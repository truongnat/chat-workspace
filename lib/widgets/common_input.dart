import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: IconTheme(
                  data: IconThemeData(
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                  child: prefixIcon!,
                ),
              )
            : null,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: IconTheme(
                  data: IconThemeData(
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                  child: suffixIcon!,
                ),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 48),
        suffixIconConstraints: const BoxConstraints(minWidth: 48),
      ),
    );
  }
}
