import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/products.dart';

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
                onPressed: () {},
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                )),
            IconButton(
                onPressed: () => productData.deleteProduct(productId),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                )),
          ],
        ),
      ),
    );
  }
}
