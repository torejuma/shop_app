import 'package:flutter/material.dart';
import 'package:magazin_app/screens/edit_product_screen.dart';
import 'package:magazin_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:magazin_app/providers/products.dart';
import 'package:magazin_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              //add product icon
              Navigator.of(context).pushNamed(EditProductScreen.routeName);

            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      drawer: AppDrawer(),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (_, index) => Column(
            children: [
              UserProductItem(
                title: productData.items[index].title,
                imageUrl: productData.items[index].imageUrl,
              ),
              Divider(),
            ],
          ),
          itemCount: productData.items.length,
        ),
      ),
    );
  }
}
