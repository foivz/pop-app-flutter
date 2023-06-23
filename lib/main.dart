import 'package:pop_app/user_info_screen/login_screen/login_screen.dart';
import 'package:pop_app/models/available_products.dart';
import 'package:pop_app/utils/themes.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AvailableProducts(),
      child: MaterialApp(
        title: 'Pop app',
        debugShowCheckedModeBanner: false,
        theme: lightTheme(context),
        home: const BaseLoginScreen(),
      ),
    );
  }
}
