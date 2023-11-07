import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';

import '../screens/products_detail_screen.dart';

class ProductsItem extends StatelessWidget {
  const ProductsItem({super.key});

  void selectProduct(BuildContext context, String id) {
    Navigator.of(context).pushNamed(
      ProductDetailScreen.routeName,
      arguments: id,
    );
  }

  IconButton buildIconButton(
      BuildContext context, Icon iconData, VoidCallback onPressed) {
    return IconButton(onPressed: onPressed, icon: iconData);
  }

  @override
  Widget build(BuildContext context) {
    final productItem = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          footer: GridTileBar(
            title: Text(
              productItem.productTitle,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            backgroundColor: Colors.black87,
            leading: buildIconButton(
                context,
                productItem.getIsProductFavorite
                    ? Icon(
                        Icons.favorite,
                        color: Theme.of(context).primaryColor,
                      )
                    : const Icon(
                        Icons.favorite_border,
                      ), () {
              productItem.toggleFavoriteStatus();
            }),
            trailing: buildIconButton(
              context,
              const Icon(Icons.shopping_cart),
              () {
                cart.addCartItem(
                  productItem.productId,
                  productItem.productTitle,
                  productItem.productDiscription,
                  productItem.productPrice,
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      "Added item to cart!",
                    ),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        cart.removeSingleItem(productItem.productId);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          child: InkWell(
            onTap: () => selectProduct(context, productItem.productId),
            child: Image.network(
              productItem.productImageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
