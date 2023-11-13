import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../widgets/user_products_item.dart';
import '../widgets/side_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    Future<void> refreshData() async {
      await productsData.fetchandResetUserProducts();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/edit-products");
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const SideDrawer(),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: productsData.productItems.length,
            itemBuilder: (BuildContext context, int index) {
              return UserProductsItem(
                productId: productsData.productItems[index].productId,
                productTitle: productsData.productItems[index].productTitle,
                productImageUrl:
                    productsData.productItems[index].productImageUrl,
              );
            },
          ),
        ),
      ),
    );
  }
}
