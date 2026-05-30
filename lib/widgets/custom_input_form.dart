import 'package:flutter/material.dart';
import 'package:todo_application/widgets/custom_text_field.dart';
import 'package:todo_application/widgets/custom_text_field_label.dart';

class CustomInputForm extends StatelessWidget {
  final Color primaryColor, darkColor, bodyColor, borderColor;
  final bool isPasswordVisible;
  final VoidCallback onTogglePasswordVisibility;
  final String primaryInput;
  final String primaryHint;
  final String secondaryInput;
  final String secondaryHint;
  final TextEditingController? primaryController;
  final TextEditingController? secondaryController;
  final String? primaryError;
  final String? secondaryError;

  const CustomInputForm({
    super.key,
    required this.primaryColor,
    required this.darkColor,
    required this.bodyColor,
    required this.borderColor,
    required this.isPasswordVisible,
    required this.onTogglePasswordVisibility,
    required this.primaryInput,
    required this.primaryHint,
    required this.secondaryInput,
    required this.secondaryHint,
    this.primaryController,
    this.secondaryController,
    this.primaryError,
    this.secondaryError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFieldLabel(
          text: primaryInput,
          bodyColor: bodyColor,
          fontSize: 12,
        ),
        CustomTextField(
          bodyColor: bodyColor,
          borderColor: borderColor,
          darkColor: darkColor,
          icon: Icons.mail_outline_rounded,
          hint: primaryHint,
          primaryColor: primaryColor,
          controller: primaryController,
          errorText: primaryError,
          maxLines: 1,
        ),
        const SizedBox(height: 24),
        CustomTextFieldLabel(
          text: secondaryInput,
          bodyColor: bodyColor,
          fontSize: 12,
        ),
        CustomTextField(
          bodyColor: bodyColor,
          borderColor: borderColor,
          darkColor: darkColor,
          isPassword: true,
          isPasswordVisible: isPasswordVisible,
          icon: Icons.lock_open_rounded,
          hint: secondaryHint,
          primaryColor: primaryColor,
          suffix: IconButton(
            onPressed: onTogglePasswordVisibility,
            icon: Icon(
              isPasswordVisible
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              size: 20,
              color: bodyColor,
            ),
          ),
          controller: secondaryController,
          errorText: secondaryError,
          maxLines: 1,
        ),
      ],
    );
  }
}
