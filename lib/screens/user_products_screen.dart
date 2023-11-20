import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/products.dart';

import '../widgets/user_products_item.dart';
import '../widgets/side_drawer.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({super.key});

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);
    bool isRefreshing = false;

    Future<void> refreshData() async {
      setState(() {
        isRefreshing = true;
      });
      await productsData.fetchandResetUserProducts(true);
      setState(() {
        isRefreshing = false;
      });
    }

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
            ),
            subtitle: Container(
              color: Colors.grey,
              height: 10.0,
            ),
          ),
        ),
        itemCount: productsData.productItems.length,
        padding: const EdgeInsets.all(10.0),
      );
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
          child: isRefreshing
              ? shimmerList()
              : FutureBuilder(
                  future: Provider.of<Products>(context, listen: false)
                      .fetchandResetUserProducts(true),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return shimmerList();
                    } else {
                      if (snapshot.error != null) {
                        // Do error handling stuff here
                        return const Center(child: Text('An error occurred!'));
                      } else {
                        return Consumer<Products>(
                          builder: (ctx, productsData, _) => Padding(
                            padding: const EdgeInsets.all(8),
                            child: ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                              itemCount: productsData.productItems.length,
                              itemBuilder: (BuildContext context, int index) {
                                return UserProductsItem(
                                  productId: productsData
                                      .productItems[index].productId,
                                  productTitle: productsData
                                      .productItems[index].productTitle,
                                  productImageUrl: productsData
                                      .productItems[index].productImageUrl,
                                );
                              },
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
        ));
  }
}
