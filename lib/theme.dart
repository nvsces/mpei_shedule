import 'package:flutter/material.dart';

final colorCardDarkTl = Color.fromRGBO(34, 46, 58, 1);
final colorBackgraundDarkTl = Color.fromRGBO(21, 30, 39, 1);

final colorCardDarkVk = Color.fromRGBO(69, 70, 72, 0.9);
final colorbackgraundDarkVk = Colors.black;

final colorGreen = Color.fromRGBO(18, 170, 113, 1);

final kDarkTheme = ThemeData.dark().copyWith(
  accentColor: Colors.white,
  cardTheme: CardTheme(color: colorCardDarkVk),
  backgroundColor: colorbackgraundDarkVk,
  scaffoldBackgroundColor: colorbackgraundDarkVk,
  appBarTheme: AppBarTheme().copyWith(
    iconTheme: IconThemeData().copyWith(),
    color: colorbackgraundDarkVk,
    shadowColor: Colors.transparent,
  ),
  cardColor: Colors.black,
);

final kLightTheme = ThemeData.light().copyWith(
  // cardTheme: CardTheme().copyWith(color: colorGreen),
  accentColor: colorGreen,
  scaffoldBackgroundColor: Colors.white,
  backgroundColor: Colors.white,
  appBarTheme: AppBarTheme().copyWith(
    iconTheme: IconThemeData().copyWith(color: Colors.black, opacity: 1),
    color: Colors.white,
    shadowColor: Colors.transparent,
    textTheme: TextTheme().copyWith(
      headline1: TextStyle().copyWith(
          color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      headline2: TextStyle().copyWith(
          color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      headline3: TextStyle().copyWith(
          color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      headline4: TextStyle().copyWith(
          color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      headline5: TextStyle().copyWith(
          color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      headline6: TextStyle().copyWith(
          color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
    ),
  ),
);
