import 'package:flutter/material.dart';
import 'package:magazin_app/providers/orders.dart';
import 'package:magazin_app/widgets/app_drawer.dart';
import 'package:magazin_app/widgets/order_item_widget.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const routName = '/orders';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),

      body: ListView.builder(
        itemBuilder: (ctx, index) => OrderItemWidget(order: ordersData.orders[index],),
        itemCount: ordersData.orders.length,
      ),

      drawer: AppDrawer(),
    );
  }
}
