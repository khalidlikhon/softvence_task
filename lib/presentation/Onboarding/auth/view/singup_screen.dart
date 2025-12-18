import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softvence_task/utils/static_components.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/signupController.dart';
import 'widgets/_socialButton.dart';

class SignupView extends StatelessWidget {
  SignupView({Key? key}) : super(key: key);

  // Controller
  final SignupController controller = Get.put(SignupController());

  // Image Picker
  final ImagePicker _picker = ImagePicker();

  // Text Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Pick Profile Image
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      controller.profileImage.value = File(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // Title
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Join us and start your journey today.',
                style: TextStyle(fontSize: 14, color: AppColors.secondaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),


              // Profile Picture
              Obx(
                    () => GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.secondaryColor.withOpacity(0.2),
                    backgroundImage: controller.profileImage.value != null
                        ? FileImage(controller.profileImage.value!)
                        : null,
                    child: controller.profileImage.value == null
                        ? Icon(
                      Icons.camera_alt_outlined,
                      size: 40,
                      color: AppColors.primaryColor,
                    )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 30),


              // Name Field
              CustomTextField(
                controller: nameController,
                hintText: 'Full Name',
                prefixIcon: CupertinoIcons.person,
              ),
              const SizedBox(height: 16),

              // Email Field
              CustomTextField(
                controller: emailController,
                hintText: 'Email',
                prefixIcon: CupertinoIcons.mail,
              ),
              const SizedBox(height: 16),

              // Phone Field
              CustomTextField(
                controller: phoneController,
                hintText: 'Phone Number',
                prefixIcon: CupertinoIcons.phone,
              ),
              const SizedBox(height: 16),

              // Password Field
              CustomTextField(
                controller: passwordController,
                hintText: 'Password',
                prefixIcon: CupertinoIcons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 30),

              // Signup Button
              Obx(
                () => SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.signup(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            phone: phoneController.text.trim(),
                            password: passwordController.text.trim(),
                            profileImageFile: controller.profileImage.value,
                          ),
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
                            ),
                          )
                        : const Text(
                            'Signup',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Login Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
