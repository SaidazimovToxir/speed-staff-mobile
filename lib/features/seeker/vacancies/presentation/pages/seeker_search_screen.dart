import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/presentation/bloc/vacancy_feed_bloc.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/presentation/bloc/vacancy_feed_event.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/presentation/bloc/vacancy_feed_state.dart';
import 'package:intl/intl.dart';

class SeekerSearchScreen extends StatefulWidget {
  const SeekerSearchScreen({super.key});

  @override
  State<SeekerSearchScreen> createState() => _SeekerSearchScreenState();
}

class _SeekerSearchScreenState extends State<SeekerSearchScreen> {
  late final VacancyFeedBloc _bloc;
  final _searchController = TextEditingController();
  final List<String> _recentSearches = ['Junior Waiter in Downtown', 'Head Chef', 'Vegan Restaurant'];
  bool _showResults = false;

  // Category grid config
  static const _categories = [
    {'label': 'Waiter', 'icon': '🍴', 'query': 'Waiter'},
    {'label': 'Cook', 'icon': '🥘', 'query': 'Cook'},
    {'label': 'Barista', 'icon': '🍹', 'query': 'Barista'},
    {'label': 'Manager', 'icon': '📋', 'query': 'Manager'},
    {'label': 'Hostess', 'icon': '📍', 'query': 'Hostess'},
    {'label': 'Dishwasher', 'icon': '🧴', 'query': 'Dishwasher'},
  ];

  @override
  void initState() {
    super.initState();
    _bloc = sl<VacancyFeedBloc>();
  }

  void _search(String query) {
    if (query.trim().isEmpty) return;
    if (!_recentSearches.contains(query)) {
      setState(() => _recentSearches.insert(0, query));
    }
    _bloc.add(SearchVacancies(q: query.trim()));
    setState(() => _showResults = true);
    FocusScope.of(context).unfocus();
  }

  void _clearRecent(String item) {
    setState(() => _recentSearches.remove(item));
  }

  @override
  void dispose() {
    _bloc.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14)),
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: _search,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: 'Search roles, skills, or restaurants',
                            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                            prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade500),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    12.g,
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(color: AppColors.cF9A405, borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _showResults ? _buildResults() : _buildIdleView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdleView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(text: 'Recent Searches', fontSize: 16, fontWeight: FontWeight.w700),
                TextButton(
                  onPressed: () => setState(() => _recentSearches.clear()),
                  child: const Text(
                    'Clear All',
                    style: TextStyle(color: AppColors.cF9A405, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            ..._recentSearches.map(
              (q) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.history_rounded, color: Colors.grey.shade400),
                title: Text(q, style: const TextStyle(fontSize: 14)),
                trailing: IconButton(
                  icon: Icon(Icons.close_rounded, color: Colors.grey.shade400, size: 18),
                  onPressed: () => _clearRecent(q),
                ),
                onTap: () {
                  _searchController.text = q;
                  _search(q);
                },
              ),
            ),
            24.g,
          ],

          // Category Grid
          const CustomText(text: 'Explore Categories', fontSize: 16, fontWeight: FontWeight.w700),
          16.g,
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: _categories
                .map(
                  (cat) => GestureDetector(
                    onTap: () {
                      _searchController.text = cat['query']!;
                      _search(cat['query']!);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(color: const Color(0xFFFFF3D6), shape: BoxShape.circle),
                            child: Center(child: Text(cat['icon']!, style: const TextStyle(fontSize: 22))),
                          ),
                          8.g,
                          Text(cat['label']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return BlocBuilder<VacancyFeedBloc, VacancyFeedState>(
      builder: (context, state) {
        if (state.status == VacancyFeedStatus.loading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.cF9A405));
        }
        if (state.vacancies.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
                16.g,
                const CustomText(text: 'No results found', color: Colors.grey),
                8.g,
                TextButton(
                  onPressed: () => setState(() => _showResults = false),
                  child: const Text('Back to search', style: TextStyle(color: AppColors.cF9A405)),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          itemCount: state.vacancies.length,
          separatorBuilder: (_, _) => const Divider(height: 1, indent: 16, endIndent: 16),
          itemBuilder: (ctx, i) {
            final v = state.vacancies[i];
            final fmt = NumberFormat('#,##0', 'en_US');
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                child: v.employer?.logoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(v.employer!.logoUrl!, fit: BoxFit.cover),
                      )
                    : const Icon(Icons.restaurant_rounded, color: Colors.grey),
              ),
              title: Text(v.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(v.employer?.restaurantName ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  4.g,
                  Text(
                    v.salaryMin != null ? '${fmt.format(v.salaryMin)} UZS' : 'Negotiable',
                    style: const TextStyle(color: AppColors.cF9A405, fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
              onTap: () => context.push(RouteNames.vacancyDetail, extra: v),
            );
          },
        );
      },
    );
  }
}
