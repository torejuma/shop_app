import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magazin_app/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget(
      {Key? key,
      required this.id,
      required this.title,
      required this.quantity,
      required this.price,
      required this.productId})
      : super(key: key);

  final String id;
  final String title;
  final int quantity;
  final double price;
  final String productId;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove item from cart?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                  padding: EdgeInsets.all(4),
                  child: FittedBox(child: Text('\$ $price'))),
            ),
            title: Text(title),
            subtitle: Text('Total \$ ${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
