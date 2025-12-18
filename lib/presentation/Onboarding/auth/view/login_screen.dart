import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softvence_task/utils/static_components.dart';
import '../controller/loginController.dart';
import 'widgets/_socialButton.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find();

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// ---------------- HEADER ----------------
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your next opportunity is just a tap away.',
                style: TextStyle(fontSize: 14, color: AppColors.secondaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              /// ---------------- EMAIL ----------------
              CustomTextField(
                controller: emailController,
                hintText: 'Email',
                prefixIcon: CupertinoIcons.mail,
              ),
              const SizedBox(height: 16),

              /// ---------------- PASSWORD ----------------
              CustomTextField(
                controller: passwordController,
                hintText: 'Password',
                prefixIcon: CupertinoIcons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 10),

              /// ---------------- REMEMBER + FORGOT ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Row(
                      children: [
                        Checkbox(
                          value: controller.isChecked.value,
                          onChanged: (v) =>
                              controller.isChecked.value = v ?? false,
                          activeColor: AppColors.primaryColor,
                        ),
                        const Text(
                          'Remember me',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed('/forgot-password'),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              /// ---------------- LOGIN BUTTON ----------------
              Obx(
                () => SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            controller.loginWithEmail(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              /// ---------------- OR ----------------
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('or'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// ---------------- SOCIAL LOGIN ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  socialButton(
                    icon: 'assets/icon/google_icon.png',
                    onTap: controller.loginWithGoogle,
                  ),
                  const SizedBox(width: 16),
                  socialButton(
                    icon: 'assets/icon/facebook_icon.png',
                    onTap: controller.loginWithFacebook,
                  ),
                ],
              ),
              const SizedBox(height: 40),

              /// ---------------- SIGNUP ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have an account? "),
                  GestureDetector(
                    onTap: () => Get.toNamed('/signup'),
                    child: Text(
                      'Signup',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
