import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/config/router/route_names.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_bloc.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_state.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/widgets/employer_profile_header.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/entities/vacancy_entity.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/widgets/vacancy_item_card.dart';

class EmployerProfileScreen extends StatelessWidget {
  const EmployerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<EmployerProfileBloc, EmployerProfileState>(
        builder: (context, state) {
          switch (state) {
            case EmployerProfileLoading():
              return const Center(
                child: CircularProgressIndicator(color: AppColors.c1F3C88),
              );
            case EmployerProfileLoaded(profileData: final data):
              return SingleChildScrollView(
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
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0, 6))
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStat("4.8", "Rating"),
                                _buildVerticalDivider(),
                                _buildStat("12", "Active Jobs"),
                                _buildVerticalDivider(),
                                _buildStat("850", "Total Hired"),
                              ],
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
                    _buildSection(
                      title: "About",
                      child: CustomText(
                        text: data['about'] ?? "The Golden Grill is a premier destination for world-class culinary experiences, using quality ingredients and traditional cooking techniques.",
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    8.g,
                    _buildSection(
                      title: "Active Vacancies",
                      trailing: const CustomText(text: "View all", fontSize: 13, color: AppColors.cF9A405, fontWeight: FontWeight.bold),
                      child: VacancyItemCard(
                        vacancy: VacancyEntity(
                          id: '1', role: 'Senior Barista', company: 'The Golden Grill',
                          location: 'Tashkent, UZ', status: 'Active', appliedCount: '24', newCount: '5',
                        ),
                      ),
                    ),
                    8.g,
                    _buildSection(
                      title: "Recent Reviews",
                      trailing: const CustomText(text: "View all", fontSize: 13, color: AppColors.cF9A405, fontWeight: FontWeight.bold),
                      child: Column(
                        children: [
                          _buildReview("Jane Blu", "Amazing team environment and great tips management. Really appreciate the spirit during peak hours.", 5),
                          const Divider(height: 24),
                          _buildReview("Larah White", "High quality espresso to work with. Management is very organized, very much makes our job easier.", 5),
                          const Divider(height: 24),
                          _buildReview("Marcus King", "Fast paced but rewarding. Love the energy. Work life availability right.", 4),
                        ],
                      ),
                    ),
                    16.g,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.c1F3C88,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.campaign_outlined, color: Colors.white),
                          label: const CustomText(text: "Announcement", color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    24.g,
                  ],
                ),
              );
            case EmployerProfileError(message: final msg):
              return Center(child: CustomText(text: "Error: $msg", color: Colors.red));
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
              if (trailing != null) trailing,
            ],
          ),
          16.g,
          child,
        ],
      ),
    );
  }

  Widget _buildReview(String name, String text, int stars) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.c1F3C88.withValues(alpha: 0.1),
                  child: CustomText(text: name[0], fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.c1F3C88),
                ),
                8.g,
                CustomText(text: name, fontSize: 14, fontWeight: FontWeight.w600),
              ],
            ),
            Row(
              children: List.generate(5, (i) => Icon(
                i < stars ? Icons.star : Icons.star_border,
                color: AppColors.cF9A405,
                size: 14,
              )),
            ),
          ],
        ),
        8.g,
        CustomText(text: text, fontSize: 13, color: Colors.grey.shade600),
      ],
    );
  }
}
