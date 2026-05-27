import 'package:flutter/material.dart';

class CustomTextFieldLabel extends StatelessWidget {
  final String text;
  final Color bodyColor;

  const CustomTextFieldLabel({
    super.key,
    required this.text,
    required this.bodyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.only(bottom: 10, left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: bodyColor.withOpacity(0.8),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
