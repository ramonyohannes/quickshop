import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/products.dart';

import '../widgets/user_products_item.dart';
import '../widgets/side_drawer.dart';
import '../widgets/empty_display.dart';

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
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return shimmerList();
          } else {
            if (dataSnapshot.error != null) {
              return const Center(child: Text('An error occurred!'));
            } else {
              return RefreshIndicator(
                onRefresh: refreshData,
                child: Consumer<Products>(
                  builder: (ctx, productData, child) =>
                      productData.countProduct() == 0
                          ? const EmptyDisplay('No orders found.')
                          : ListView.builder(
                              itemCount: productData.countProduct(),
                              itemBuilder: (ctx, i) => Column(
                                children: [
                                  UserProductsItem(
                                    productId:
                                        productsData.productItems[i].productId,
                                    productTitle: productsData
                                        .productItems[i].productTitle,
                                    productImageUrl: productsData
                                        .productItems[i].productImageUrl,
                                    reloadPage: reloadPage,
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
