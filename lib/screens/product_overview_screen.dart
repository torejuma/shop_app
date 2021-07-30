import 'package:flutter/material.dart';
import 'package:magazin_app/providers/cart.dart';
import 'package:magazin_app/providers/products.dart';
import 'package:magazin_app/widgets/app_drawer.dart';
import 'package:magazin_app/widgets/badge.dart';
import 'package:magazin_app/widgets/products_grid.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  //const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;



  @override
  void didChangeDependencies() {
    if (_isInit) {

      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
      _isInit = false;

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              // print(selectedValue);
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorites only'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          SizedBox(width: 10,),

          Consumer<Cart>(
            builder: (_, cart, __) => Badge(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
              value: cart.itemCount.toString(),
              color: Colors.purple,
            ),
          ),
        ],
      ),

      drawer: AppDrawer(),

      body: _isLoading ? Center(child: CircularProgressIndicator(),) : ProductsGrid( showFavs: _showOnlyFavorites,),
    );
  }
}
