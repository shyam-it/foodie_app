import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/food_data.dart';
import '../providers/wishlist_provider.dart';
import 'food_details_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites ❤️'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlist, child) {
          final favoriteFoods = foodList.where((food) {
            final foodId = food['name'].toString();
            return wishlist.isFavorite(foodId);
          }).toList();

          if (favoriteFoods.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 70, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'No favorites yet!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('Add your favorite foods ❤️'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteFoods.length,
            itemBuilder: (context, index) {
              final food = favoriteFoods[index];
              final foodId = food['name'].toString();

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    Image.network(
                      food['image'],
                      width: 110,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 110,
                          height: 120,
                          color: Colors.orange.shade50,
                          child: const Icon(Icons.fastfood, size: 40),
                        );
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₹${food['price']}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  tooltip: 'Remove from favorites',
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    wishlist.toggleFavorite(foodId);
                                  },
                                ),
                                const Spacer(),
                                TextButton(
                                  child: const Text('View'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FoodDetailsPage(food: food),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
