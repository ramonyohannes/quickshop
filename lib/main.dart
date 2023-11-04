import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/products_overview_screen.dart';
import './screens/products_detail_screen.dart';

import './providers/products.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Products(),
      child: MaterialApp(
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
        ),
        title: 'QuickCart',
        routes: {
          "/": (context) => const ProductsOverViewScreen(),
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen(),
        },
      ),
    );
  }
}
