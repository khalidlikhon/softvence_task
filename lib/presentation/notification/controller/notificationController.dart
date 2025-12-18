import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/data/notificationModel.dart';

class NotificationController extends GetxController {
  /// ================= STATE =================
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool hasUnread = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ================= LIFECYCLE =================
  @override
  void onInit() {
    super.onInit();
    _listenNotifications();
  }

  /// ================= FIRESTORE LISTENER =================
  void _listenNotifications() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _firestore
        .collection('notifications')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final list = snapshot.docs
          .map((doc) =>
          NotificationModel.fromMap(doc.data(), doc.id))
          .toList();

      notifications.value = list;

      // 🔴 red dot controller
      hasUnread.value = list.any((n) => !n.isRead);
    });
  }

  /// ================= TAP HANDLER =================
  Future<void> onNotificationTap(NotificationModel item) async {
    // 1️⃣ Mark as read
    if (!item.isRead) {
      await _firestore
          .collection('notifications')
          .doc(item.id)
          .update({'isRead': true});
    }

    // 2️⃣ Open smart dialog (UI widget)
    Get.dialog(
      NotificationSmartDialog(notification: item),
      barrierDismissible: true,
    );
  }

  /// ================= DELETE =================
  Future<void> deleteNotification(NotificationModel item) async {
    await _firestore
        .collection('notifications')
        .doc(item.id)
        .delete();
  }
}

class NotificationSmartDialog extends StatelessWidget {
  final NotificationModel notification;

  const NotificationSmartDialog({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              notification.body,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                notification.timeAgo,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

