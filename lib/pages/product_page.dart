import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.PRODUCTS_FORM);
              },
              icon: Icon(Icons.add))
        ],
        title: Text('Gerenciar Produtos'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.itemsCount,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ProductItem(
                  product: products.items[index],
                ),
                Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
