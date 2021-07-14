import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magazin_app/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatefulWidget {
  const OrderItemWidget({Key? key, required this.order}) : super(key: key);

  final OrderItem order;

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {

  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$ ${widget.order.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded? Icons.expand_less : Icons.expand_more),
              onPressed: (){
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),

          if (_expanded)  Container(
            padding: EdgeInsets.all(5),
            height: min(widget.order.products.length * 20.0 + 50, 300),
            margin: EdgeInsets.all(10),
            child: ListView(
              children: widget.order.products
                  .map(
                      (product) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${product.quantity} * \$ ${product.price}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ),

        ],
      ),
    );
  }
}
