import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:go_router/go_router.dart';

class MyVacanciesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyVacanciesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      title: const CustomText(
        text: "My Vacancies",
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: InkWell(
            onTap: () => context.push(RouteNames.createVacancy),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.cF9A405,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: AppColors.white, size: 24),
            ),
          ),
        ),
      ],
      bottom: TabBar(
        labelColor: AppColors.cF9A405,
        unselectedLabelColor: Colors.grey,
        indicatorColor: AppColors.cF9A405,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        tabs: const [
          Tab(text: "Active"),
          Tab(text: "Paused"),
          Tab(text: "Closed"),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
