import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/models/order_list.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrderList>(context, listen: false).loadOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.error != null) {
            return Center(
              child: Text('Ocorreu um erro!'),
            );
          } else {
            return Consumer<OrderList>(
              builder: (context, orders, child) => ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: ((context, index) {
                  return OrderWidget(order: orders.items[index]);
                }),
              ),
            );
          }
        },
      ),
      // body: _isLoading
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : RefreshIndicator(
      //         onRefresh: () => _loadOrders(),
      //         child: ListView.builder(
      //           itemCount: orders.itemsCount,
      //           itemBuilder: ((context, index) {
      //             return OrderWidget(order: orders.items[index]);
      //           }),
      //         ),
      //       ),
    );
  }
}
