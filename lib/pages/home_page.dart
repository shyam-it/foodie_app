import 'package:flutter/material.dart';
import '../data/category_data.dart';
import '../data/food_data.dart';
import 'food_details_page.dart';
import 'view_all_page.dart';
import 'cart_page.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = '';
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    final filteredFoods = foodList.where((food) {
      final matchesSearch = food['name'].toString().toLowerCase().contains(
        searchText.toLowerCase(),
      );

      final matchesCategory =
          selectedCategory.isEmpty || food['category'] == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Foodie App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ),
                      );
                    },
                  ),
                  if (cart.totalItems > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cart.totalItems}',
                          style: const TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'What would you like to eat?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // Search Food
          TextField(
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search burger, pizza...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchText.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          searchText = '';
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Categories Heading
          const Text(
            'Categories',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          // Category List
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                final category = categoryList[index];
                final categoryName = category['name'];
                final isSelected = selectedCategory == categoryName;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = isSelected ? '' : categoryName;
                    });
                  },
                  child: Container(
                    width: 90,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(
                          height: 65,
                          width: 65,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.deepOrange
                                : Colors.deepOrange.shade50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            category['icon'],
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          categoryName,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Popular Foods + View All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Foods',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              Row(
                children: [
                  if (selectedCategory.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = '';
                        });
                      },
                      child: const Text('Clear filter'),
                    ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewAllPage(),
                        ),
                      );
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Empty Result
          if (filteredFoods.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No food found!')),
            ),

          // Food Cards
          ...filteredFoods.map((food) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              clipBehavior: Clip.antiAlias,

              // Open Food Details on Tap
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodDetailsPage(food: food),
                    ),
                  );
                },

                child: Row(
                  children: [
                    Image.network(
                      food['image'],
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 120,
                          color: Colors.orange.shade50,
                          alignment: Alignment.center,
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

                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text('${food['rating']}'),
                              ],
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
