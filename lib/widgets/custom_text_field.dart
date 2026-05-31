import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool isPassword;
  final bool isPasswordVisible;
  final Widget? suffix;
  final Color primaryColor;
  final Color darkColor;
  final Color bodyColor;
  final Color borderColor;
  final String? errorText;
  final int maxLines;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.bodyColor,
    required this.borderColor,
    required this.controller,
    required this.darkColor,
    required this.icon,
    required this.hint,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.suffix,
    required this.primaryColor,
    this.errorText,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: errorText != null ? Colors.red : borderColor,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: darkColor.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            maxLines: maxLines,
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            style: TextStyle(color: darkColor, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: bodyColor.withOpacity(0.4),
                fontSize: 15,
              ),
              prefixIcon: Icon(icon, color: primaryColor, size: 22),
              suffixIcon: suffix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
            ),
          ),
        ),

        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
