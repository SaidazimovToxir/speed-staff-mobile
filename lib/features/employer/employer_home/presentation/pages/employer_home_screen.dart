import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/bloc/employer_home_bloc.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/bloc/employer_home_state.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_bloc.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_state.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/widgets/employer_home_header.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/widgets/dashboard_stats_grid.dart';

class EmployerHomeScreen extends StatelessWidget {
  const EmployerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cF6F6F6,
      body: BlocListener<EmployerProfileBloc, EmployerProfileState>(
        listener: (context, profileState) {
          if (profileState.status == ProfileStatus.notFound) {
            context.push(RouteNames.editRestaurantProfile);
          }
        },
        child: SafeArea(
          child: BlocBuilder<EmployerHomeBloc, EmployerHomeState>(
            builder: (context, state) {
              switch (state.status) {
                case DashboardStatus.loading:
                  return const Center(child: CircularProgressIndicator(color: AppColors.c1F3C88));
                case DashboardStatus.success:
                  if (state.stats == null) return const SizedBox();
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const EmployerHomeHeader(),
                        24.g,
                        DashboardStatsGrid(stats: state.stats!),
                        24.g,
                        // const RecentApplicationsList(applications: []),
                      ],
                    ),
                  );
                case DashboardStatus.failure:
                  return Center(
                    child: CustomText(text: "Error: ${state.errorMessage}", color: AppColors.cFF0000),
                  );
                default:
                  return const Center(child: CustomText(text: "Initializing..."));
              }
            },
          ),
        ),
      ),
    );
  }
}
