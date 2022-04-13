import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  late final String id;
  late final String name;
  late final String description;
  late final double price;
  late final String imageUrl;

  late bool isFavotrite;

  Product({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.isFavotrite,
    required this.price,
    required this.name,
  });

  void toggleFavorite() {
    isFavotrite = !isFavotrite;
    notifyListeners();
  }
}
