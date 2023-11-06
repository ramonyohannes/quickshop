import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/order.dart';

import '../widgets/side_drawer.dart';
import '../widgets/order_items.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/orders-screen";

  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      drawer: const SideDrawer(),
      body: orderData.getOrders.isEmpty
          ? const Center(
              child: Text("You have no order, Add Some!"),
            )
          : ListView.builder(
              itemCount: orderData.orderCount(),
              itemBuilder: (BuildContext context, int index) {
                return OrderItems(
                  orderData.getOrders[index],
                );
              },
            ),
    );
  }
}
