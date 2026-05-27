import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color btnColor;
  final String buttonText;
  final VoidCallback onPressedButton;
  const CustomButton({
    super.key,
    required this.btnColor,
    required this.buttonText,
    required this.onPressedButton,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: () {
          onPressedButton();
        },
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
