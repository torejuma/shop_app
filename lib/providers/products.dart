import 'package:flutter/material.dart';
import 'package:magazin_app/models/http_exception.dart';
import 'package:magazin_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);


  List<Product> get items {
    return [..._items]; // ????????? copy of _items
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  //fetchProducts([bool filterByUser = false]) => default value []=> for optional value
  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterUserString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = 'https://shop-app-tore-default-rtdb.europe-west1.firebasedatabase.app/products.json'
        '?auth=$authToken&$filterUserString';
    try{
      final response = await http.get(
          Uri.parse(url)
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        return;
      }

      url = 'https://shop-app-tore-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken';
      final favResponse = await http.get(
        Uri.parse(url),
      );
      final favData = json.decode(favResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          price: prodData['price'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          isFavorite: favData==null ? false : favData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();

    } catch (error) {
      throw (error);
    }
  }

  addProduct (Product product) async {
    final url = 'https://shop-app-tore-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          }));

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    }catch (error){
       print(error);
       throw error;
    } finally { }
  }

    updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url = 'https://shop-app-tore-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url), body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl
      }));

      _items[prodIndex] = newProduct;
    } else {
      print('error updating, id');
    }
    notifyListeners();
  }

   deleteProduct(String id) async {
    final url = 'https://shop-app-tore-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken';
    final _existingProductIndex = _items.indexWhere((element) => element.id == id );
    Product? _existingProduct = _items[_existingProductIndex];

    _items.removeAt(_existingProductIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
      if (response.statusCode >= 400) {
       _items.insert(_existingProductIndex, _existingProduct);
        notifyListeners();
        print('notify');
       throw HttpException(message: 'Could not delete product');
      }
    _existingProduct=null;
  }
}

//statusCode 400 means Error occurred.
