import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _hasUnreadNotifications = true;
  final List<NotificationItem> _notifications = [
    NotificationItem(
      message: 'Afsana likes your T-shirt and wants to swap it.',
      time: '10 minutes ago',
      isRead: false,
    ),
    NotificationItem(
      message: 'Afsana likes your T-shirt and wants to swap it.',
      time: '10 minutes ago',
      isRead: false,
    ),
    NotificationItem(
      message: 'Afsana likes your T-shirt and wants to swap it.',
      time: '10 minutes ago',
      isRead: false,
    ),
  ];

  void _markAllAsRead() {
    setState(() {
      _hasUnreadNotifications = false;
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  void _markSingleAsRead(int index) {
    setState(() {
      _notifications[index].isRead = true;
      // Check if all notifications are read
      _hasUnreadNotifications = _notifications.any((n) => !n.isRead);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: _markAllAsRead,
                tooltip: 'Mark all as read',
              ),
              if (_hasUnreadNotifications)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 12,),
          Expanded(
            child: ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return NotificationTile(
                  message: notification.message,
                  time: notification.time,
                  iconPath: 'assets/icons/unread_notification_icon.svg',
                  isRead: notification.isRead,
                  onTap: () => _markSingleAsRead(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final String message;
  final String time;
  bool isRead;

  NotificationItem({
    required this.message,
    required this.time,
    required this.isRead,
  });
}

class NotificationTile extends StatelessWidget {
  final String message;
  final String time;
  final String iconPath;
  final bool isRead;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.message,
    required this.time,
    required this.iconPath,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isRead)
              SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
              ),
            if (!isRead) const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isRead ? FontWeight.normal : FontWeight.w500,
                      color: isRead ? Colors.grey[600] : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}