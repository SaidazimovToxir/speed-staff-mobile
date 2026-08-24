import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';

/// Seeker document ma'lumotlari (local struktura)
class DocumentData {
  final String name;
  final String info;

  const DocumentData({required this.name, required this.info});
}

class DocumentItem extends StatelessWidget {
  final DocumentData document;
  const DocumentItem({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cE0E5EC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, color: AppColors.cCD3959, size: 30),
          12.g,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: document.name,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                3.g,
                CustomText(
                  text: document.info,
                  fontSize: 12,
                  color: AppColors.c61677D,
                ),
              ],
            ),
          ),
          const Icon(Icons.download_rounded, color: AppColors.c74809C),
        ],
      ),
    );
  }
}
