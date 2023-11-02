import 'package:flutter/material.dart';

import '../screens/products_detail_screen.dart';

class ProductsItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const ProductsItem({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  void selectProduct(BuildContext context) {
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
        color: Theme.of(context).primaryColor,
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          footer: GridTileBar(
            title: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            backgroundColor: Colors.black87,
            leading: buildIconButton(context, Icons.favorite, () {}),
            trailing: buildIconButton(context, Icons.shopping_cart, () {}),
          ),
          child: InkWell(
            onTap: () => selectProduct(context),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
