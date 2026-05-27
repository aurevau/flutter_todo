import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final Color darkColor, bodyColor;
  final String title;
  final String secondaryText;
  const CustomHeader({
    super.key,
    required this.darkColor,
    required this.bodyColor,
    required this.title,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 70),
        Text(
          title,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: darkColor,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          secondaryText,
          style: TextStyle(fontSize: 16, color: bodyColor, height: 1.5),
        ),
      ],
    );
  }
}
