import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';

class RateRestaurantBottomSheet extends StatefulWidget {
  final String restaurantName;

  const RateRestaurantBottomSheet({super.key, required this.restaurantName});

  @override
  State<RateRestaurantBottomSheet> createState() => _RateRestaurantBottomSheetState();
}

class _RateRestaurantBottomSheetState extends State<RateRestaurantBottomSheet> {
  int _rating = 4; // default
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(color: AppColors.cE0E5EC, borderRadius: BorderRadius.circular(2)),
          ),
          24.g,
          const CustomText(
            text: "Rate this restaurant",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.black),
          ),
          16.g,
          // Restaurant Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: AppColors.cF6F6F6, borderRadius: BorderRadius.circular(24)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.circle, color: AppColors.cF9A405, size: 16),
                8.g,
                CustomText(
                  text: widget.restaurantName,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.black),
                ),
                8.g,
                const Icon(Icons.circle, color: Colors.green, size: 8), // open indicator
              ],
            ),
          ),
          32.g,
          // Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return CustomIconButton(
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
                icon: Icon(index < _rating ? Icons.star : Icons.star_border, color: AppColors.cF9A405, size: 40),
              );
            }),
          ),
          8.g,
          CustomText(
            text: _rating == 5
                ? "Excellent"
                : _rating == 4
                ? "Great"
                : _rating == 3
                ? "Good"
                : "Poor",
            style: const TextStyle(color: AppColors.cF9A405, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          24.g,
          // TextField
          CustomTextField(controller: _reviewController, maxLines: 4, hintText: "Share your experience (optional)"),
          32.g,
          PrimaryButton(
            text: "Submit Review",
            onPressed: () {
              Navigator.pop(context); // close bottom sheet
            },
          ),
        ],
      ),
    );
  }
}
