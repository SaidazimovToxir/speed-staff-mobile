import 'package:flutter/material.dart';
import '../../../../config/core/constants/app_colors.dart';
import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';
import '../../domain/models/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine icon and color based on type
    IconData iconData;
    Color iconColor;
    Color bgColor;

    switch (notification.type) {
      case 'viewed':
        iconData = Icons.remove_red_eye;
        iconColor = Colors.blue;
        bgColor = Colors.blue.withOpacity(0.1);
        break;
      case 'vacancy':
        iconData = Icons.work_outline;
        iconColor = AppColors.cF9A405;
        bgColor = AppColors.cF9A405.withOpacity(0.1);
        break;
      case 'shortlisted':
        iconData = Icons.star_border;
        iconColor = AppColors.cF9A405;
        bgColor = AppColors.cF9A405.withOpacity(0.1);
        break;
      default:
        iconData = Icons.notifications_none;
        iconColor = AppColors.c61677D;
        bgColor = AppColors.cF6F6F6;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: notification.isUnread ? AppColors.cF9A405.withOpacity(0.02) : AppColors.white,
          border: Border(
            bottom: BorderSide(color: AppColors.cE0E5EC.withOpacity(0.5)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: iconColor, size: 20),
            ),
            16.g,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: notification.isUnread ? FontWeight.bold : FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      if (notification.isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  4.g,
                  Text(
                    notification.description,
                    style: TextStyle(
                      color: notification.isUnread ? AppColors.black.withOpacity(0.8) : AppColors.c61677D,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  8.g,
                  Text(
                    notification.timeAgo,
                    style: const TextStyle(
                      color: AppColors.c61677D,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
