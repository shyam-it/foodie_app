import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider extends ChangeNotifier {
  static const String _storageKey = 'saved_orders';

  final List<Map<String, dynamic>> _orders = [];

  List<Map<String, dynamic>> get orders => List.unmodifiable(_orders);

  OrderProvider() {
    loadOrders();
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final savedOrders = prefs.getString(_storageKey);

    if (savedOrders != null) {
      final List<dynamic> decodedOrders = jsonDecode(savedOrders);

      _orders
        ..clear()
        ..addAll(
          decodedOrders.map((order) {
            final map = Map<String, dynamic>.from(order);
            map['date'] = DateTime.parse(map['date'] as String);
            return map;
          }),
        );
    }

    notifyListeners();
  }

  Future<void> addOrder({
    required List<Map<String, dynamic>> items,
    required double total,
  }) async {
    _orders.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'date': DateTime.now().toIso8601String(),
      'items': items.map((item) => Map<String, dynamic>.from(item)).toList(),
      'total': total,
    });

    await _saveOrders();
    notifyListeners();
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _storageKey,
      jsonEncode(
        _orders.map((order) {
          return {
            ...order,
            'date': (order['date'] as DateTime).toIso8601String(),
          };
        }).toList(),
      ),
    );
  }
}
