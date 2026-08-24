import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/domain/entities/vacancy.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/presentation/bloc/vacancy_feed_bloc.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/presentation/bloc/vacancy_feed_event.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/presentation/bloc/vacancy_feed_state.dart';
import 'package:toastification/toastification.dart';

class VacancyDetailScreen extends StatefulWidget {
  final Vacancy vacancy;
  const VacancyDetailScreen({super.key, required this.vacancy});

  @override
  State<VacancyDetailScreen> createState() => _VacancyDetailScreenState();
}

class _VacancyDetailScreenState extends State<VacancyDetailScreen> {
  late final VacancyFeedBloc _bloc;
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _bloc = sl<VacancyFeedBloc>()..add(LoadVacancyDetail(widget.vacancy.id));
    _isSaved = false;
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _toggleSave() {
    if (_isSaved) {
      _bloc.add(RemoveSavedVacancy(widget.vacancy.id));
    } else {
      _bloc.add(SaveVacancy(widget.vacancy.id));
    }
    setState(() => _isSaved = !_isSaved);
    toastification.show(
      context: context,
      title: Text(_isSaved ? 'Saved to favourites' : 'Removed from favourites'),
      type: _isSaved ? ToastificationType.success : ToastificationType.info,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  String _formatSalary(Vacancy v) {
    final fmt = NumberFormat('#,##0', 'en_US');
    if (v.salaryMin != null && v.salaryMax != null) {
      return '\$${fmt.format(v.salaryMin)} - \$${fmt.format(v.salaryMax)}';
    }
    if (v.salaryMin != null) return 'from \$${fmt.format(v.salaryMin)}';
    return 'Negotiable';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<VacancyFeedBloc, VacancyFeedState>(
        listenWhen: (prev, curr) => curr.saveMessage != null && prev.saveMessage != curr.saveMessage,
        listener: (context, state) {},
        builder: (context, state) {
          final vacancy = state.selectedVacancy ?? widget.vacancy;
          return Scaffold(
            backgroundColor: Colors.white,
            body: CustomScrollView(
              slivers: [
                // ── App Bar with hero card ─────────────
                SliverAppBar(
                  expandedHeight: 240,
                  pinned: true,
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
                    onPressed: () {
                      if (context.canPop()) context.pop();
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border_rounded, color: _isSaved ? AppColors.cF9A405 : Colors.black),
                      onPressed: _toggleSave,
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: const CustomText(text: 'Vacancy Detail', fontSize: 16, fontWeight: FontWeight.w800),
                    background: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Employer logo
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))],
                          ),
                          child: vacancy.employer?.logoUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(vacancy.employer!.logoUrl!, fit: BoxFit.cover),
                                )
                              : const Icon(Icons.restaurant_rounded, size: 36, color: Colors.grey),
                        ),
                        12.g,
                        Text(vacancy.employer?.restaurantName ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                        6.g,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade500),
                            4.g,
                            Text(
                              [vacancy.employer?.city, vacancy.workType].where((e) => e != null && e.isNotEmpty).join(' • '),
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                        24.g,
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Salary Hero ─────────────────────
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFF8EC), Color(0xFFFFF3D6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ESTIMATED SALARY',
                                style: TextStyle(fontSize: 11, color: AppColors.cF9A405, fontWeight: FontWeight.w700, letterSpacing: 1),
                              ),
                              8.g,
                              Text(
                                _formatSalary(vacancy),
                                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1A1A2E)),
                              ),
                              12.g,
                              Row(
                                children: [
                                  _infoChip(Icons.calendar_today_outlined, vacancy.schedule ?? 'Flexible'),
                                  12.g,
                                  _infoChip(Icons.flash_on_rounded, 'Immediate'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        16.g,

                        // ── Job Type / Schedule ─────────────
                        Row(
                          children: [
                            Expanded(child: _detailCard(Icons.access_time_rounded, 'Job Type', vacancy.workType ?? 'Full-time')),
                            12.g,
                            Expanded(child: _detailCard(Icons.wb_sunny_outlined, 'Shift', vacancy.schedule ?? 'Flexible')),
                          ],
                        ),
                        20.g,

                        // ── Description ────────────────────
                        if (vacancy.description != null && vacancy.description!.isNotEmpty) ...[
                          _sectionTitle('Job Description'),
                          12.g,
                          Text(vacancy.description!, style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.6)),
                          20.g,
                        ],

                        // ── Requirements ──────────────────
                        if (vacancy.requirements != null && vacancy.requirements!.isNotEmpty) ...[
                          _sectionTitle('Requirements'),
                          12.g,
                          ...vacancy.requirements!
                              .split('\n')
                              .where((l) => l.trim().isNotEmpty)
                              .map(
                                (line) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.check_circle_outline_rounded, color: AppColors.cF9A405, size: 18),
                                      10.g,
                                      Expanded(
                                        child: Text(line.trim(), style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          20.g,
                        ],

                        // ── Skills ────────────────────────
                        if (vacancy.skills.isNotEmpty) ...[
                          _sectionTitle('Skills'),
                          12.g,
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: vacancy.skills
                                .map(
                                  (s) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF3D6),
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(color: AppColors.cF9A405.withValues(alpha: 0.3)),
                                    ),
                                    child: Text(
                                      s.nameUz.isNotEmpty ? s.nameUz : s.nameRu,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.cF9A405),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          20.g,
                        ],

                        // ── Location ───────────────────────
                        if (vacancy.employer?.city != null) ...[
                          _sectionTitle('Location'),
                          12.g,
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, color: Colors.grey.shade500, size: 16),
                              6.g,
                              Text(vacancy.employer!.city!, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, -4))],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.share_outlined),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  12.g,
                  Expanded(
                    child: PrimaryButton(
                      text: 'Apply Now  →',
                      onPressed: () => context.push(RouteNames.applyVacancy, extra: vacancy),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) => Container(
    padding: const EdgeInsets.only(left: 12),
    decoration: const BoxDecoration(
      border: Border(left: BorderSide(color: AppColors.cF9A405, width: 3)),
    ),
    child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
  );

  Widget _infoChip(IconData icon, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: Colors.grey.shade600),
      6.g,
      Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
      ),
    ],
  );

  Widget _detailCard(IconData icon, String label, String value) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade100),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.cF9A405, size: 20),
        10.g,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            2.g,
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    ),
  );
}
