import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:softvence_task/utils/static_components.dart';
import '../../utils/_notificationLog.dart';
import 'controller/profileController.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Obx(
          () =>
          Scaffold(
            appBar: AppBar(
              title: const Text(
                'Profile',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: const Color(0xFFF6F7F9),
            ),
            body: SafeArea(
              child: controller.isLoading.value
                  ? const Center(child: CupertinoActivityIndicator())
                  : _ProfileContent(controller: controller),
            ),
          ),
    );
  }
}

/// ================= PROFILE CONTENT =================
class _ProfileContent extends StatelessWidget {
  final ProfileController controller;

  const _ProfileContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    final user = controller.user.value;

    if (user == null) {
      return const Center(child: Text('No user data found'));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: [
        /// ---------------- PROFILE HEADER ----------------
        Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: CupertinoColors.systemGrey4,
              backgroundImage:
              user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
              child: user.photoUrl == null
                  ? const Icon(CupertinoIcons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            _infoRow(user.email, user.phone),
          ],
        ),
        const SizedBox(height: 30),

        /// ---------------- SETTINGS ----------------
        const Text(
          'Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        /// Notifications
        _SettingsCard(
          icon: CupertinoIcons.bell,
          title: 'Notifications',
          subtitle: 'Enable Push Notification',
          trailing: Obx(
                () => CupertinoSwitch(
              value: controller.isNotificationOn.value,
              activeColor: AppColors.primaryColor,
              onChanged: controller.toggleNotification,
            ),
          ),
        ),

        const SizedBox(height: 12),

        /// Change Password
        _SettingsCard(
          icon: CupertinoIcons.lock,
          title: 'Change Password',
          subtitle: 'Update your login password for security',
          trailing: const Icon(
            CupertinoIcons.chevron_forward,
            size: 18,
            color: CupertinoColors.systemGrey,
          ),
          //onTap: controller.goToChangePassword,
        ),

        const SizedBox(height: 30),

        /// ---------------- SIGN OUT ----------------
        _SignOutButton(
          onTap: controller.logout,
        ),
      ],
    );
  }
}


/// ================= EMAIL + PHONE ROW =================
Widget _infoRow(String email, String phone) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            const Icon(
              CupertinoIcons.mail,
              size: 18,
              color: CupertinoColors.systemGrey,
            ),
            const SizedBox(width: 6),
            Text(
              email,
              style: const TextStyle(
                fontSize: 13,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
        if (phone.isNotEmpty) ...[
          const SizedBox(width: 16),
          Row(
            children: [
              const Icon(
                CupertinoIcons.phone,
                size: 18,
                color: CupertinoColors.systemGrey,
              ),
              const SizedBox(width: 6),
              Text(
                phone,
                style: const TextStyle(
                  fontSize: 13,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

/// ================= SETTINGS CARD =================
class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,

        /// 🔹 ICON CONTAINER
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.black87,
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(subtitle),
        trailing: trailing,
      ),
    );
  }
}

/// ================= SIGN OUT BUTTON =================
class _SignOutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SignOutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CupertinoColors.destructiveRed.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                CupertinoIcons.square_arrow_right,
                color: CupertinoColors.destructiveRed,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Sign Out',
              style: TextStyle(
                color: CupertinoColors.destructiveRed,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
