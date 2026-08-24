import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_bloc.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_event.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_state.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/widgets/employer_profile_header.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/bloc/vacancies_bloc.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/bloc/vacancies_event.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/bloc/vacancies_state.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/widgets/vacancy_item_card.dart';

class EmployerProfileScreen extends StatefulWidget {
  const EmployerProfileScreen({super.key});

  @override
  State<EmployerProfileScreen> createState() => _EmployerProfileScreenState();
}

class _EmployerProfileScreenState extends State<EmployerProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VacanciesBloc>().add(const LoadMyVacancies(page: 1, limit: 10));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<EmployerProfileBloc, EmployerProfileState>(
        builder: (context, state) {
          switch (state.status) {
            case ProfileStatus.loading:
              return const Center(child: CircularProgressIndicator(color: AppColors.c1F3C88));
            case ProfileStatus.success:
              final data = state.profile;
              if (data == null) return const SizedBox();
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<EmployerProfileBloc>().add(LoadEmployerProfile());
                  context.read<VacanciesBloc>().add(const LoadMyVacancies(page: 1, limit: 10));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      EmployerProfileHeader(data: data),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            24.g,
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade100),
                                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0, 6))],
                              ),
                              child: BlocBuilder<VacanciesBloc, VacanciesState>(
                                builder: (context, vState) {
                                  final activeJobs = vState.vacancies.where((v) => v.status?.toLowerCase() == 'active').length;
                                  final totalHired = data.totalReviews ?? 0;

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildStat((data.rating ?? 0.0).toStringAsFixed(1), "Rating"),
                                      _buildVerticalDivider(),
                                      _buildStat(activeJobs.toString(), "Active Jobs"),
                                      _buildVerticalDivider(),
                                      _buildStat(totalHired.toString(), "Reviews"),
                                    ],
                                  );
                                },
                              ),
                            ),
                            24.g,
                            SizedBox(
                              width: double.infinity,
                              child: PrimaryButton(
                                text: "Edit Profile",
                                onPressed: () {
                                  context.push(RouteNames.editRestaurantProfile);
                                },
                              ),
                            ),
                            32.g,
                          ],
                        ),
                      ),
                      if (data.description != null && data.description!.isNotEmpty) ...[
                        _buildSection(
                          title: "About",
                          child: CustomText(text: data.description!, fontSize: 14, color: Colors.grey.shade600),
                        ),
                        8.g,
                      ],
                      BlocBuilder<VacanciesBloc, VacanciesState>(
                        builder: (context, vState) {
                          final activeVacancies = vState.vacancies.where((v) => v.status?.toLowerCase() == 'active').take(3).toList();
                          if (activeVacancies.isEmpty) return const SizedBox();

                          return Column(
                            children: [
                              _buildSection(
                                title: "Active Vacancies",
                                trailing: GestureDetector(
                                  onTap: () => context.push(RouteNames.myVacancies),
                                  child: const CustomText(text: "View all", fontSize: 13, color: AppColors.cF9A405, fontWeight: FontWeight.bold),
                                ),
                                child: Column(
                                  children: activeVacancies
                                      .map(
                                        (v) => Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: VacancyItemCard(vacancy: v),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              8.g,
                            ],
                          );
                        },
                      ),
                      // 16.g,
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      //   child: SizedBox(
                      //     width: double.infinity,
                      //     child: ElevatedButton.icon(
                      //       onPressed: () {},
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: AppColors.c1F3C88,
                      //         elevation: 0,
                      //         padding: const EdgeInsets.symmetric(vertical: 14),
                      //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      //       ),
                      //       icon: const Icon(Icons.campaign_outlined, color: Colors.white),
                      //       label: const CustomText(text: "Announcement", color: Colors.white, fontWeight: FontWeight.bold),
                      //     ),
                      //   ),
                      // ),
                      24.g,
                    ],
                  ),
                ),
              );
            case ProfileStatus.failure:
              return Center(
                child: CustomText(text: "Error: ${state.errorMessage}", color: Colors.red),
              );
            default:
              return const Center(child: CustomText(text: "Loading profile..."));
          }
        },
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        CustomText(text: value, fontSize: 22, fontWeight: FontWeight.bold),
        4.g,
        CustomText(text: label, fontSize: 12, color: Colors.grey.shade600),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 36, width: 1, color: Colors.grey.shade200);
  }

  Widget _buildSection({required String title, Widget? trailing, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: title, fontSize: 16, fontWeight: FontWeight.bold),
              ?trailing,
            ],
          ),
          16.g,
          child,
        ],
      ),
    );
  }
}
