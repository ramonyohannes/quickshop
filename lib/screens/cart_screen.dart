import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart-screen";

  const CartScreen({Key? key}) : super(key: key);

  TextButton buildTextButton(BuildContext context, String text,
      {Function? onPressed}) {
    return TextButton(
      onPressed: () => onPressed!(),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }

  Chip buildChip(BuildContext context, String label) {
    return Chip(
      label: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.getItems.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Total",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    buildChip(context, cart.totalAmount.toStringAsFixed(2)),
                    const SizedBox(
                      width: 10,
                    ),
                    buildTextButton(context, "Order Now", onPressed: () {
                      cart.clearCart();
                    }),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                String key = cart.getItems.keys.toList()[index];
                return CartItems(
                  productId: key,
                  title: cartItems[index].title,
                  price: cartItems[index].price,
                  quantity: cartItems[index].quantity,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
