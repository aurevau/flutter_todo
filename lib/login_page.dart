import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_application/widgets/custom_footer.dart';
import 'package:todo_application/dashboard.dart';
import 'package:todo_application/widgets/custom_background.dart';
import 'package:todo_application/widgets/custom_button.dart';
import 'package:todo_application/widgets/custom_header.dart';
import 'package:todo_application/widgets/custom_input_form.dart';
import 'package:todo_application/register_page.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final bool _isLoading = false;
  bool _isPassWordVisible = false;

  String? _emailError;
  String? _passwordError;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final Color _primaryColor = const Color(0xFF4F46E5);
  final Color _darkTextColor = const Color(0xFF0F172A);
  final Color _bodyTextColor = const Color(0xFF475569);
  final Color _borderColor = const Color(0xFFE2E8F0);
  final Color _bgLight = const Color(0xFFF8FAFC);

  void loginUser(String email, String password) async {
    var reqBody = {"email": email, "password": password};

    var response = await http.post(
      Uri.parse(login_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status'] == true) {
      final String? myToken = jsonResponse['token'] as String?;
      if (myToken == null) {
        print('Login response missing token');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', myToken);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard(token: myToken)),
      );
    } else {
      print('Something went wrong!');
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
            topPosition: -60,
            leftPosition: -60,
            rightPosition: -60,
            bottomPosition: -80,
            upperBlobSize: 280,
            lowerBlobSize: 230,
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
                          title: 'Welcome back',
                          secondaryText:
                              'Enter your credentials to access your account',
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
                          buttonText: 'Sign in',
                          onPressedButton: () {
                            print('knapp klickad!');
                            final email = _emailController.text;
                            final password = _passwordController.text;
                            print('Email: "$email", Password: "$password"');
                            setState(() {
                              _emailError = email.isEmpty
                                  ? 'Email is required'
                                  : null;
                              _passwordError = password.isEmpty
                                  ? "Password is required"
                                  : null;
                            });

                            if (email.isEmpty || password.isEmpty) return;

                            // Logga in funktion:
                            loginUser(email, password);
                          },
                        ),
                        CustomFooter(
                          primaryColor: _primaryColor,
                          bodyColor: _bodyTextColor,
                          onPressedButton: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          title: 'New here?',
                          childTitle: 'Create Account',
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
