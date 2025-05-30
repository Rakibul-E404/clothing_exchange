// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});
//
//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }
//
// class _NotificationScreenState extends State<NotificationScreen> {
//   bool _hasUnreadNotifications = true;
//   final List<NotificationItem> _notifications = [
//     NotificationItem(
//       message: 'Afsana likes your T-shirt and wants to swap it.',
//       time: '10 minutes ago',
//       isRead: false,
//     ),
//     NotificationItem(
//       message: 'Afsana likes your T-shirt and wants to swap it.',
//       time: '10 minutes ago',
//       isRead: false,
//     ),
//     NotificationItem(
//       message: 'Afsana likes your T-shirt and wants to swap it.',
//       time: '10 minutes ago',
//       isRead: false,
//     ),
//   ];
//
//   void _markAllAsRead() {
//     setState(() {
//       _hasUnreadNotifications = false;
//       for (var notification in _notifications) {
//         notification.isRead = true;
//       }
//     });
//   }
//
//   void _markSingleAsRead(int index) {
//     setState(() {
//       _notifications[index].isRead = true;
//       // Check if all notifications are read
//       _hasUnreadNotifications = _notifications.any((n) => !n.isRead);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//         centerTitle: true,
//         elevation: 0,
//         actions: [
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.notifications),
//                 onPressed: _markAllAsRead,
//                 tooltip: 'Mark all as read',
//               ),
//               if (_hasUnreadNotifications)
//                 Positioned(
//                   right: 8,
//                   top: 8,
//                   child: Container(
//                     width: 12,
//                     height: 12,
//                     decoration: const BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 12,),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _notifications.length,
//               itemBuilder: (context, index) {
//                 final notification = _notifications[index];
//                 return NotificationTile(
//                   message: notification.message,
//                   time: notification.time,
//                   iconPath: 'assets/icons/unread_notification_icon.svg',
//                   isRead: notification.isRead,
//                   onTap: () => _markSingleAsRead(index),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class NotificationItem {
//   final String message;
//   final String time;
//   bool isRead;
//
//   NotificationItem({
//     required this.message,
//     required this.time,
//     required this.isRead,
//   });
// }
//
// class NotificationTile extends StatelessWidget {
//   final String message;
//   final String time;
//   final String iconPath;
//   final bool isRead;
//   final VoidCallback onTap;
//
//   const NotificationTile({
//     super.key,
//     required this.message,
//     required this.time,
//     required this.iconPath,
//     required this.isRead,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (!isRead)
//               SvgPicture.asset(
//                 iconPath,
//                 width: 24,
//                 height: 24,
//               ),
//             if (!isRead) const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     message,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: isRead ? FontWeight.normal : FontWeight.w500,
//                       color: isRead ? Colors.grey[600] : Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     time,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[400],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import '../../../Utils/app_url.dart';
import '../../../Utils/app_constants.dart';
import '../../../Utils/helper_shared_pref.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<NotificationItem>> _notificationsFuture;
  bool _hasUnreadNotifications = false;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = fetchNotifications();
  }

  Future<List<NotificationItem>> fetchNotifications() async {
    try {
      final token = SharedPrefHelper().getData(AppConstants.token);

      final url = '${AppUrl.baseUrl}/notification'; // your actual endpoint
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List notificationsJson =
            data['data']?['attributes']?['result'] ?? [];

        final notifications = notificationsJson
            .map((json) => NotificationItem.fromJson(json))
            .toList();

        // Update unread flag
        _hasUnreadNotifications =
            notifications.any((notification) => !notification.isRead);

        return notifications;
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception(
            'Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load notifications: ${e.toString()}');
    }
  }

  void _markAllAsRead(List<NotificationItem> notifications) {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
      _hasUnreadNotifications = false;
    });
    // TODO: Add backend sync if needed
  }

  void _markSingleAsRead(int index, List<NotificationItem> notifications) {
    setState(() {
      notifications[index].isRead = true;
      _hasUnreadNotifications = notifications.any((n) => !n.isRead);
    });
    // TODO: Add backend sync if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (_hasUnreadNotifications)
            IconButton(
              icon: const Icon(Icons.mark_email_read_outlined),
              tooltip: 'Mark all as read',
              onPressed: () async {
                // Need to refresh the list here
                final notifications = await _notificationsFuture;
                _markAllAsRead(notifications);
              },
            ),
        ],
      ),
      body: FutureBuilder<List<NotificationItem>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _notificationsFuture = fetchNotifications();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final notifications = snapshot.data!;
            if (notifications.isEmpty) {
              return const Center(child: Text('No notifications'));
            }
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationTile(
                  message: notification.title,
                  time: notification.content.trim(),
                  iconPath: 'assets/icons/unread_notification_icon.svg',
                  isRead: notification.isRead,
                  onTap: () => _markSingleAsRead(index, notifications),
                );
              },
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String content;
  final String status;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.content,
    required this.status,
    required this.isRead,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      status: json['status'] ?? 'unread',
      isRead: (json['status']?.toString().toLowerCase() == 'read'),
    );
  }
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


