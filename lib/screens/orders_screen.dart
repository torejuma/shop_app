import 'package:flutter/material.dart';
import 'package:magazin_app/providers/orders.dart';
import 'package:magazin_app/widgets/app_drawer.dart';
import 'package:magazin_app/widgets/order_item_widget.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const routName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });

      await Provider.of<Orders>(context, listen: false).fetchOrders();

      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (ctx, index) => OrderItemWidget(
                order: ordersData.orders[index],
              ),
              itemCount: ordersData.orders.length,
            ),
      drawer: AppDrawer(),
    );
  }
}
