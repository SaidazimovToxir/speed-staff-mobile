import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/core/constants/app_colors.dart';
import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';
import 'package:speed_staff_mobile/features/user/user_home/domain/models/restaurant_model.dart';
import 'package:speed_staff_mobile/config/widgets/custom_text.dart';


class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cF6F6F6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.cE0E5EC,
                child: CustomText(text: review.authorName.substring(0, 1),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.c61677D),
                ),
              ),
              12.g,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: review.authorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.black,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review.rating ? Icons.star : Icons.star_border,
                          size: 14,
                          color: AppColors.cF9A405,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              CustomText(text: review.timeAgo,
                style: const TextStyle(color: AppColors.c61677D, fontSize: 12),
              ),
            ],
          ),
          12.g,
          CustomText(text: review.text,
            style: const TextStyle(
              color: AppColors.c61677D,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
