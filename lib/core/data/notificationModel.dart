import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;          // Firestore document ID
  final String title;
  final String body;
  final DateTime time;      // DateTime from Firestore
  final String type;        // Optional: e.g., 'fcm', 'test'
  final bool isRead;        // Track read/unread status

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.type = 'default',
    this.isRead = false,
  });

  /// Convert Firestore map to model
  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      title: map['title'] ?? 'No Title',
      body: map['body'] ?? 'No Body',
      time: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: map['type'] ?? 'default',
      isRead: map['isRead'] ?? false,
    );
  }

  /// Convert model to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'createdAt': Timestamp.fromDate(time),
      'type': type,
      'isRead': isRead,
    };
  }

  /// Human-readable "time ago" format
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min${diff.inMinutes > 1 ? 's' : ''} ago';
    if (diff.inHours < 24) return '${diff.inHours} hr${diff.inHours > 1 ? 's' : ''} ago';
    if (diff.inDays < 7) return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}
