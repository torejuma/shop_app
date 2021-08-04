import 'package:flutter/material.dart';
import 'package:magazin_app/screens/edit_product_screen.dart';
import 'package:magazin_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:magazin_app/providers/products.dart';
import 'package:magazin_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  static const routeName = '/user-products';

  _onRefresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<Products>(context);
    print('rebuilding...');

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
      body: FutureBuilder(
        future: _onRefresh(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _onRefresh(context),
                    child: Consumer<Products>(
                      builder: (ctx, productData, _) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductItem(
                                id: productData.items[i].id,
                                title: productData.items[i].title,
                                imageUrl: productData.items[i].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                          itemCount: productData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
