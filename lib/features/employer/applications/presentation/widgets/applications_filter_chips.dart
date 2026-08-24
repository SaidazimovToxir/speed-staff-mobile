import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';

class ApplicationsFilterChips extends StatelessWidget {
  const ApplicationsFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = ["All", "Shortlisted", "Interviewing", "New"];
    return Container(
      height: 60,
      color: AppColors.white,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => 12.g,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == "All";
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.c1F3C88 : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: CustomText(
                text: filter,
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}
