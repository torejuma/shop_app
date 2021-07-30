import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magazin_app/providers/cart.dart';
import 'package:magazin_app/providers/orders.dart';
import 'package:magazin_app/screens/orders_screen.dart';
import 'package:magazin_app/widgets/cart_item_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6!.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OrderButton(cart: cart),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => CartItemWidget(
                productId: cart.items.keys.toList()[index],
                title: cart.items.values.toList()[index].title,
                id: cart.items.values.toList()[index].id,
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
              ),
              itemCount: cart.items.length,
            ),
          ),
        ],
      ),
    );
  }
}


//Order Button
class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <=0 || _isLoading)
        ? null : () async {
        setState(() { _isLoading = true;  });

        await  Provider.of<Orders>(context, listen: false).addOrder(
            widget.cart.items.values.toList(), widget.cart.totalAmount);

        setState(() {   _isLoading = false;  });

        widget.cart.clearCart();
        Navigator.of(context).pushReplacementNamed(OrdersScreen.routName);
      },
      child: _isLoading ? CircularProgressIndicator() : Text(
        'Order Now',
        style: TextStyle(color: Theme.of(context).primaryColor
        ),
      ),
    );
  }
}
