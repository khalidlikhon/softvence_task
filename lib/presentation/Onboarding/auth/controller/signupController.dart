import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import '../../../../core/data/userModel.dart'; // AppUser model

class SignupController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  RxBool isLoading = false.obs;
  Rx<File?> profileImage = Rx<File?>(null);

  /// Signup with email/password
  Future<void> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    File? profileImageFile,
  }) async {
    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    try {
      isLoading.value = true;

      // 1️⃣ Create Firebase Auth user
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCredential.user!.uid;

      // 2️⃣ Upload profile image if exists
      String? profileImageUrl;
      final File? imageToUpload = profileImageFile ?? profileImage.value;
      if (imageToUpload != null) {
        final ref = _storage.ref().child('profile_images/$uid.jpg');
        await ref.putFile(imageToUpload);
        profileImageUrl = await ref.getDownloadURL();
      }

      // 3️⃣ Create AppUser model
      AppUser user = AppUser(
        uid: uid,
        name: name,
        email: email,
        phone: phone,
        photoUrl: profileImageUrl, notificationEnabled: true,
      );

      // 4️⃣ Store user data in Firestore
      await _firestore.collection('users').doc(uid).set(user.toMap());

      Get.snackbar('Success', 'Signup successful');

      Get.offAllNamed('/login');

    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Signup failed');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
