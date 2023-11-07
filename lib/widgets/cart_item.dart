import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItems extends StatelessWidget {
  final String productId;
  final String title;
  final double price;
  final int quantity;

  const CartItems({
    super.key,
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Dismissible(
        key: ValueKey(productId),
        background: Container(
          color: Colors.red, // Background color when swiping
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        direction: DismissDirection.endToStart,
        behavior: HitTestBehavior.translucent,
        onDismissed: (direction) {
          cart.removeCartItem(productId);
        },
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Text("Are you sure?"),
                  content: const Text(
                      "Do you want to remove the item from the cart?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text("No")),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text("Yes")),
                  ],
                );
              });
        },
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  "\$${price.toStringAsFixed(1)}",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text(
              "Total: \$${(price * quantity)}",
            ),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
