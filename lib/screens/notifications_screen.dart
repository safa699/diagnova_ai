
import 'package:flutter/material.dart';

const Color notificationNavy = Color(0xFF102A43);
const Color notificationTeal = Color(0xFF087E8B);
const Color notificationBackground = Color(0xFFF6F9FC);

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Appointment Reminder',
      'message': 'Your doctor appointment is coming up. Be ready on time.',
      'time': 'Today',
      'icon': Icons.calendar_month_rounded,
      'read': false,
    },
    {
      'title': 'Medical Record Updated',
      'message': 'Your medical record has been successfully added.',
      'time': 'Yesterday',
      'icon': Icons.folder_open_rounded,
      'read': false,
    },
    {
      'title': 'Health Tip',
      'message': 'Remember to drink enough water and stay hydrated.',
      'time': '2 days ago',
      'icon': Icons.favorite_rounded,
      'read': true,
    },
    {
      'title': 'Welcome to Diagnova AI',
      'message': 'Thank you for choosing Diagnova AI for your healthcare journey.',
      'time': '3 days ago',
      'icon': Icons.health_and_safety_rounded,
      'read': true,
    },
  ];

  int get unreadCount =>
      notifications.where((item) => item['read'] == false).length;

  void markAllAsRead() {
    setState(() {
      for (var item in notifications) {
        item['read'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void markAsRead(int index) {
    setState(() {
      notifications[index]['read'] = true;
    });
  }

  void deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: notificationBackground,
      appBar: AppBar(
        backgroundColor: notificationBackground,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: notificationNavy,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: markAllAsRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(color: notificationTeal),
              ),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Row(
              children: [
                const Text(
                  'Recent Updates',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: notificationNavy,
                  ),
                ),
                const Spacer(),
                Text(
                  '$unreadCount unread',
                  style: const TextStyle(
                    color: notificationTeal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: notifications.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 65,
                    color: Colors.blueGrey.shade200,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No Notifications',
                    style: TextStyle(
                      color: notificationNavy,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'You are all caught up!',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                final isRead = item['read'] as bool;

                return Dismissible(
                  key: ValueKey(item['title']),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (_) => deleteNotification(index),
                  child: Card(
                    elevation: 0,
                    color: isRead ? Colors.white : const Color(0xFFEAF6F6),
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        markAsRead(index);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(item['title']),
                            content: Text(item['message']),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              child: Icon(
                                item['icon'] as IconData,
                                color: notificationTeal,
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['title'] as String,
                                          style: const TextStyle(
                                            color: notificationNavy,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      if (!isRead)
                                        Container(
                                          width: 9,
                                          height: 9,
                                          decoration: const BoxDecoration(
                                            color: notificationTeal,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['message'] as String,
                                    style: const TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item['time'] as String,
                                    style: const TextStyle(
                                      color: notificationTeal,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
