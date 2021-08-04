import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magazin_app/providers/auth.dart';
import 'package:magazin_app/providers/cart.dart';
import 'package:magazin_app/providers/product.dart';
import 'package:magazin_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // const ProductItem(
  //     {Key? key, required this.id, required this.title, required this.imageUrl})
  //     : super(key: key);
  //
  // final String id;
  // final String title;
  // final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Added item to cart'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: (){
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
            icon: Icon(
              Icons.shopping_cart,
            ),
            color: Theme.of(context).accentColor,
          ),
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              onPressed: () {
                product.toggleFavorite(authData.token!, authData.userId!);
              },
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
            ),
          ),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
