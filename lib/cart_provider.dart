import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items {
    return [..._items];
  }

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  void addItem(String id, String title, double price, String imageUrl) {
    final existingIndex = _items.indexWhere((item) => item.id == id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(
        id: id,
        title: title,
        price: price,
        imageUrl: imageUrl, // Ensure this matches the product's imageUrl
      ));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    final existingIndex = _items.indexWhere((item) => item.id == id);
    if (existingIndex >= 0) {
      if (_items[existingIndex].quantity > 1) {
        _items[existingIndex].quantity--;
      } else {
        _items.removeAt(existingIndex);
      }
      notifyListeners();
    }
  }
}
