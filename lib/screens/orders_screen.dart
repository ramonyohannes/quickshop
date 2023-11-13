import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart';
import '../widgets/side_drawer.dart';
import '../widgets/order_items.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/orders-screen";

  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      drawer: const SideDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<Order>(context, listen: false).fetchandResetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // Error handling...
              return const Center(child: Text('An error occurred!'));
            } else {
              return Consumer<Order>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orderCount(),
                  itemBuilder: (ctx, i) => OrderItems(orderData.getOrders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
