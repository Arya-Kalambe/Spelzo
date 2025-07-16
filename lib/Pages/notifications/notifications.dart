import 'package:flutter/material.dart';
import 'package:spelzo_app/Widgets/uihelper.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Example notification data
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Order Shipped',
      'message': 'Your order #1423 has been shipped successfully!',
      'time': '2h ago',
      'icon': Icons.local_shipping,
      'color': Colors.blue,
    },
    {
      'title': 'New Offer!',
      'message': 'Flat 50% off on selected items. Limited time only.',
      'time': '6h ago',
      'icon': Icons.local_offer,
      'color': Colors.green,
    },
    {
      'title': 'Wishlist Item on Sale',
      'message': 'One of your wishlist items is now at ₹799 only!',
      'time': '1d ago',
      'icon': Icons.favorite,
      'color': Colors.redAccent,
    },
    {
      'title': 'Payment Successful',
      'message': 'You have successfully paid ₹1,999 for Order #1398.',
      'time': '3d ago',
      'icon': Icons.payment,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F6F9),
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _notifications.isEmpty
          ? const Center(
        child: Text("No notifications available.",
            style: TextStyle(fontSize: 16, color: Colors.grey)),
      )
          : ListView.builder(
        itemCount: _notifications.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: notification['color'].withOpacity(0.1),
                  child: Icon(notification['icon'], color: notification['color']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification['title'],
                          style: UiHelper.boldTextFieldStyle()),
                      const SizedBox(height: 4),
                      Text(notification['message'],
                          style: const TextStyle(fontSize: 14, color: Colors.black87)),
                      const SizedBox(height: 4),
                      Text(notification['time'],
                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _notifications.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
