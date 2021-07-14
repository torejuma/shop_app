import 'package:flutter/material.dart';
import 'package:magazin_app/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:magazin_app/widgets/product_item.dart';


class ProductsGrid extends StatelessWidget {

  final bool showFavs;
  const ProductsGrid({Key? key, required this.showFavs}) : super(key: key);

  @override
  Widget build(BuildContext context) {

   final productsData = Provider.of<Products>(context);
   final products = showFavs? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,

      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        //create: (c) => products[i],//provider of one product..................

        child: ProductItem(
          // id: products[i].id,
          // title: products[i].title,
          // imageUrl: products[i].imageUrl,
        ),
      ),

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
    );
  }
}
