import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/config/core/constants/app_colors.dart';
import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';
import 'package:speed_staff_mobile/config/core/widgets/primary_button.dart';
import '../bloc/restaurant_detail_bloc.dart';
import '../widgets/review_card.dart';
import '../widgets/rate_bottom_sheet.dart';
import '../widgets/report_bottom_sheet.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RestaurantDetailBloc>().add(LoadRestaurantDetail(widget.restaurantId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
         elevation: 0,
        backgroundColor: AppColors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Restaurant Detail",
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.black),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const ReportContentBottomSheet(),
              );
            },
          )
        ],
      ),
      body: BlocBuilder<RestaurantDetailBloc, RestaurantDetailState>(
        builder: (context, state) {
          if (state is RestaurantDetailLoading || state is RestaurantDetailInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.cF9A405));
          } else if (state is RestaurantDetailError) {
            return Center(child: Text(state.message));
          } else if (state is RestaurantDetailLoaded) {
            final rest = state.restaurant;
            return SafeArea(
              child: Stack(
                children: [
                   SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        24.g,
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.cF6F6F6,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: Text("THE\nGOLDEN\nGRILL", textAlign: TextAlign.center, style: TextStyle(color: AppColors.cF9A405, fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                              ),
                              16.g,
                              Text(rest.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.black)),
                              8.g,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.location_on_outlined, color: AppColors.c61677D, size: 16),
                                  4.g,
                                  Text(rest.location, style: const TextStyle(color: AppColors.c61677D, fontSize: 14)),
                                ],
                              ),
                              12.g,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.star, color: AppColors.cF9A405, size: 16),
                                      Icon(Icons.star, color: AppColors.cF9A405, size: 16),
                                      Icon(Icons.star, color: AppColors.cF9A405, size: 16),
                                      Icon(Icons.star, color: AppColors.cF9A405, size: 16),
                                      Icon(Icons.star_half, color: AppColors.cF9A405, size: 16),
                                    ],
                                  ),
                                  8.g,
                                  Text("${rest.rating} (${rest.reviewCount} reviews)", style: const TextStyle(color: AppColors.c61677D, fontSize: 14, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        32.g,
                        const Text("About", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black)),
                        12.g,
                        Text(rest.description ?? "No description available", style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.c61677D)),
                        32.g,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Recent Reviews", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black)),
                            TextButton(
                              onPressed: () {},
                              child: const Text("View All", style: TextStyle(color: AppColors.cF9A405, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        16.g,
                        ...state.reviews.map((r) => ReviewCard(review: r)).toList(),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
                      ),
                      child: PrimaryButton(
                        text: "Leave a Review",
                        icon: const Icon(Icons.rate_review_outlined, color: AppColors.white),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => RateRestaurantBottomSheet(restaurantName: rest.name),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
