import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => FirebaseAuth.instance.currentUser;

  CollectionReference<Map<String, dynamic>> get notificationCollection =>
      _firestore.collection('notifications');

  int _unreadCount(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    return docs.where((doc) {
      return doc.data()['read'] != true;
    }).length;
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'appointment':
      case 'appointment reminder':
      case 'appointment confirmed':
        return Icons.calendar_month_rounded;

      case 'medical record':
      case 'medical record updated':
        return Icons.folder_open_rounded;

      case 'health tip':
        return Icons.favorite_rounded;

      case 'welcome':
        return Icons.health_and_safety_rounded;

      default:
        return Icons.notifications_active_rounded;
    }
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp == null || timestamp is! Timestamp) {
      return 'Recently';
    }

    final date = timestamp.toDate();
    final now = DateTime.now();

    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> _markAsRead(
      String notificationId,
      bool isRead,
      ) async {
    if (isRead) return;

    try {
      await notificationCollection.doc(notificationId).update({
        'read': true,
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not update notification: $e'),
        ),
      );
    }
  }

  Future<void> _markAllAsRead(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
      ) async {
    final unreadDocs = docs.where((doc) {
      return doc.data()['read'] != true;
    }).toList();

    if (unreadDocs.isEmpty) return;

    try {
      final batch = _firestore.batch();

      for (final doc in unreadDocs) {
        batch.update(doc.reference, {'read': true});
      }

      await batch.commit();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All notifications marked as read'),
          backgroundColor: notificationTeal,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not mark notifications as read: $e'),
        ),
      );
    }
  }

  Future<void> _deleteNotification(String notificationId) async {
    try {
      await notificationCollection.doc(notificationId).delete();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not delete notification: $e'),
        ),
      );
    }
  }

  void _showNotificationDetails(
      String notificationId,
      Map<String, dynamic> item,
      ) {
    final isRead = item['read'] == true;

    _markAsRead(notificationId, isRead);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            item['title']?.toString() ?? 'Notification',
            style: const TextStyle(
              color: notificationNavy,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            item['message']?.toString() ??
                'No notification details available.',
            style: const TextStyle(
              color: Colors.blueGrey,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: notificationTeal),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = currentUser;

    if (user == null) {
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
        ),
        body: const Center(
          child: Text('Please login to view notifications.'),
        ),
      );
    }

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
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: notificationCollection
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Could not load notifications.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: notificationTeal,
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];
          final unreadCount = _unreadCount(docs);

          final sortedDocs = [...docs];

          sortedDocs.sort((a, b) {
            final aTime = a.data()['createdAt'];
            final bTime = b.data()['createdAt'];

            final aDate = aTime is Timestamp
                ? aTime.toDate()
                : DateTime(2000);

            final bDate = bTime is Timestamp
                ? bTime.toDate()
                : DateTime(2000);

            return bDate.compareTo(aDate);
          });

          return Column(
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

              if (unreadCount > 0)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: TextButton(
                      onPressed: () => _markAllAsRead(docs),
                      child: const Text(
                        'Mark all read',
                        style: TextStyle(color: notificationTeal),
                      ),
                    ),
                  ),
                ),

              Expanded(
                child: sortedDocs.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: sortedDocs.length,
                  itemBuilder: (context, index) {
                    final document = sortedDocs[index];
                    final item = document.data();

                    final isRead = item['read'] == true;
                    final title =
                        item['title']?.toString() ??
                            'Notification';
                    final message =
                        item['message']?.toString() ?? '';
                    final type =
                        item['type']?.toString() ?? '';
                    final time =
                    _formatTime(item['createdAt']);

                    return Dismissible(
                      key: ValueKey(document.id),
                      direction:
                      DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(
                          right: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (_) {
                        _deleteNotification(document.id);
                      },
                      child: Card(
                        elevation: 0,
                        color: isRead
                            ? Colors.white
                            : const Color(0xFFEAF6F6),
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          borderRadius:
                          BorderRadius.circular(16),
                          onTap: () {
                            _showNotificationDetails(
                              document.id,
                              item,
                            );
                          },
                          child: Padding(
                            padding:
                            const EdgeInsets.all(15),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor:
                                  Colors.white,
                                  child: Icon(
                                    _getNotificationIcon(
                                      type,
                                    ),
                                    color: notificationTeal,
                                  ),
                                ),
                                const SizedBox(width: 13),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              title,
                                              style:
                                              const TextStyle(
                                                color:
                                                notificationNavy,
                                                fontWeight:
                                                FontWeight
                                                    .bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          if (!isRead)
                                            Container(
                                              width: 9,
                                              height: 9,
                                              decoration:
                                              const BoxDecoration(
                                                color:
                                                notificationTeal,
                                                shape: BoxShape
                                                    .circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        message,
                                        style:
                                        const TextStyle(
                                          color:
                                          Colors.blueGrey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        time,
                                        style:
                                        const TextStyle(
                                          color:
                                          notificationTeal,
                                          fontSize: 11,
                                          fontWeight:
                                          FontWeight.w600,
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
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
    );
  }
}
