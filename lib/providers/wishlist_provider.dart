import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  final List<String> _favoriteIds = [];

  List<String> get favoriteIds => List.unmodifiable(_favoriteIds);

  bool isFavorite(String id) {
    return _favoriteIds.contains(id);
  }

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }

    notifyListeners();
  }
}
