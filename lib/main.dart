import 'package:flutter/material.dart';
import 'package:pop_app/login_screen/login.dart';
import 'package:pop_app/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pop app',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(context),
      home: const BaseLoginScreen(),
    );
  }
}
