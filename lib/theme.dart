import 'package:flutter/material.dart';

final kDarkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.white,
    appBarTheme: AppBarTheme(color: Colors.white),
    textTheme: TextTheme(title: TextStyle(color: Colors.white)),
    cardColor: Colors.black87);

final kLightTheme = ThemeData.light().copyWith(
  //primaryColor: Colors.black,
  appBarTheme: AppBarTheme(color: Colors.black26),
  //textTheme: TextTheme(title: TextStyle(color: Colors.black))
);
