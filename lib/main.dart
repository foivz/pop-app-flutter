import 'package:flutter/material.dart';
import 'register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            primary: const Color.fromRGBO(225, 25, 60, 1),
            seedColor: const Color.fromRGBO(225, 25, 60, 1)),
        useMaterial3: true,
      ),
      home: RegisterScreen(),
    );
  }
}
