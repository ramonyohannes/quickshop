import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/order.dart';

import '../widgets/side_drawer.dart';
import '../widgets/order_items.dart';
import '../widgets/empty_display.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/orders-screen";

  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget shimmerList() {
      return ListView.builder(
        itemBuilder: (ctx, i) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.grey,
            ),
            title: Container(
              color: Colors.grey,
              height: 10.0,
              width: double.infinity,
            ),
            subtitle: Container(
              color: Colors.grey,
              height: 10.0,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 5.0),
            ),
            trailing: Column(
              children: [
                Container(
                  color: Colors.grey,
                  height: 10.0,
                  width: 40.0,
                ),
                const SizedBox(height: 5.0),
                Container(
                  color: Colors.grey,
                  height: 10.0,
                  width: 40.0,
                ),
              ],
            ),
          ),
        ),
        itemCount: 6,
        padding: const EdgeInsets.all(10.0),
      );
    }

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
            return shimmerList();
          } else {
            if (dataSnapshot.error != null) {
              // Error handling...
              return const Center(child: Text('An error occurred!'));
            } else {
              return Consumer<Order>(
                builder: (ctx, orderData, child) => orderData.orderCount() == 0
                    ? const EmptyDisplay('No orders found.')
                    : ListView.builder(
                        itemCount: orderData.orderCount(),
                        itemBuilder: (ctx, i) =>
                            OrderItems(orderData.getOrders[i]),
                      ),
              );
            }
          }
        },
      ),
    );
  }
}
