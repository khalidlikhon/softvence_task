import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../utils/static_components.dart';
import 'controller/notificationController.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF6F7F9),
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const Center(child: Text('No notifications yet'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final item = controller.notifications[index];

            return Dismissible(
              key: ValueKey(item.id),
              direction: DismissDirection.endToStart,
              background: Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 18.0),
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(CupertinoIcons.delete, color: Colors.white),
                ),
              ),
              confirmDismiss: (_) async {
                return await _showDeleteConfirmation(context, controller, item);
              },
              child: GestureDetector(
                onTap: () => controller.onNotificationTap(item),
                child: Stack(
                  children: [
                    _NotificationCard(item: item),

                    /// 🔴 Unread red dot
                    if (!item.isRead)
                      const Positioned(
                        top: 10,
                        right: 10,
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  /// ===================== DELETE CONFIRMATION DIALOG =====================
  Future<bool> _showDeleteConfirmation(
      BuildContext context,
      NotificationController controller,
      dynamic item) async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Notification'),
        content: const Text(
          'Are you sure you want to delete this notification?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await controller.deleteNotification(item);
              Get.back(result: true);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }
}

class _NotificationCard extends StatelessWidget {
  final dynamic item;

  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: item.isRead ? Colors.grey.shade200 : Colors.blue.shade100,
        ),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _getNotificationIcon(item.type), // Type-based icon
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.body,
            style: const TextStyle(fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            item.timeAgo,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// ================= TYPE-BASED ICON =================
  Widget _getNotificationIcon(String type) {
    switch (type) {
      case 'feature_alert':
        return Image.asset(
          'assets/notificationIcons/feature_alert.png', // <-- no leading slash
          width: 32,
          height: 32,
          fit: BoxFit.contain,
        );
      case 'reminder':
        return Image.asset(
          'assets/notificationIcons/remider.png',
          width: 32,
          height: 32,
          fit: BoxFit.contain,
        );
      case 'schedule':
        return Image.asset(
          'assets/notificationIcons/calendar.png',
          width: 32,
          height: 32,
          fit: BoxFit.contain,
        );
      default:
        return const Icon(
          CupertinoIcons.bell,
          color: AppColors.primaryColor,
          size: 28,
        );
    }
  }
}
