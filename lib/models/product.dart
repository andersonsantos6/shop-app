import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

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

  void _toggleFavorite() {
    isFavotrite = !isFavotrite;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    try {
      _toggleFavorite();

      final response = await http.patch(
        Uri.parse('${Constants.PRODUCT_BASE_URL}/${id}.json'),
        body: jsonEncode(
          {
            'isFavorite': isFavotrite,
          },
        ),
      );
      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (_) {
      _toggleFavorite();
    }
  }
}
