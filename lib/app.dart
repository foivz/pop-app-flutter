import 'package:flutter/material.dart';
import 'package:pop_app/login_screen/login.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: BaseLoginScreen());
  }
}
