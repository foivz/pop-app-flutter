import 'package:flutter/material.dart';
import 'register.dart';
import 'package:pop_app/login_screen/login.dart';
import 'package:pop_app/myconstants.dart';

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
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: MyConstants.red,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          primary: MyConstants.red,
          seedColor: MyConstants.red,
        ),
        useMaterial3: true,
      ),
      home: const LoginHomepage(),
    );
  }
}
