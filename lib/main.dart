import 'package:flutter/material.dart';
import 'package:magazin_app/providers/cart.dart';
import 'package:magazin_app/providers/orders.dart';
import 'package:magazin_app/screens/cart_screen.dart';
import 'package:magazin_app/screens/edit_product_screen.dart';
import 'package:magazin_app/screens/orders_screen.dart';
import 'package:magazin_app/screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import 'package:magazin_app/screens/product_detail_screen.dart';
import 'package:magazin_app/screens/product_overview_screen.dart';
import 'providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
          // create: (_) => Products() ,
        ),

        ChangeNotifierProvider.value(
          value: Cart(),
        ),

        ChangeNotifierProvider.value(
            value: Orders(),
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
