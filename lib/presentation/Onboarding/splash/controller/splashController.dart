import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/userModel.dart';
import '../../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<AppUser?> currentUser = Rx<AppUser?>(null);

  @override
  void onInit() {
    super.onInit();
    _handleStartupLogic();
  }

  Future<void> _handleStartupLogic() async {
    await Future.delayed(const Duration(seconds: 3));

    final firebaseUser = FirebaseAuth.instance.currentUser;

    // Check if app opened from notification (terminated)
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (firebaseUser == null) {
      // No user logged in
      Get.offAllNamed(Routes.login);
    } else {
      // Fetch user data from Firestore
      final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (doc.exists) {
        currentUser.value = AppUser.fromMap(doc.data()!);
      }

      if (initialMessage != null) {
        // Open notification detail if app opened from notification
        Get.offAllNamed(
          Routes.notificationDetail,
          arguments: initialMessage.data,
        );
      } else {
        // Otherwise go to home
        Get.offAllNamed(Routes.home);
      }
    }
  }
}
