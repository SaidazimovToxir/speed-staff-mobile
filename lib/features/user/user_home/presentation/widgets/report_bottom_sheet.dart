import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/features/user/user_home/presentation/widgets/report_option_item.dart';

import 'package:speed_staff_mobile/config/config.dart';

class ReportContentBottomSheet extends StatefulWidget {
  const ReportContentBottomSheet({super.key});

  @override
  State<ReportContentBottomSheet> createState() => _ReportContentBottomSheetState();
}

class _ReportContentBottomSheetState extends State<ReportContentBottomSheet> {
  String? _selectedReason = 'Fake or misleading information';

  final List<String> _reasons = ['Fake or misleading information', 'Spam or scam', 'Inappropriate content', 'Already filled / vacancy closed', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(color: AppColors.cE0E5EC, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          24.g,
          const CustomText(
            text: "Report this content",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.black),
          ),
          4.g,
          const CustomText(
            text: "Help us keep Speed Staff safe",
            style: TextStyle(fontSize: 14, color: AppColors.c61677D),
          ),
          24.g,
          ..._reasons.map(
            (reason) => ReportOptionItem(
              title: reason,
              isSelected: _selectedReason == reason,
              onTap: () {
                setState(() {
                  _selectedReason = reason;
                });
              },
            ),
          ),
          32.g,
          PrimaryButton(
            text: "Submit Report",
            icon: const Icon(Icons.info_outline, color: AppColors.white, size: 20),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          16.g,
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const CustomText(
                text: "Cancel",
                style: TextStyle(color: AppColors.c61677D, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
