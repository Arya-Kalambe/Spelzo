import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spelzo_app/Pages/profile/address.dart' show AddressPage;
import 'package:spelzo_app/Widgets/uihelper.dart';
import 'package:spelzo_app/Pages/cart/cart.dart';
import 'package:spelzo_app/Pages/wishlist/wishlist.dart';
import 'package:spelzo_app/Pages/notifications/notifications.dart';
import 'package:spelzo_app/Pages/profile/personalinfo.dart';
import 'package:spelzo_app/Pages/profile/editprofile.dart';
import 'package:spelzo_app/Pages/models/user_manager.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = UserManager.user;
    return Scaffold(
      backgroundColor: const Color(0xFFEAF6FB),
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
                        color: Colors.white,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Profile image and name
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: user.imagePath != null
                      ? Image.file(
                    File(user.imagePath!),
                    height: 90,
                    width: 90,
                    fit: BoxFit.cover,
                  )
                      : UiHelper.CustomImage(
                    imgurl: "char.png",
                    height: 90,
                    width: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// Section 1
            _buildCard([
              _buildTile(Icons.person_outline, "Personal Info", onTap: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PersonalInfoPage()),
                ).then((value) => setState(() {}));
              }),
              _buildTile(Icons.location_on_outlined, "Addresses", onTap: (context){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddressPage()),
                ).then((value) => setState(() {}));
              }),
            ]),

            /// Section 2
            _buildCard([
              _buildTile(Icons.shopping_cart_outlined, "Cart", onTap: (context){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
              ).then((value) => setState(() {}));
              }),
              _buildTile(Icons.favorite_border, "Favourite", onTap: (context){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WishlistPage()),
                ).then((value) => setState(() {}));
              }),
              _buildTile(Icons.notifications_none, "Notifications", onTap: (context){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                ).then((value) => setState(() {}));
              }),
              _buildTile(Icons.credit_card, "Payment Method"),
              _buildTile(Icons.system_update_alt, "Version Update"),
            ]),

            /// Section 3
            _buildCard([
              _buildTile(Icons.help_outline, "FAQs"),
              _buildTile(Icons.person_outline, "Edit Profile", onTap: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                ).then((value) => setState(() {}));
              }),
              _buildTile(Icons.settings, "Settings"),
            ]),

            /// Section 4
            _buildCard([
              _buildTile(Icons.logout, "Log Out", isLogout: true),
            ]),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTile(IconData icon, String title,
      {bool isLogout = false, void Function(BuildContext)? onTap}) {
    return Builder(builder: (context) {
      return ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: isLogout ? Colors.red : Colors.deepPurple),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.red : Colors.black,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          if (onTap != null) {
            onTap(context);
          }
        },
      );
    });
  }
}