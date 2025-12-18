import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/splashController.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            // Center Logo
            Center(
              child: Image.asset(
                'assets/images/sayaraHub_logo.jpg',
                width: 320,
                fit: BoxFit.contain,
              ),
            ),
            
            const Spacer(),

            // Bottom Loader
            const Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
