import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationLog {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add notification for current user
  Future<void> addNotification({
    required String title,
    required String body,
    String type = 'default',
    bool isRead = false,
  }) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // User not logged in

    try {
      await _firestore.collection('notifications').add({
        'title': title,
        'body': body,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': user.uid,
        'type': type,
        'isRead': isRead,
      });
    } catch (e) {
      debugPrint('Error adding notification: $e');
    }
  }



  /// Convenience method for login notification
  Future<void> logLogin(String providerName) async {
    final now = DateTime.now();
    final formattedTime = DateFormat('d MMM, hh:mm a').format(now); // e.g., 25 Dec, 11:14 PM

    await addNotification(
      title: 'Welcome Back!',
      body: 'You are now logged in via $providerName.\n'
          'Your account is secure, and all recent activities are now up-to-date.\n\n'
          'Last access: $formattedTime',
      type: 'login',
      isRead: false,
    );
  }
}
