import 'package:flutter/material.dart';
import 'package:spelzo_app/Pages/games/game.dart';
import 'package:spelzo_app/Pages/homepage/homepagescreen.dart';
import 'package:spelzo_app/Pages/profile/userprofile.dart';
import 'package:spelzo_app/Pages/shop/shopnow.dart';
import 'package:spelzo_app/Widgets/uihelper.dart';

class BottomnavScreen extends StatefulWidget {
  @override
  State<BottomnavScreen> createState() => _BottomnavScreenState();
}

class _BottomnavScreenState extends State<BottomnavScreen> {
  int currentIndex = 0;
  List<Widget> pages = [
    HomePage(),
    Shopnow(),
    Gamepage(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type :BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        }, // ensures equal spacing
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 35,
              width: 65,
              child: UiHelper.CustomImage(imgurl: "home.png", height: 24, width: 24),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 35,
              width: 65,
              child: UiHelper.CustomImage(imgurl: "shop.png", height: 24, width: 24),
            ),
            label: "Shop now",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 35,
              width: 65,
              child: UiHelper.CustomImage(imgurl: "game.png", height: 24, width: 24),
            ),
            label: "Game",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 35,
              width: 65,
              child: UiHelper.CustomImage(imgurl: "profile.png", height: 24, width: 24),
            ),
            label: "Profile",
          ),
        ],
      ),
      body: IndexedStack(
        children: pages,
        index: currentIndex,
      ),
    );
  }
}
