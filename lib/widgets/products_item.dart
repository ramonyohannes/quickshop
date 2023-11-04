import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../screens/products_detail_screen.dart';
import '../providers/product.dart';

class ProductsItem extends StatelessWidget {
  const ProductsItem({super.key});

  void selectProduct(BuildContext context, String id) {
    Navigator.of(context).pushNamed(
      ProductDetailScreen.routeName,
      arguments: id,
    );
  }

  IconButton buildIconButton(
      BuildContext context, IconData iconData, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        iconData,
        color: Theme.of(context).colorScheme.secondary,
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productItem = Provider.of<Product>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          footer: GridTileBar(
            title: Text(
              productItem.title,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            backgroundColor: Colors.black87,
            leading: buildIconButton(
                context,
                productItem.getIsFavorite
                    ? Icons.favorite
                    : Icons.favorite_border, () {
              productItem.toggleFavoriteStatus();
            }),
            trailing: buildIconButton(context, Icons.shopping_cart, () {}),
          ),
          child: InkWell(
            onTap: () => selectProduct(context, productItem.id),
            child: Image.network(
              productItem.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
