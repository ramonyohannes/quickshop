import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../screens/edit_products_screen.dart';

class UserProductsItem extends StatelessWidget {
  final String productId;
  final String productTitle;
  final String productImageUrl;

  const UserProductsItem({
    super.key,
    required this.productId,
    required this.productTitle,
    required this.productImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    var scaffold = ScaffoldMessenger.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(productImageUrl),
      ),
      title: Text(productTitle),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProducts.routeName, arguments: productId);
                },
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                )),
            IconButton(
              onPressed: () async {
                try {
                  await productData.deleteProduct(productId);
                } catch (error) {
                  scaffold.showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text(
                        "Deleting Failed!",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
