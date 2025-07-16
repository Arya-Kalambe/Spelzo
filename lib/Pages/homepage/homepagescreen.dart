import 'package:flutter/material.dart';
import 'package:spelzo_app/Pages/games/memory_game.dart' show MemoryGame;
import 'package:spelzo_app/Widgets/uihelper.dart';
import 'package:spelzo_app/Pages/cart/cart.dart';
import 'package:spelzo_app/Pages/wishlist/wishlist.dart';
import 'package:spelzo_app/Pages/notifications/notifications.dart';
import 'package:spelzo_app/Pages/search/search.dart'; // ✅ Added SearchPage import

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> bannerImages = [
    "Image.jfif",
    "Image (1).jfif",
    "Image (2).jfif",
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: UiHelper.CustomImage(
            imgurl: "menu.png",
            height: 30,
            width: 30,
          ),
        ),
        title: Row(
          children: [
            UiHelper.CustomImage(imgurl: "logo.png", height: 40, width: 100),
            const Spacer(),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                UiHelper.CustomImage(
                  imgurl: "coin.png",
                  height: 36,
                  width: 36,
                ),
                Positioned(
                  bottom: -4,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "70",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsPage()),
              );
            },
            icon: UiHelper.CustomImage(
              imgurl: "notification.png",
              height: 30,
              width: 30,
            ),
          ),
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
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
            icon: UiHelper.CustomImage(
              imgurl: "cart.png",
              height: 30,
              width: 30,
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFEAF6FB),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                /// 🔍 Search Row (with navigation)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchPage()),
                    );
                  },
                  child: Row(
                    children: [
                      UiHelper.CustomImage(
                        imgurl: "plane.png",
                        height: 80,
                        width: 80,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.search, color: Colors.black54),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Search product",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.tune, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// Banner Carousel
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: bannerImages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: UiHelper.CustomImage(
                          imgurl: bannerImages[index],
                          fit: BoxFit.cover,
                          height: 250,
                          width: double.infinity,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                /// Dots Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(bannerImages.length, (index) {
                    bool isActive = index == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 10,
                      width: isActive ? 24 : 10,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.redAccent : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 16),

                /// Info Row
                Container(
                  height: 80,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UiHelper.CustomImage(
                          imgurl: "cat.png", height: 50, width: 50),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Earn coins, unlock a pet house,",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "and adopt a cute virtual pet!",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      UiHelper.CustomImage(
                          imgurl: "rarrow.png", height: 24, width: 24),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// Game Cards Section
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildGameCard(
                          "traffic.png", "Traffic Jam", Colors.amber.shade100),
                      const SizedBox(width: 12),
                      _buildGameCard(
                          "racing.png", "Racing Cars", Colors.red.shade100),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MemoryGame()),
                          );
                        },
                        child: _buildGameCard(
                          "memory.png", "Memory Game", Colors.green.shade100,
                        ),
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// Kids Playing Image
                UiHelper.CustomImage(
                  imgurl: "kids_playing.png",
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Game Card Builder
  Widget _buildGameCard(String img, String label, Color bgColor) {
    return Container(
      width: 120,
      height: 200,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.CustomImage(
            imgurl: img,
            height: 130,
            width: 100,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
