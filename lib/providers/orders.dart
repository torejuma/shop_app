import 'package:flutter/material.dart';
import 'package:magazin_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://shop-app-tore-default-rtdb.europe-west1.firebasedatabase.app/orders.json';
    final timestamp = DateTime.now();

    final response = await http.post(Uri.parse(url), body: json.encode({
      'amount': total,
      'dateTime': timestamp.toIso8601String(),
      'products': cartProducts.map((cp) =>
      {
        'id': cp.id,
        'title': cp.title,
        'quantity': cp.quantity,
        'price': cp.price,
      }).toList(),
    }));

    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ));
    notifyListeners();
  }


  fetchOrders() async {
    const url = 'https://shop-app-tore-default-rtdb.europe-west1.firebasedatabase.app/orders.json';

    final response = await http.get(Uri.parse(url));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    final List<OrderItem> loadedOrders = [];

      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(
            OrderItem(
                id: orderId,
                amount: orderData['amount'],
                dateTime: DateTime.parse(orderData['dateTime']),
                products: (orderData['products'] as List<dynamic>)
                    .map((item) =>
                    CartItem(
                      id: item['id'],
                      title: item['title'],
                      quantity: item['quantity'],
                      price: item['price'],
                    )
                ).toList()

            )
        );
      });

      _orders = loadedOrders.reversed.toList();
      notifyListeners();


  }



}
