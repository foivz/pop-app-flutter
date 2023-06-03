import 'package:pop_app/login_screen/login_screen.dart';
import 'package:pop_app/themes.dart';

import 'package:flutter/material.dart';

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
