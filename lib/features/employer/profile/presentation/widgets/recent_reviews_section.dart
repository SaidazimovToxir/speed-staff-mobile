import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/widgets/review_item.dart';

class RecentReviewsSection extends StatelessWidget {
  const RecentReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              text: "Recent Reviews",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            TextButton(
              onPressed: () {},
              child: const CustomText(
                text: "+12 ALL",
                fontSize: 14,
                color: AppColors.cF3B608,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        12.g,
        const ReviewItem(
          name: "John Doe",
          comment:
              "Amazing team environment and great tips. Management really supports the staff during peak hours.",
          rating: "4.8",
        ),
        12.g,
        const ReviewItem(
          name: "Sarah Miller",
          comment:
              "High-quality ingredients to work with, the kitchen is very well organized, which makes service smooth.",
          rating: "5.0",
        ),
      ],
    );
  }
}
