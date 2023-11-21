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
    final productsData = Provider.of<Products>(context);
    //bool isRefreshing = false;
    void reloadPage() {
      setState(() {});
    }

    Future<void> refreshData() async {
      reloadPage();
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
        // itemCount: 5,
        padding: const EdgeInsets.all(10.0),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                "/edit-products",
                arguments: {
                  'productId': "",
                  'reloadPage': reloadPage,
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const SideDrawer(),
      body: FutureBuilder(
        future: Provider.of<Products>(context, listen: false)
            .fetchandResetUserProducts(true),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return shimmerList();
          } else if (snapshot.hasError) {
            return const Center(child: Text('An error occurred!'));
          } else {
            return RefreshIndicator(
              onRefresh: refreshData,
              child: Consumer<Products>(
                builder: (ctx, productsData, _) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: productsData.productItems.length,
                    itemBuilder: (_, i) => Column(
                      children: [
                        UserProductsItem(
                          productId: productsData.productItems[i].productId,
                          productTitle:
                              productsData.productItems[i].productTitle,
                          productImageUrl:
                              productsData.productItems[i].productImageUrl,
                          reloadPage: reloadPage,
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
