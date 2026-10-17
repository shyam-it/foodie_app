import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _orders = [];

  List<Map<String, dynamic>> get orders => List.unmodifiable(_orders);

  void addOrder({
    required List<Map<String, dynamic>> items,
    required double total,
  }) {
    _orders.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'date': DateTime.now(),
      'items': items.map((item) => Map<String, dynamic>.from(item)).toList(),
      'total': total,
    });

    notifyListeners();
  }
}
