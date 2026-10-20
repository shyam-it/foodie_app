import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class FoodDetailsPage extends StatelessWidget {
  final Map<String, dynamic> food;

  const FoodDetailsPage({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Details'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              food['image'],
              width: double.infinity,
              height: 280,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 280,
                  width: double.infinity,
                  color: Colors.orange.shade50,
                  child: const Icon(Icons.fastfood, size: 80),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food['name'],
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 6),
                      Text(
                        '${food['rating']} Rating',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Category: ${food['category']}',
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    '₹${food['price']}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return ElevatedButton.icon(
                          onPressed: () {
                            cart.addToCart(food);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${food['name']} added to cart!'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text('Add to Cart'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
