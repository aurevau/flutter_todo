import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  final Color primaryColor, bodyColor;
  final VoidCallback onPressedButton;
  final String title;
  final String childTitle;
  const CustomFooter({
    super.key,
    required this.primaryColor,
    required this.bodyColor,
    required this.onPressedButton,
    required this.title,
    required this.childTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: TextStyle(color: bodyColor)),
        TextButton(
          onPressed: () {
            onPressedButton();
          },
          child: Text(
            childTitle,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
