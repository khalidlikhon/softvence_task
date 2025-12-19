import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/services/fcm_service.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/data/userModel.dart';
import '../../../../utils/_notificationLog.dart';

class AuthController extends GetxController {
  // UI States
  RxBool isChecked = false.obs;
  RxBool isLoading = false.obs;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FCMService _fcmService = FCMService();

  final notificationService = NotificationLog();

  // ================= SAVE USER + FCM TOKEN =================
  Future<void> _saveUserIfNotExists(
    User firebaseUser, {
    String? name,
    String? email,
    String? photoUrl,
  }) async {
    final docRef = _firestore.collection('users').doc(firebaseUser.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final appUser = AppUser(
        uid: firebaseUser.uid,
        name: name ?? firebaseUser.displayName ?? '',
        email: email ?? firebaseUser.email ?? '',
        phone: '',
        photoUrl: photoUrl ?? firebaseUser.photoURL,
        notificationEnabled: true,
      );
      await docRef.set(appUser.toMap());
    }

    // ✅ FCM token add/update
    await _fcmService.saveOrUpdateFCMToken(firebaseUser);
  }

  // ================= EMAIL LOGIN =================
  Future<void> loginWithEmail(String email, String password) async {
    try {
      isLoading.value = true;

      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _saveUserIfNotExists(result.user!);

      await notificationService.logLogin('Credentials');
      Get.snackbar('Success', 'Logged in successfully');
      Get.offAllNamed(Routes.home);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Login failed');
    } finally {
      isLoading.value = false;
    }
  }

  // ================= GOOGLE LOGIN =================
  Future<void> loginWithGoogle() async {
    const String webClientId =
        '660278222064-mmfaau101mv23vjckuu8k41urm4tumq5.apps.googleusercontent.com';

    try {
      isLoading.value = true;

      GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(serverClientId: webClientId);
      GoogleSignInAccount? account = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          await account.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);

      await _saveUserIfNotExists(result.user!);

      await notificationService.logLogin('Google');
      Get.snackbar('Success', 'Logged in with Google');
      Get.offAllNamed(Routes.home);
    } catch (e) {
      Get.snackbar('Error', e.toString());
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ================= FACEBOOK LOGIN =================
  Future<void> loginWithFacebook() async {
    try {
      isLoading.value = true;

      // Step 1: Login with Facebook permissions
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        // Step 2: Get Facebook user data
        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email,picture.width(200)",
        );

        final String name = userData['name'] ?? '';
        final String email = userData['email'] ?? '';
        final String profileImage = userData['picture']['data']['url'] ?? '';

        debugPrint('FB Name: $name');
        debugPrint('FB Email: $email');
        debugPrint('FB Profile Image: $profileImage');

        // Step 3: Firebase Auth with Facebook credential
        final credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );
        final authResult = await _auth.signInWithCredential(credential);

        // Step 4: Save user info in Firestore with profile image
        await _saveUserIfNotExists(
          authResult.user!,
          name: name,
          email: email,
          photoUrl: profileImage,
        );

        await notificationService.logLogin('Facebook');

        Get.snackbar('Success', 'Logged in with Facebook');
        Get.offAllNamed(Routes.home);
      } else if (result.status == LoginStatus.cancelled) {
        Get.snackbar('Info', 'Facebook login cancelled');
      } else {
        Get.snackbar('Error', result.message ?? 'Facebook login failed');
      }

      debugPrint(result.message);
    } catch (e) {
      Get.snackbar('Error', e.toString());
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn.instance.signOut();
    await FacebookAuth.instance.logOut();

    Get.offAllNamed(Routes.login);
  }

  // ================= CURRENT USER =================
  User? get currentUser => _auth.currentUser;
}
