import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spelzo_app/Widgets/uihelper.dart';
import 'package:spelzo_app/Pages/Details/details.dart';
import 'package:spelzo_app/Pages/cart/cart.dart';

class Shopnow extends StatefulWidget {
  const Shopnow({super.key});

  @override
  State<Shopnow> createState() => _ShopnowState();
}

class _ShopnowState extends State<Shopnow> {
  final List<Map<String, dynamic>> productList = [
    {
      "title": "Double Sided Car",
      "subtitle": "PREMIUM",
      "img": "cars.png",
      "price": "1,249Rs",
    },
    {
      "title": "STEM Explorer Kit",
      "subtitle": "LEARN",
      "img": "stemtoys.png",
      "price": "1,249Rs",
    },
    {
      "title": "Speed Racing Bike",
      "subtitle": "HOT",
      "img": "bikes.png",
      "price": "1,099Rs",
    },
    {
      "title": "Robot AlphaX",
      "subtitle": "TECH",
      "img": "robots.png",
      "price": "1,499Rs",
    },
    {
      "title": "AI Smart Toy",
      "subtitle": "SMART",
      "img": "aitoys.png",
      "price": "1,299Rs",
    },
    {
      "title": "Puzzle Master",
      "subtitle": "EDUCATIONAL",
      "img": "puzzles.png",
      "price": "999Rs",
    },
  ];

  final List<Map<String, String>> categoryList = [
    {"img": "cars.png", "label": "Cars"},
    {"img": "stemtoys.png", "label": "STEM"},
    {"img": "bikes.png", "label": "Bikes"},
    {"img": "robots.png", "label": "Robots"},
    {"img": "aitoys.png", "label": "AI Toys"},
    {"img": "puzzles.png", "label": "Puzzles"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/profile.png"),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Hello!!", style: TextStyle(fontWeight:FontWeight.bold, fontSize: 16, color: Colors.black)),
                          Text("Arya", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartPage()),
                      );
                    },
                    icon: UiHelper.CustomImage(imgurl: "cart.png", height: 28, width: 28),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search toys, categories...",
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Categories
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    final category = categoryList[index];
                    return _buildCategoryItem(category["img"]!, category["label"]!);
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Top Picks Section
              _buildSectionHeader("Best Selling"),
              const SizedBox(height: 10),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    return _buildHorizontalCard(productList[index]);
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Hot Deals Section
              _buildSectionHeader("Our Products"),
              const SizedBox(height: 10),
              AnimationLimiter(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: productList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 240,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      columnCount: 2,
                      duration: const Duration(milliseconds: 500),
                      child: ScaleAnimation(
                        child: _buildVerticalCard(productList[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String img, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  offset: const Offset(2, 2),
                )
              ],
            ),
            child: UiHelper.CustomImage(imgurl: img, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: UiHelper.HeaderTextFieldStyle()),
        Text("View All", style: TextStyle(color: Colors.blue.shade700)),
      ],
    );
  }

  Widget _buildHorizontalCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Details(product: product)),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: UiHelper.CustomImage(
                imgurl: product['img'],
                height: 120,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(product['subtitle'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 5),
                  Text(product['price'], style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Details(product: product)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: UiHelper.CustomImage(
                imgurl: product['img'],
                height: 120,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(product['subtitle'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 5),
                  Text(product['price'], style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
