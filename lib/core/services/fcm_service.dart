import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/userModel.dart';

class FCMService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Call this after user login
  Future<void> saveOrUpdateFCMToken(User firebaseUser) async {
    try {
      final docRef =
      _firestore.collection('users').doc(firebaseUser.uid);

      final doc = await docRef.get();

      // 🔹 Check notification permission from Firestore
      bool notificationEnabled = true;

      if (doc.exists && doc.data() != null) {
        notificationEnabled =
            doc.data()!['notificationEnabled'] ?? true;
      }

      // 🔕 If user turned OFF notification → remove token & stop
      if (!notificationEnabled) {
        await docRef.update({'fcmToken': FieldValue.delete()});
        debugPrint('Notification OFF → FCM token removed');
        return;
      }

      // 🔔 Get FCM token
      final String? token = await _messaging.getToken();
      if (token == null) return;

      // 🆕 New user
      if (!doc.exists) {
        final appUser = AppUser(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          phone: firebaseUser.phoneNumber ?? '',
          photoUrl: firebaseUser.photoURL,
          fcmToken: token,
          notificationEnabled: true,
        );

        await docRef.set(appUser.toMap());
      } else {
        // 🔁 Existing user → update token
        await docRef.update({'fcmToken': token});
      }

      debugPrint('FCM Token saved/updated for ${firebaseUser.uid}');
    } catch (e) {
      debugPrint('Error saving FCM token: $e');
    }

    // 🔄 Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) async {
      try {
        final uid = firebaseUser.uid;
        final doc =
        await _firestore.collection('users').doc(uid).get();

        final isEnabled =
            doc.data()?['notificationEnabled'] ?? true;

        if (!isEnabled) return;

        await _firestore
            .collection('users')
            .doc(uid)
            .update({'fcmToken': newToken});

        debugPrint('FCM Token refreshed for $uid');
      } catch (e) {
        debugPrint('Error updating refreshed token: $e');
      }
    });
  }


  /// 🔕 Remove token manually (when user turns OFF notification)
  Future<void> removeFCMToken(String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'fcmToken': FieldValue.delete()});

      debugPrint('FCM Token removed for $uid');
    } catch (e) {
      debugPrint('Error removing FCM token: $e');
    }
  }
}
