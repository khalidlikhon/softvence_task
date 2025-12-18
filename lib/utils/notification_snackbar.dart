import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../routes/app_routes.dart';

class NotificationSnackbarService {
  /// Singleton
  NotificationSnackbarService._internal();
  static final NotificationSnackbarService _instance =
  NotificationSnackbarService._internal();
  factory NotificationSnackbarService() => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _subscription;

  final Set<String> _shownNotificationIds = {}; // avoid duplicates
  bool _isActive = false;
  String _currentScreen = '';

  /// Start realtime listener
  void start() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _isActive) return;

    _isActive = true;
    _subscription?.cancel();

    // First: Show all unread notifications
    await _showUnreadNotifications();

    // Then: listen for new ones realtime
    _subscription = _firestore
        .collection('notifications')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen(_onSnapshot);
  }

  /// Show unread notifications on app start
  Future<void> _showUnreadNotifications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final query = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: user.uid)
        .where('isRead', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .get();

    for (final doc in query.docs) {
      final data = doc.data();
      final docId = doc.id;

      if (_shownNotificationIds.contains(docId)) continue;
      _shownNotificationIds.add(docId);

      if (_currentScreen != Routes.notificationDetail) {
        _showSnackbar(
          title: data['title'] ?? 'Notification',
          body: data['body'] ?? '',
        );
      }

      // Mark as read
      await doc.reference.update({'isRead': true});
    }
  }

  void _onSnapshot(QuerySnapshot snapshot) {
    for (final change in snapshot.docChanges) {
      if (change.type != DocumentChangeType.added) continue;

      final docId = change.doc.id;
      final data = change.doc.data() as Map<String, dynamic>?;
      if (data == null || _shownNotificationIds.contains(docId)) continue;

      _shownNotificationIds.add(docId);

      if (_currentScreen != Routes.notificationDetail) {
        _showSnackbar(
          title: data['title'] ?? 'Notification',
          body: data['body'] ?? '',
        );

        // Mark as read
        _firestore.collection('notifications').doc(docId).update({'isRead': true});
      }
    }
  }

  void _showSnackbar({required String title, required String body}) {
    print('Showing snackbar: $title - $body'); // debug

    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      backgroundColor: const Color(0xFFEFEFEF),
      colorText: const Color(0xFF000000),
      margin: const EdgeInsets.all(10),
      borderRadius: 12,
      onTap: (_) => Get.toNamed(Routes.notificationDetail),
    );
  }


  void updateCurrentScreen(String screen) {
    _currentScreen = screen;
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _shownNotificationIds.clear();
    _isActive = false;
  }
}
