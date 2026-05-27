import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_application/widgets/custom_footer.dart';
import 'package:todo_application/widgets/custom_background.dart';
import 'package:todo_application/widgets/custom_button.dart';
import 'package:todo_application/widgets/custom_header.dart';
import 'package:todo_application/widgets/custom_input_form.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isPassWordVisible = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  final Color _primaryColor = const Color(0xFFEC4899);
  final Color _darkTextColor = const Color(0xFF533B59);
  final Color _bodyTextColor = const Color(0xFF475569);
  final Color _borderColor = const Color(0xFFE2E8F0);
  final Color _bgLight = const Color(0xFFF8FAFC);

  void registerUser(String email, String password) async {
    var reqBody = {"email": email, "password": password};

    var response = await http.post(
      Uri.parse(registration),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse['status']);

    if (jsonResponse['status']) {
      Navigator.pop(context);
    } else {
      print('not created');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      body: Stack(
        children: [
          CustomBackground(
            color: _primaryColor,
            topPosition: -84,
            bottomPosition: -80,
            leftPosition: 160,
            rightPosition: 250,
            upperBlobSize: 320,
            lowerBlobSize: 200,
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        CustomHeader(
                          darkColor: _darkTextColor,
                          bodyColor: _bodyTextColor,
                          title: "Welcome newbie!",
                          secondaryText:
                              "Enter your credentials to create user",
                        ),
                        const SizedBox(height: 48),
                        CustomInputForm(
                          primaryColor: _primaryColor,
                          darkColor: _darkTextColor,
                          bodyColor: _bodyTextColor,
                          borderColor: _borderColor,
                          isPasswordVisible: _isPassWordVisible,
                          onTogglePasswordVisibility: () {
                            setState(() {
                              _isPassWordVisible = !_isPassWordVisible;
                            });
                          },
                          primaryController: _emailController,
                          secondaryController: _passwordController,
                          primaryInput: 'Email',
                          primaryHint: 'Enter your email',
                          secondaryInput: 'Password',
                          secondaryHint: 'Enter your password',
                          primaryError: _emailError,
                          secondaryError: _passwordError,
                        ),
                        const SizedBox(height: 30),
                        CustomButton(
                          btnColor: _darkTextColor,
                          buttonText: 'Create user',
                          onPressedButton: () {
                            final email = _emailController.text;
                            final password = _passwordController.text;

                            setState(() {
                              _emailError = email.isEmpty
                                  ? 'Email is required'
                                  : null;
                              _passwordError = password.isEmpty
                                  ? "Password is required"
                                  : null;
                            });

                            if (email.isEmpty || password.isEmpty) return;

                            // Register function here:
                            registerUser(email, password);
                          },
                        ),
                        CustomFooter(
                          primaryColor: _primaryColor,
                          bodyColor: _bodyTextColor,
                          onPressedButton: () {
                            Navigator.pop(context);
                          },
                          title: "Already a user?",
                          childTitle: "Login",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
