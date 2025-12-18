import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../core/data/userModel.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/notification_snackbar.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxBool isLoading = true.obs;
  Rx<AppUser?> user = Rx<AppUser?>(null);
  RxBool isNotificationOn = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
    NotificationSnackbarService().start();
  }

  /// ---------------- LOAD USER ----------------
  Future<void> loadUser() async {
    try {
      isLoading.value = true;

      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      final doc =
      await _firestore.collection('users').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        final appUser = AppUser.fromMap(doc.data()!);
        user.value = appUser;

        // 🔥 Sync switch state
        isNotificationOn.value = appUser.notificationEnabled;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------- TOGGLE NOTIFICATION ----------------
  Future<void> toggleNotification(bool value) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    isNotificationOn.value = value;

    try {
      await _firestore.collection('users').doc(uid).update({
        'notificationEnabled': value,
      });

      // 🔥 local model update
      user.value = user.value?.copyWith(
        notificationEnabled: value,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to update notification setting',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// ---------------- LOGOUT ----------------
  Future<void> logout() async {
    try {
      await _auth.signOut();
      NotificationSnackbarService().dispose();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Logout failed',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
