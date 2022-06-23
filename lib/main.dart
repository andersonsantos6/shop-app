import 'package:flutter/material.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/orders_page.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/product_form_page.dart';

import 'package:shop/pages/product_page.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:provider/provider.dart';

import 'components/products_overview_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => OrderList(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        //  home: ProductsOverViewPage(),
        routes: {
          AppRoutes.HOME: (context) => ProductsOverviewPage(),
          AppRoutes.PRODUCT_DETAIL: (context) => ProductDetailPage(),
          AppRoutes.ORDERS: (context) => OrdersPage(),
          AppRoutes.CART: (context) => CartPage(),
          AppRoutes.PRODUCTS: (context) => ProductPage(),
          AppRoutes.PRODUCTS_FORM: (context) => ProductFormPage()
        },
      ),
    );
  }
}
