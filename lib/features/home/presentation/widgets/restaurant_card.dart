import 'package:flutter/material.dart';
import '../../../../config/core/constants/app_colors.dart';
import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';
import '../../domain/models/restaurant_model.dart';
import 'package:go_router/go_router.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/detail/${restaurant.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Area
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    color: AppColors.cF6F6F6,
                    child: Center(
                      child: Icon(Icons.restaurant, color: AppColors.cE0E5EC, size: 48),
                    ), // Placeholder for actual image
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      restaurant.isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: restaurant.isFavorite ? Colors.red : AppColors.black,
                    ),
                  ),
                ),
                if (restaurant.id == 'r1') // Mocking TOP RATED tag for specific item
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.cF9A405,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        "TOP RATED",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Details Area
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.cF9A405.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.cF9A405, size: 14),
                            4.g,
                            Text(
                              restaurant.rating.toString(),
                              style: const TextStyle(
                                color: AppColors.cF9A405,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  8.g,
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.c61677D, size: 16),
                      4.g,
                      Text(
                        restaurant.location,
                        style: const TextStyle(color: AppColors.c61677D, fontSize: 14),
                      ),
                    ],
                  ),
                  16.g,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: restaurant.isOpen ? Colors.green : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          8.g,
                          Text(
                            restaurant.isOpen ? "Open Now" : "Closes at 10:00 PM",
                            style: TextStyle(
                              color: restaurant.isOpen ? Colors.green : AppColors.c61677D,
                              fontSize: 12,
                              fontWeight: restaurant.isOpen ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          if (restaurant.id == 'r1') ...[
                            16.g,
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.cF6F6F6,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.attach_money, size: 12, color: AppColors.c61677D),
                                  2.g,
                                  Text("<50", style: const TextStyle(fontSize: 10, color: AppColors.c61677D)),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cF9A405,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Text(
                          "View Menu",
                          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
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
