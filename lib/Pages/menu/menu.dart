import 'package:flutter/material.dart';
import 'package:spelzo_app/Widgets/uihelper.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool isSidebarOpen = true;

  final List<Map<String, dynamic>> menuItems = [
    {"icon": Icons.home, "title": "Home"},
    {"icon": Icons.person, "title": "Profile"},
    {"icon": Icons.settings, "title": "Settings"},
    {"icon": Icons.info, "title": "About"},
    {"icon": Icons.logout, "title": "Logout"},
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(_controller);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(_controller);

    _controller.forward(); // open sidebar on load
  }

  void toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
      isSidebarOpen ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Sidebar
          SlideTransition(
            position: _slideAnimation,
            child: SafeArea(
              child: Container(
                width: 250,
                color: Colors.blue.shade900,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: UiHelper.CustomImage(
                        imgurl: "char.png", // Only here you're using CustomImage
                        height: 90,
                        width: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "John Doe",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const Text(
                      "john.doe@example.com",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 30),
                    ...menuItems.map((item) => ListTile(
                      leading: Icon(item['icon'], color: Colors.white),
                      title: Text(
                        item['title'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        // You can handle navigation here
                        Navigator.pop(context); // example: close page
                      },
                    )),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: 0,
            bottom: 0,
            left: isSidebarOpen ? 200 : 0,
            right: isSidebarOpen ? -200 : 0,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Material(
                elevation: 8,
                borderRadius: isSidebarOpen
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(0),
                color: Colors.white,
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      title: const Text(
                        "Menu Page",
                        style: TextStyle(color: Colors.black),
                      ),
                      leading: IconButton(
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.menu_close,
                          progress: _controller,
                          color: Colors.black,
                        ),
                        onPressed: toggleSidebar,
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Main Content in Menu Page",
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
