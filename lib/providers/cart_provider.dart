import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addToCart(Map<String, dynamic> food) {
    final index = _cartItems.indexWhere((item) => item['id'] == food['id']);

    if (index != -1) {
      _cartItems[index]['quantity']++;
    } else {
      _cartItems.add({...food, 'quantity': 1});
    }

    notifyListeners();
  }

  void removeFromCart(int foodId) {
    _cartItems.removeWhere((item) => item['id'] == foodId);

    notifyListeners();
  }

  void increaseQuantity(int foodId) {
    final index = _cartItems.indexWhere((item) => item['id'] == foodId);

    if (index != -1) {
      _cartItems[index]['quantity']++;
      notifyListeners();
    }
  }

  void decreaseQuantity(int foodId) {
    final index = _cartItems.indexWhere((item) => item['id'] == foodId);

    if (index != -1) {
      if (_cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity']--;
      } else {
        _cartItems.removeAt(index);
      }

      notifyListeners();
    }
  }

  int get totalItems {
    return _cartItems.fold<int>(
      0,
      (total, item) => total + (item['quantity'] as int),
    );
  }

  double get totalPrice {
    return _cartItems.fold<double>(
      0,
      (total, item) =>
          total +
          ((item['price'] as num).toDouble() * (item['quantity'] as int)),
    );
  }
}
