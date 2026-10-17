import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider extends ChangeNotifier {
  static const String _storageKey = 'favorite_food_ids';

  final List<String> _favoriteIds = [];
  bool _isLoaded = false;

  List<String> get favoriteIds => List.unmodifiable(_favoriteIds);

  bool get isLoaded => _isLoaded;

  WishlistProvider() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList(_storageKey) ?? [];

    _favoriteIds
      ..clear()
      ..addAll(savedIds);

    _isLoaded = true;
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favoriteIds.contains(id);
  }

  Future<void> toggleFavorite(String id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, _favoriteIds);
  }
}
