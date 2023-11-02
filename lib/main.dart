import 'package:flutter/material.dart';

import 'screens/products_overview_screen.dart';
import './screens/products_detail_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple,
        primarySwatch: Colors.amber,
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
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 20,
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            fontSize: 18,
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
          ),
          bodySmall: TextStyle(
            fontSize: 16,
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
          ),
          labelMedium: TextStyle(
            fontSize: 18,
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
          size: 30,
        ),
      ),
      title: 'QuickCart',
      home: ProductsOverViewScreen(),
      routes: {
        "./": (context) => ProductsOverViewScreen(),
        ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
      },
    );
  }
}
