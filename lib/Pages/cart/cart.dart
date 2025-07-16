import 'package:flutter/material.dart';
import 'package:spelzo_app/Widgets/uihelper.dart';
import 'package:spelzo_app/Pages/Details/details.dart';
import 'package:spelzo_app/Pages/wishlist/wishlist.dart'; // ✅ For WishlistPage

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartItems = CartManager.items;

    double total = 0;
    for (var item in cartItems) {
      final price = double.tryParse(item['price'].replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      total += price * item['quantity'];
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEAF6FB),
      appBar: AppBar(
        title: const Text("My Cart", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistPage()),
              );
            },
            icon: UiHelper.CustomImage(
              imgurl: "heart.png",
              height: 30,
              width: 30,
            ),
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty."))
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          final price = double.tryParse(item['price'].replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                UiHelper.CustomImage(
                  imgurl: item['img'],
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 12),

                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(item['title'],
                            style: UiHelper.boldTextFieldStyle()),
                      ),
                      const SizedBox(height: 4),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text("• UPPER BODY: BLACK",
                            style: TextStyle(fontSize: 13)),
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text("• LOWER BODY: BLACK",
                            style: TextStyle(fontSize: 13)),
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text("• ACCESSORIES: GREY",
                            style: TextStyle(fontSize: 13)),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "₹${(price * item['quantity']).toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Quantity & Delete Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      if (item['quantity'] > 1) {
                                        item['quantity']--;
                                      }
                                    });
                                  },
                                ),
                                Text('${item['quantity']}',
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      item['quantity']++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade50,
                              foregroundColor: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                CartManager.removeFromCart(item['title']);
                              });
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total: ₹${total.toStringAsFixed(2)}",
                style: UiHelper.boldTextFieldStyle().copyWith(fontSize: 18)),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Checkout functionality not implemented.")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade300,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text("Buy Now",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
