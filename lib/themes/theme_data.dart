import 'package:flutter/material.dart';

ThemeData themeData() {
  return ThemeData(
    primaryColor: Colors.purple,
    primarySwatch: Colors.amber,
    colorScheme: const ColorScheme.light(
      primary: Colors.purple,
      secondary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.white10,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.bold,
        fontFamily: 'Lato',
      ),
      iconTheme: IconThemeData(
        color: Colors.black, // Change the color
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 20,
        fontFamily: 'Lato',
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        fontFamily: 'Lato',
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(
        fontSize: 16,
        fontFamily: 'Lato',
        fontWeight: FontWeight.bold,
      ),
      labelLarge: TextStyle(
        fontSize: 20,
        fontFamily: 'Lato',
        fontWeight: FontWeight.bold,
        color: Colors.purple,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        fontFamily: 'Lato',
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
      size: 30,
    ),
  );
}
