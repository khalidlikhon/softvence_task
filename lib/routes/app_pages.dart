import 'package:get/get.dart';

import '../presentation/Home/home_screen.dart';
import '../presentation/Onboarding/auth/controller/loginController.dart';
import '../presentation/Onboarding/auth/view/login_screen.dart';
import '../presentation/Onboarding/auth/view/singup_screen.dart';
import '../presentation/Onboarding/splash/controller/splashController.dart';
import '../presentation/Onboarding/splash/splash_screen.dart';
import '../presentation/notification/notification_screen.dart';
import '../presentation/profile/profile_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    // Splash
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),

    // Login
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    ),

    // Signup
    GetPage(
      name: Routes.signup, // <-- Add this route in app_routes.dart too
      page: () => SignupView(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    ),

    // Home
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
    ),

    // Notification Detail
    GetPage(
      name: Routes.notificationDetail,
      page: () => const NotificationScreen(),
    ),

    // Profile
    GetPage(
      name: Routes.profile,
      page: () => const ProfileScreen(),
    ),
  ];
}
