import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:todo_application/widgets/custom_background.dart';
import 'package:todo_application/widgets/custom_button.dart';
import 'package:todo_application/widgets/custom_text_field.dart';
import 'package:todo_application/widgets/custom_text_field_label.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class Dashboard extends StatefulWidget {
  final String token;

  const Dashboard({super.key, required this.token});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String userId = '';
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDescription = TextEditingController();

  final Color _primaryColor = const Color(0xFF4F46E5);
  final Color _darkTextColor = const Color(0xFF0F172A);
  final Color _bodyTextColor = const Color(0xFF475569);
  final Color _borderColor = const Color(0xFFE2E8F0);
  final Color _bgLight = const Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecoderToken = JwtDecoder.decode(widget.token);
    userId = (jwtDecoderToken['_id'] as String?) ?? '';
  }

  void addTodo() async {
    if (_todoTitle.text.isNotEmpty && _todoDescription.text.isNotEmpty) {
      var reqBody = {
        "userId": userId,
        "title": _todoTitle.text,
        "description": _todoDescription.text,
      };

      var response = await http.post(
        Uri.parse(addtodo),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        _todoTitle.clear();
        _todoDescription.clear();
        Navigator.pop(context);
      } else {
        print('not created');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(userId)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _darkTextColor,
        foregroundColor: _bgLight,
        onPressed: () => _displayTextInputDialog(context),
        child: Icon(Icons.add),
        tooltip: "Add todo",
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: 280,
            height: 300,
            child: Stack(
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        CustomTextFieldLabel(
                          text: "Add Todo",
                          bodyColor: _darkTextColor,
                          fontSize: 16,
                        ),
                        SizedBox(height: 6),
                        CustomTextField(
                          bodyColor: _bodyTextColor,
                          borderColor: _borderColor,
                          controller: _todoTitle,
                          darkColor: _darkTextColor,
                          icon: Icons.title,
                          hint: "Title",
                          primaryColor: _primaryColor,
                        ),
                        SizedBox(height: 12),
                        CustomTextField(
                          bodyColor: _bodyTextColor,
                          borderColor: _borderColor,
                          controller: _todoDescription,
                          darkColor: _darkTextColor,
                          icon: Icons.description,
                          hint: "Description",
                          primaryColor: _primaryColor,
                        ),

                        SizedBox(height: 12),

                        CustomButton(
                          btnColor: _darkTextColor,
                          buttonText: "Save",
                          onPressedButton: () {
                            addTodo();
                          },
                        ),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
