import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/bloc/employer_home_bloc.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/bloc/employer_home_state.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/widgets/employer_home_header.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/widgets/dashboard_stats_grid.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/widgets/recent_applications_list.dart';

class EmployerHomeScreen extends StatelessWidget {
  const EmployerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cF6F6F6,
      body: SafeArea(
        child: BlocBuilder<EmployerHomeBloc, EmployerHomeState>(
          builder: (context, state) {
            switch (state) {
              case EmployerHomeLoading():
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.c1F3C88),
                );
              case EmployerHomeLoaded(
                stats: final stats,
                recentApplications: final apps,
              ):
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const EmployerHomeHeader(),
                      24.g,
                      DashboardStatsGrid(stats: stats),
                      24.g,
                      RecentApplicationsList(applications: apps),
                    ],
                  ),
                );
              case EmployerHomeError(message: final msg):
                return Center(
                  child: CustomText(
                    text: "Error: $msg",
                    color: AppColors.cFF0000,
                  ),
                );
              default:
                return const Center(child: CustomText(text: "Initializing..."));
            }
          },
        ),
      ),
    );
  }
}
