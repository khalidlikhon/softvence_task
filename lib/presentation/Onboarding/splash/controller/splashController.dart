import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/userModel.dart';
import '../../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<AppUser?> currentUser = Rx<AppUser?>(null);
  RxBool isChecking = false.obs;

  Future<void> onLetsGoLongPress() async {
    if (isChecking.value) return; // prevent double trigger

    isChecking.value = true;

    // ⏳ Fake checking animation
    await Future.delayed(const Duration(seconds: 2));

    final firebaseUser = FirebaseAuth.instance.currentUser;

    // Check notification (terminated)
    final initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (firebaseUser == null) {
      // 🚪 Not logged in
      Get.offAllNamed(Routes.login);
    } else {
      // 👤 Fetch user
      final doc =
      await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (doc.exists) {
        currentUser.value = AppUser.fromMap(doc.data()!);
      }

      if (initialMessage != null) {
        // 🔔 Open notification details
        Get.offAllNamed(
          Routes.notificationDetail,
          arguments: initialMessage.data,
        );
      } else {
        // 🏠 Go home
        Get.offAllNamed(Routes.home);
      }
    }

    isChecking.value = false;
  }
}
