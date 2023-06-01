import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pop_app/myconstants.dart';

ThemeData lightTheme(context) {
  return ThemeData(
    dialogTheme: DialogTheme(
      surfaceTintColor: Colors.transparent,
      contentTextStyle: Theme.of(context).textTheme.titleMedium,
      titleTextStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(color: MyConstants.red),
      iconColor: MyConstants.red,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: MyConstants.red,
      foregroundColor: Colors.white,
      splashColor: MyConstants.accentColor,
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
