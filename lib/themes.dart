import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pop_app/myconstants.dart';

ThemeData lightTheme(context) {
  return ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: MyConstants.red,
      foregroundColor: Colors.white,
      splashColor: MyConstants.accentColor.withOpacity(1),
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: MyConstants.red,
        systemNavigationBarColor: MyConstants.red,
      ),
      foregroundColor: Colors.white,
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
  );
}
