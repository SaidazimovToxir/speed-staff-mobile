import 'package:flutter/material.dart';
import '../../../../config/core/constants/app_colors.dart';
import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';
import '../../../../config/core/widgets/primary_button.dart';

class ReportContentBottomSheet extends StatefulWidget {
  const ReportContentBottomSheet({super.key});

  @override
  State<ReportContentBottomSheet> createState() => _ReportContentBottomSheetState();
}

class _ReportContentBottomSheetState extends State<ReportContentBottomSheet> {
  String? _selectedReason = 'Fake or misleading information';

  final List<String> _reasons = [
    'Fake or misleading information',
    'Spam or scam',
    'Inappropriate content',
    'Already filled / vacancy closed',
    'Other',
  ];

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
              decoration: BoxDecoration(
                color: AppColors.cE0E5EC,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          24.g,
          const Text(
            "Report this content",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          4.g,
          const Text(
            "Help us keep Speed Staff safe",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.c61677D,
            ),
          ),
          24.g,
          ..._reasons.map((reason) => _buildRadioOption(reason)).toList(),
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
              child: const Text(
                "Cancel",
                style: TextStyle(color: AppColors.c61677D, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String title) {
    final isSelected = _selectedReason == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReason = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.cE0E5EC.withOpacity(0.5))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: AppColors.black,
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.cF9A405 : AppColors.cE0E5EC,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.cF9A405,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
