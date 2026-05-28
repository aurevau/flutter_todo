import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_application/dashboard.dart';
import 'package:todo_application/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(token: prefs.getString('token')));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({required this.token, Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final hasValidToken =
        token != null && token!.isNotEmpty && !JwtDecoder.isExpired(token!);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Inter', useMaterial3: true),
      home: hasValidToken ? Dashboard(token: token!) : const LoginPage(),
    );
  }
}
