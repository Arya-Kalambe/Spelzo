import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spelzo_app/Pages/games/coin_collector_game.dart';
import 'package:spelzo_app/Pages/games/memory_game.dart';
import 'package:spelzo_app/Pages/games/bubble_car_pop_game.dart';
import 'package:spelzo_app/Pages/games/flappy_bird_clone.dart';
import 'package:spelzo_app/Widgets/uihelper.dart';

class Gamepage extends StatefulWidget {
  const Gamepage({super.key});

  @override
  State<Gamepage> createState() => _GamepageState();
}

class _GamepageState extends State<Gamepage> {
  final PageController _pageController = PageController(viewportFraction: 0.6);
  double _currentPage = 0.0;
  late final Timer _autoScrollTimer;

  final List<Map<String, dynamic>> games = [
    {
      "title": "Bubble Car Pop",
      "subtitle": "Tap To Play Game",
      "color": const Color(0xFF00BFA5),
      "icon": "cars.png",
      "onTap": (context) =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => BubbleCarPopGame())),
    },
    {
      "title": "Car Memory",
      "subtitle": "Tap To Play Game",
      "color": const Color(0xFF43A047),
      "icon": "coin.png",
      "onTap": (context) =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => MemoryGame())),
    },
    {
      "title": "Coin Collector",
      "subtitle": "Tap To Play Game",
      "color": const Color(0xFF1E88E5),
      "icon": "coin.png",
      "onTap": (context) =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => CoinCollectorGame())),
    },
    {
      "title": "Flappy Bird",
      "subtitle": "Tap To Play Game",
      "color": const Color(0xFF8E24AA),
      "icon": "coin.png",
      "onTap": (context) =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => FlappyBird())),
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      int nextPage = (_pageController.page?.round() ?? 0) + 1;
      if (nextPage >= games.length) nextPage = 0;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: UiHelper.CustomImage(
                          imgurl: "char.png",
                          height: 48,
                          width: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Hello!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            "Arya",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        UiHelper.CustomImage(
                          imgurl: "coin.png",
                          height: 18,
                          width: 18,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "12000",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🐱 Cat Care Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF77cbda), Color(0xFFc4eef7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Love them. Feed them. Care for them",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "\"Taking care of your pet isn’t just a duty, it’s a promise of love, compassion, and lifelong companionship.\"",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.star, size: 16),
                          label: const Text("100"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  UiHelper.CustomImage(
                    imgurl: "cat.png",
                    height: 120,
                    width: 90,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 🎮 Game Carousel Section
            SizedBox(
              height: 250,
              child: PageView.builder(
                controller: _pageController,
                itemCount: games.length,
                itemBuilder: (context, index) {
                  final game = games[index];
                  double scale = (_currentPage - index).abs() < 1
                      ? 1 - (_currentPage - index).abs() * 0.2
                      : 0.8;

                  return Transform.scale(
                    scale: scale,
                    child: _buildGameCard(
                      context,
                      title: game["title"],
                      subtitle: game["subtitle"],
                      color: game["color"],
                      imageAsset: game["icon"],
                      onTap: () => game["onTap"](context),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // 🌟 Fun Fact Card with popping image
            const Text(
              "Fun Fact",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildFunFactCard(),
          ],
        ),
      ),
    );
  }

  // Game Card Builder
  Widget _buildGameCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String imageAsset,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            UiHelper.CustomImage(
              imgurl: imageAsset,
              height: 60,
              width: 60,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // New Fun Fact Card
  Widget _buildFunFactCard() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFE5C87), Color(0xFFFF8B64)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Cars",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Hot Wheels cars are so precisely engineered, even real car brands license designs to them.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                const SizedBox(width: 80),
              ],
            ),
          ),
          Positioned(
            right: -10,
            top: 100,
            bottom: 10,
            child: Image.asset(
              'assets/images/cars.png', // Replace with your image
              height: 140,
              width: 140,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
