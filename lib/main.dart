import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:softvence_task/routes/app_pages.dart';
import 'package:softvence_task/routes/app_routes.dart';
import 'package:softvence_task/utils/notification_snackbar.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splash,
      getPages: AppPages.pages,

      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF6F7F9),
      ),
    );
  }
}
