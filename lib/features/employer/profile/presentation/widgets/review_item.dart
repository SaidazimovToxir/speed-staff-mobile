import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';

class ReviewItem extends StatelessWidget {
  final String name;
  final String comment;
  final String rating;

  const ReviewItem({
    super.key,
    required this.name,
    required this.comment,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: name, fontSize: 14, fontWeight: FontWeight.bold),
              Row(
                children: [
                  const Icon(Icons.star, color: AppColors.cF3B608, size: 16),
                  4.g,
                  CustomText(
                    text: rating,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ],
          ),
          8.g,
          CustomText(text: comment, fontSize: 14, color: Colors.grey[700]),
        ],
      ),
    );
  }
}
