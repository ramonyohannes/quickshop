import 'package:flutter/material.dart';

import '../models/product.dart';
import 'products_item.dart';

class ProductsGrid extends StatelessWidget {
  final List<Product> loadedProducts;
  const ProductsGrid(this.loadedProducts, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: loadedProducts.length,
      itemBuilder: (BuildContext context, int index) {
        return ProductsItem(
          id: loadedProducts[index].id,
          title: loadedProducts[index].title,
          imageUrl: loadedProducts[index].imageUrl,
        );
      },
    );
  }
}
