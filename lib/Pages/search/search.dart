import 'package:flutter/material.dart';
import 'package:spelzo_app/Widgets/uihelper.dart';
import 'package:spelzo_app/Pages/Details/details.dart';

/// ✅ Manager class inside same file
class RecentViewManager {
  static final List<Map<String, dynamic>> _recentlyViewed = [];

  static List<Map<String, dynamic>> get items => _recentlyViewed;

  static void addToRecent(Map<String, dynamic> product) {
    _recentlyViewed.removeWhere((item) => item['title'] == product['title']);
    _recentlyViewed.insert(0, product);
  }

  static void removeFromRecent(String title) {
    _recentlyViewed.removeWhere((item) => item['title'] == title);
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allProducts = [
    {
      "title": "Double Sided Car",
      "subtitle": "PREMIUM",
      "img": "cars.png",
      "price": "1,249Rs",
      "description":
      "Double-sided drive: Flips 360° and runs on both sides\nAll-terrain: Works on grass, sand, gravel, and indoors\n360° stunts: Spins, flips, and rotates with ease\nRemote range: 2.4GHz, up to 50m\nBattery: Rechargeable (car), AA batteries (remote)\nMaterial: Durable, child-safe ABS plastic\nBest for: Kids 5+ years"
    },
    {
      "title": "STEM Explorer Kit",
      "subtitle": "LEARN",
      "img": "stemtoys.png",
      "price": "1,249Rs",
      "description":
      "Hands-on science experiments\nDevelops logical thinking and curiosity\nSafe for 6+ years kids\nBattery-powered features"
    },
    {
      "title": "Speed Racing Bike",
      "subtitle": "HOT",
      "img": "bikes.png",
      "price": "1,099Rs",
      "description":
      "Sturdy frame, dual suspension\nRealistic sound effects\nRechargeable battery\nBest for kids 6+ years"
    },
    {
      "title": "Robot AlphaX",
      "subtitle": "TECH",
      "img": "robots.png",
      "price": "1,499Rs",
      "description":
      "Voice control enabled\nLED lights, dancing mode\nRemote range: 30m\nSafe plastic for ages 5+"
    },
    {
      "title": "AI Smart Toy",
      "subtitle": "SMART",
      "img": "aitoys.png",
      "price": "1,299Rs",
      "description":
      "AI voice response toy\nRecognizes emotions\nInteractive learning\nPerfect for ages 4–8"
    },
    {
      "title": "Puzzle Master",
      "subtitle": "EDUCATIONAL",
      "img": "puzzles.png",
      "price": "999Rs",
      "description":
      "Challenging brain puzzles\nImproves problem solving\nFun for family and kids\nSafe material for 5+ years"
    },
  ];

  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterProducts);
  }

  void _filterProducts() {
    final query = _searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredProducts = [];
      } else {
        _filteredProducts = _allProducts.where((product) {
          final title = product['title'].toString().toLowerCase();
          return title.contains(query);
        }).toList();
      }
    });
  }

  void _addToRecent(Map<String, dynamic> product) {
    setState(() {
      RecentViewManager.addToRecent(product);
    });
  }

  void _removeRecent(String title) {
    setState(() {
      RecentViewManager.removeFromRecent(title);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF6FB),
      appBar: AppBar(
        title: const Text("Search Products", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// 🔍 Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Search by product title...",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// 📋 Results or Recent Views
            Expanded(
              child: _searchController.text.isNotEmpty
                  ? _filteredProducts.isEmpty
                  ? const Center(child: Text("No products found."))
                  : _buildProductList(_filteredProducts)
                  : RecentViewManager.items.isEmpty
                  ? const Center(child: Text("No recent views."))
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Recently Viewed",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Expanded(child: _buildRecentList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🧾 List Builder for Search or Recent
  Widget _buildProductList(List<Map<String, dynamic>> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final product = list[index];
        return GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Details(product: product)),
            );
            _addToRecent(product);
          },
          child: _buildProductTile(product),
        );
      },
    );
  }

  /// 🧾 Recently Viewed with Remove Icon
  Widget _buildRecentList() {
    final list = RecentViewManager.items;
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final product = list[index];
        return Stack(
          children: [
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Details(product: product)),
                );
                _addToRecent(product);
              },
              child: _buildProductTile(product),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _removeRecent(product['title']),
                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 🧱 UI Card
  Widget _buildProductTile(Map<String, dynamic> product) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          UiHelper.CustomImage(
            imgurl: product['img'],
            height: 80,
            width: 80,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product['title'], style: UiHelper.boldTextFieldStyle()),
                const SizedBox(height: 4),
                Text(product['price'],
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
