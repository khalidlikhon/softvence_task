import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/data/userModel.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/notification_snackbar.dart';

class HomeController extends GetxController {
  // ---------------- LOADING & TAB STATE ----------------
  RxBool isLoading = true.obs;
  RxInt currentIndex = 0.obs;

  // ---------------- USER ----------------
  Rx<AppUser?> currentUser = Rx<AppUser?>(null);

  // ---------------- DROPDOWN OPTIONS ----------------
  final RxList<String> locations = <String>[
    "Dhaka",
    "Chittagong",
    "Khulna",
    "Rajshahi",
    "Barishal",
    "Sylhet",
    "Rangpur",
    "Mymensingh",
  ].obs;

  final RxList<String> services = <String>[
    "Repair",
    "Maintenance",
    "Cleaning",
    "Oil Change",
    "Tire Service",
    "Battery Service",
    "Car Wash",
    "Painting",
  ].obs;

  final RxList<Map<String, String>> brands = <Map<String, String>>[
    {
      "url":
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUtnIE0v4olIQoEkN-u_uAO_u5q7B6M7dNyg&s", // Subaru logo
      "name": "Subaru",
    },
    {
      "url":
      "https://wieck-nissanao-production.s3.amazonaws.com/photos/9c4cf69b27a0cbc0a0af905c8bdf8e24797254ef/thumbnail-364x204.jpg", // Nissan logo
      "name": "Nissan",
    },
    {
      "url":
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfGPY6yDfsS30DIM9zRwD9EMwVfcD8drd6Rw&s", // Chery logo
      "name": "Chery",
    },
    {
      "url":
      "https://e7.pngegg.com/pngimages/121/586/png-clipart-suzuki-jimny-car-logo-suzuki-cdr-angle-thumbnail.png", // Suzuki logo
      "name": "Suzuki",
    },
    {
      "url":
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmAd01mufI_vHiPQ7T0zESsTDGiwLW8QzAmg&s", // Toyota logo
      "name": "Toyota",
    },
    {
      "url":
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRijHSRfafTdeZhMq7UT5f3GZRmBXKmtoK3lg&s", // Hyundai logo
      "name": "Hyundai",
    },
    {
      "url":
      "https://www.stickpng.com/assets/images/580b57fcd9996e24bc43c0b0.png", // Honda logo
      "name": "Honda",
    },
  ].obs;

  // ---------------- FIREBASE ----------------
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;


  @override
  void onInit() {
    super.onInit();
    fetchCurrentUser();

    NotificationSnackbarService().updateCurrentScreen(Routes.home);
    NotificationSnackbarService().start();
  }




  // ---------------- CHANGE TAB ----------------
  void changeTab(int index) {
    currentIndex.value = index;
  }

  // ---------------- FETCH CURRENT USER ----------------
  Future<void> fetchCurrentUser() async {
    try {
      isLoading.value = true;
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        currentUser.value = AppUser.fromMap(doc.data()!);
      }
    } catch (e) {
      print("Error fetching user: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
