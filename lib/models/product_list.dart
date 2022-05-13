import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final _baseUrl = 'database-url';

  List<Product> _items = dummyProducts;
  int get itemsCount {
    return _items.length;
  }

  List<Product> get items => [..._items];
  List<Product> get Favoriteitems =>
      _items.where((prod) => prod.isFavotrite).toList();

  Future<void> addProduct(Product product) {
    final future = http.post(
      Uri.parse('$_baseUrl/products.json'),
      body: jsonEncode(
        {
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavotrite,
        },
      ),
    );

    return future.then<void>((response) {
      final id = jsonDecode(response.body)['name'];
      _items.add(
        Product(
            id: id,
            description: product.name,
            imageUrl: product.imageUrl,
            isFavotrite: product.isFavotrite,
            price: product.price,
            name: product.name),
      );
      notifyListeners();
    });
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
        id: hasId ? data['id'] as String : Random().nextDouble().toString(),
        description: data['description'] as String,
        imageUrl: data['imageurl'] as String,
        isFavotrite: false,
        price: data['price'] as double,
        name: data['name'] as String);
    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  removeProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
    return Future.value();
  }
}

// bool _showFavoriteOnly = false;

//   List<Product> get items {
//     if (_showFavoriteOnly) {
//       return _items.where((prod) => prod.isFavotrite).toList();
//     }
//     return [..._items];
//   }

//   void showFavoriteOnly() {
//     _showFavoriteOnly = true;
//     notifyListeners();
//   }

//   void showAll() {
//     _showFavoriteOnly = false;
//     notifyListeners();
//   }