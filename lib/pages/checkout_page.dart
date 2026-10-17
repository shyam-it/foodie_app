import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          const double deliveryCharge = 30;

          final subtotal = cart.totalPrice;
          final grandTotal = subtotal + deliveryCharge;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: ListView.builder(
                    itemCount: cart.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cart.cartItems[index];
                      final quantity = item['quantity'] as int;
                      final price = (item['price'] as num).toDouble();

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(item['image']),
                          ),
                          title: Text(item['name']),
                          subtitle: Text(
                            '₹${price.toStringAsFixed(0)} × $quantity',
                          ),
                          trailing: Text(
                            '₹${(price * quantity).toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const Divider(),

                _priceRow('Subtotal', subtotal),
                _priceRow('Delivery Charge', deliveryCharge),

                const Divider(),

                _priceRow('Grand Total', grandTotal, isBold: true),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),

                    onPressed: () {
                      if (cart.cartItems.isEmpty) {
                        return;
                      }

                      cart.clearCart();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Order placed successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.popUntil(context, (route) => route.isFirst);
                    },

                    child: const Text('Place Order'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _priceRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 15,
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 15,
            ),
          ),
        ],
      ),
    );
  }
}
