import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softvence_task/utils/static_components.dart';
import 'controller/splashController.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 50), // top spacing
            // App Logo
            Center(
              child: Image.asset(
                'assets/images/sayaraHub_logo.jpg',
                width: 320,
                fit: BoxFit.contain,
              ),
            ),


            //  Progress Indicator at the bottom
            Padding(
              padding: const EdgeInsets.all(24),
              child: Obx(
                    () {
                  // Small centered progress indicator
                  if (controller.isChecking.value) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: SizedBox(
                          width: 120, // width of text+icon
                          height: 6,   // thin line
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              color: AppColors.primaryColor,
                              backgroundColor: Colors.grey[200],
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  // "Let's Go" button
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: GestureDetector(
                      onTap: controller.onLetsGoLongPress,
                      onLongPress: controller.onLetsGoLongPress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Let's go",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
