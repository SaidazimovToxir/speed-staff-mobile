import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/user/user_home/presentation/bloc/home_bloc.dart';
import 'package:speed_staff_mobile/features/user/user_home/presentation/widgets/category_chip.dart';
import 'package:speed_staff_mobile/features/user/user_home/presentation/widgets/restaurant_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        title: Row(
          children: [
            const Icon(Icons.restaurant_menu, color: AppColors.cF9A405),
            8.g,
            CustomText(text: "Speed Staff", color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ],
        ),
        actions: [
          CustomIconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.black),
            onPressed: () {
              context.push(RouteNames.notifications);
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.cF9A405));
          } else if (state is HomeError) {
            return Center(child: CustomText(text: state.message));
          } else if (state is HomeLoaded) {
            final filteredRestaurants = state.selectedCategoryId == '1'
                ? state.restaurants
                : state.restaurants.where((r) => r.categoryIds.contains(state.selectedCategoryId)).toList();

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.g,
                    // Search bar
                    const CustomTextField(
                      hintText: "Search for restaurants or cuisines...",
                      prefixIcon: Icon(Icons.search, color: AppColors.c61677D),
                      suffixIcon: Icon(Icons.tune, color: AppColors.cF9A405),
                    ),
                    24.g,

                    // Categories
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: state.categories.map((category) {
                          return CategoryChip(
                            label: category.name,
                            isSelected: state.selectedCategoryId == category.id,
                            onTap: () {
                              context.read<HomeBloc>().add(SelectCategory(category.id));
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    24.g,

                    // List
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredRestaurants.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return RestaurantCard(restaurant: filteredRestaurants[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
