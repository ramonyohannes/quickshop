import 'package:flutter/material.dart';

import '../widgets/side_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/orders-screen";

  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      drawer: const SideDrawer(),
    );
  }
}
