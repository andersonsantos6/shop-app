import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/models/order_list.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late bool _isLoading;

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    Provider.of<OrderList>(context, listen: false).loadProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _loadOrders(),
              child: ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: ((context, index) {
                  return OrderWidget(order: orders.items[index]);
                }),
              ),
            ),
    );
  }
}
