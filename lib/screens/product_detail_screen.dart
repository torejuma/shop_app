import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magazin_app/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;

    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              height: 300,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 10,),
            Text(
                '\$ ${loadedProduct.price}',
              style: TextStyle(fontSize: 30, color: Colors.grey ),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
