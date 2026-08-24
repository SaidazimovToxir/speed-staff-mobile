import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/domain/entities/vacancy.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/presentation/bloc/vacancy_feed_bloc.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/presentation/bloc/vacancy_feed_event.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/presentation/bloc/vacancy_feed_state.dart';

class SeekerHomeScreen extends StatefulWidget {
  const SeekerHomeScreen({super.key});

  @override
  State<SeekerHomeScreen> createState() => _SeekerHomeScreenState();
}

class _SeekerHomeScreenState extends State<SeekerHomeScreen> {
  late final VacancyFeedBloc _bloc;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Kitchen', 'Service', 'Management', 'F&B'];

  @override
  void initState() {
    super.initState();
    _bloc = sl<VacancyFeedBloc>()..add(const LoadVacancyFeed());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (_bloc.state.hasNext && _bloc.state.status == VacancyFeedStatus.success) {
        _bloc.add(const LoadMoreVacancies());
      }
    }
  }

  void _onCategoryTap(String cat) {
    setState(() => _selectedCategory = cat);
    _bloc.add(LoadVacancyFeed(position: cat == 'All' ? null : cat));
  }

  @override
  void dispose() {
    _bloc.close();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        body: SafeArea(
          child: Column(
            children: [
              // ── App Bar ─────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(color: AppColors.cF9A405, shape: BoxShape.circle),
                          child: const Icon(Icons.bolt, color: Colors.white, size: 20),
                        ),
                        12.g,
                        const CustomText(text: 'Speed Staff', fontSize: 18, fontWeight: FontWeight.w800),
                      ],
                    ),
                    const Spacer(),
                    IconButton(onPressed: () => context.push(RouteNames.notifications), icon: const Icon(Icons.notifications_none_rounded, size: 26)),
                  ],
                ),
              ),

              // ── Search Bar ──────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: GestureDetector(
                  onTap: () => context.push(RouteNames.seekerSearch),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded, color: Colors.grey.shade400),
                        12.g,
                        Text('Search roles or restaurants...', style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.tune_rounded, color: AppColors.cF9A405, size: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Categories ─────────────────────────
              SizedBox(
                height: 52,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  itemCount: _categories.length,
                  itemBuilder: (ctx, i) {
                    final cat = _categories[i];
                    final active = cat == _selectedCategory;
                    return GestureDetector(
                      onTap: () => _onCategoryTap(cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                        decoration: BoxDecoration(
                          color: active ? AppColors.cF9A405 : Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: active ? AppColors.cF9A405 : Colors.grey.shade200),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: active ? Colors.white : Colors.grey.shade700,
                            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ── Body ───────────────────────────────
              Expanded(
                child: BlocBuilder<VacancyFeedBloc, VacancyFeedState>(
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
                            CustomText(text: state.errorMessage ?? 'Failed to load vacancies', color: Colors.grey),
                            20.g,
                            TextButton(
                              onPressed: () => _bloc.add(const LoadVacancyFeed()),
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
                            Icon(Icons.work_off_outlined, size: 64, color: Colors.grey.shade300),
                            16.g,
                            const CustomText(text: 'No vacancies found', color: Colors.grey),
                          ],
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText(text: 'Job Vacancies', fontSize: 17, fontWeight: FontWeight.w800),
                              CustomText(text: '${state.vacancies.length} positions found', fontSize: 12, color: Colors.grey.shade500),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                            itemCount: state.vacancies.length + (state.hasNext ? 1 : 0),
                            itemBuilder: (ctx, i) {
                              if (i == state.vacancies.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(child: CircularProgressIndicator(color: AppColors.cF9A405)),
                                );
                              }
                              return _VacancyCard(
                                vacancy: state.vacancies[i],
                                isSaved: state.savedVacancyIds.contains(state.vacancies[i].id),
                                onTap: () => context.push(RouteNames.vacancyDetail, extra: state.vacancies[i]),
                                onApply: () => context.push(RouteNames.applyVacancy, extra: state.vacancies[i]),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VacancyCard extends StatelessWidget {
  final Vacancy vacancy;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onApply;

  const _VacancyCard({required this.vacancy, required this.isSaved, required this.onTap, required this.onApply});

  String _formatSalary(int? min, int? max) {
    final fmt = NumberFormat('#,##0', 'en_US');
    if (min != null && max != null) return '${fmt.format(min)} - ${fmt.format(max)} UZS';
    if (min != null) return 'from ${fmt.format(min)} UZS';
    return 'Negotiable';
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = vacancy.isPremium == true;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isPremium ? AppColors.cF9A405.withValues(alpha: 0.3) : Colors.transparent),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                  child: vacancy.employer?.logoUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(vacancy.employer!.logoUrl!, fit: BoxFit.cover),
                        )
                      : Icon(Icons.restaurant_rounded, color: Colors.grey.shade400, size: 24),
                ),
                12.g,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: vacancy.title, fontSize: 15, fontWeight: FontWeight.w700),
                      4.g,
                      CustomText(text: vacancy.employer?.restaurantName ?? '', fontSize: 13, color: isPremium ? AppColors.cF9A405 : Colors.grey.shade600),
                    ],
                  ),
                ),
                if (isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.cF9A405, borderRadius: BorderRadius.circular(100)),
                    child: const Text(
                      'PREMIUM',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                    ),
                  ),
              ],
            ),
            12.g,
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade500),
                4.g,
                Expanded(
                  child: Text(
                    [vacancy.employer?.city, vacancy.workType].where((e) => e != null && e.isNotEmpty).join(' • '),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            8.g,
            Row(
              children: [
                const Text('🪙', style: TextStyle(fontSize: 12)),
                6.g,
                Expanded(
                  child: Text(
                    _formatSalary(vacancy.salaryMin, vacancy.salaryMax),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.cF9A405),
                  ),
                ),
                GestureDetector(
                  onTap: onApply,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                    decoration: BoxDecoration(color: isPremium ? AppColors.cF9A405 : const Color(0xFF1F3C88), borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      isPremium ? 'Apply Now' : 'View Details',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
