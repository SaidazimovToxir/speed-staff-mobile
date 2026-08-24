import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/presentation/bloc/vacancy_feed_bloc.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/presentation/bloc/vacancy_feed_event.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/presentation/bloc/vacancy_feed_state.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/domain/entities/vacancy.dart';
import 'package:speed_staff_mobile/features/shared/tab_box/bloc/tab_box/tab_box_bloc.dart';

class SavedVacanciesScreen extends StatefulWidget {
  const SavedVacanciesScreen({super.key});

  @override
  State<SavedVacanciesScreen> createState() => _SavedVacanciesScreenState();
}

class _SavedVacanciesScreenState extends State<SavedVacanciesScreen> {
  late final VacancyFeedBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<VacancyFeedBloc>()..add(const LoadSavedVacancies());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<TabBoxBloc, TabBoxState>(
        listener: (context, state) {
          if (state.selectedIndex == 2) {
            _bloc.add(const LoadSavedVacancies());
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [CustomText(text: 'Saved Vacancies', fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.black)],
            ),
          ),
          body: BlocBuilder<VacancyFeedBloc, VacancyFeedState>(
            builder: (context, state) {
              if (state.status == VacancyFeedStatus.loading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.cF9A405));
              }
              if (state.status == VacancyFeedStatus.failure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey.shade300),
                      16.g,
                      CustomText(text: state.errorMessage ?? 'Failed to load saved vacancies', color: Colors.grey),
                      20.g,
                      TextButton(
                        onPressed: () => _bloc.add(const LoadSavedVacancies()),
                        child: const Text('Retry', style: TextStyle(color: AppColors.cF9A405)),
                      ),
                    ],
                  ),
                );
              }
              if (state.vacancies.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_border_rounded, size: 80, color: Colors.grey.shade300),
                      20.g,
                      const CustomText(text: 'No saved vacancies yet', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey),
                      8.g,
                      CustomText(text: 'Save jobs you like to revisit them later', color: Colors.grey.shade500),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: state.vacancies.length,
                itemBuilder: (ctx, i) => _SavedVacancyCard(
                  vacancy: state.vacancies[i],
                  onUnsave: () => _bloc.add(RemoveSavedVacancy(state.vacancies[i].id)),
                  onApply: () => context.push(RouteNames.applyVacancy, extra: state.vacancies[i]),
                  onTap: () => context.push(RouteNames.vacancyDetail, extra: state.vacancies[i]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SavedVacancyCard extends StatelessWidget {
  final Vacancy vacancy;
  final VoidCallback onUnsave;
  final VoidCallback onApply;
  final VoidCallback onTap;

  const _SavedVacancyCard({required this.vacancy, required this.onUnsave, required this.onApply, required this.onTap});

  String _salaryText() {
    final fmt = NumberFormat('#,##0', 'en_US');
    if (vacancy.salaryMin != null && vacancy.salaryMax != null) {
      return '\$${fmt.format(vacancy.salaryMin)} - \$${fmt.format(vacancy.salaryMax)} / hr';
    }
    return 'Negotiable';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant banner image
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    color: Colors.grey.shade200,
                    image: vacancy.employer?.logoUrl != null ? DecorationImage(image: NetworkImage(vacancy.employer!.logoUrl!), fit: BoxFit.cover) : null,
                  ),
                  child: vacancy.employer?.logoUrl == null
                      ? Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF8B6914), Color(0xFFF9A405)]),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                        )
                      : null,
                ),
                // Salary badge
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.92), borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      _salaryText(),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.cF9A405),
                    ),
                  ),
                ),
                // Heart saved button
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onUnsave,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(color: AppColors.cF9A405, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: vacancy.title, fontSize: 16, fontWeight: FontWeight.w800),
                  6.g,
                  Row(
                    children: [
                      Icon(Icons.restaurant_outlined, size: 14, color: Colors.grey.shade500),
                      6.g,
                      CustomText(text: vacancy.employer?.restaurantName ?? '', fontSize: 12, color: Colors.grey.shade500),
                    ],
                  ),
                  12.g,
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(text: 'Apply Now', onPressed: onApply),
                      ),
                      12.g,
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.share_outlined, color: Colors.grey),
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
