import 'package:pop_app/main_menu_screen/main_menu.dart';
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
      home: const MainMenuScreen(role: UserRole.seller),
    );
  }
}
