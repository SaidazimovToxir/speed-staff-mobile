import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final String actionText;
  final Color? actionColor;
  final IconData iconData;
  final Color iconColor;
  final Color iconBgColor;
  final Color? valueColor;
  final VoidCallback? onActionTap;

  final bool isDashed;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.actionText,
    this.actionColor,
    required this.iconData,
    required this.iconColor,
    required this.iconBgColor,
    this.valueColor,
    this.onActionTap,
    this.isDashed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDashed ? Colors.blue.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: label,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
                10.g,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    CustomText(
                      text: value,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: valueColor ?? Colors.black,
                    ),
                    8.g,
                    CustomText(
                      text: subtitle,
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ],
                ),
                14.g,
                GestureDetector(
                  onTap: onActionTap,
                  child: CustomText(
                    text: actionText,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: actionColor ?? AppColors.cF9A405,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, color: iconColor, size: 24),
          ),
        ],
      ),
    );
  }
}
