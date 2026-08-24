import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/seeker/applications/presentation/bloc/application_bloc.dart';
import 'package:speed_staff_mobile/features/seeker/applications/presentation/bloc/application_state_event.dart';
import 'package:speed_staff_mobile/features/seeker/applications/domain/entities/application.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  late final ApplicationBloc _bloc;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _bloc = sl<ApplicationBloc>();
    _bloc.add(const LoadMyApplications());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  int _countByStatus(List<Application> apps, String status) {
    if (status == 'All') return apps.length;
    if (status == 'Active') {
      return apps.where((a) => a.status != 'rejected' && a.status != 'hired').length;
    }
    return apps.where((a) => a.status.toLowerCase() == status.toLowerCase()).length;
  }

  List<Application> _getFilteredApps(List<Application> apps) {
    if (_selectedFilter == 'All') return apps;
    if (_selectedFilter == 'Active') {
      return apps.where((a) => a.status != 'rejected' && a.status != 'hired').toList();
    }
    return apps.where((a) => a.status.toLowerCase() == _selectedFilter.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
            onPressed: () {
              if (context.canPop()) context.pop();
            },
          ),
          title: const CustomText(text: 'My Applications', fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.black),
          centerTitle: true,
        ),
        body: BlocBuilder<ApplicationBloc, ApplicationState>(
          builder: (context, state) {
            if (state.status == ApplicationStatus.loading && state.applications.isEmpty) {
              return const Center(child: CircularProgressIndicator(color: AppColors.cF9A405));
            }
            if (state.status == ApplicationStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, size: 64, color: Colors.grey.shade300),
                    16.g,
                    Text(state.errorMessage ?? 'Failed to load applications', style: const TextStyle(color: Colors.grey)),
                    16.g,
                    TextButton(
                      onPressed: () => _bloc.add(const LoadMyApplications()),
                      child: const Text('Retry', style: TextStyle(color: AppColors.cF9A405)),
                    ),
                  ],
                ),
              );
            }

            final apps = state.applications;
            final filters = ['All', 'Active', 'Shortlisted', 'Sent', 'Viewed', 'Rejected', 'Hired'];

            return Column(
              children: [
                // Filter Chips
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    scrollDirection: Axis.horizontal,
                    itemCount: filters.length,
                    separatorBuilder: (_, _) => 8.g,
                    itemBuilder: (ctx, i) {
                      final filter = filters[i];
                      final count = _countByStatus(apps, filter);
                      final isSelected = filter == _selectedFilter;
                      if (count == 0 && filter != 'All') return const SizedBox.shrink();

                      return GestureDetector(
                        onTap: () => setState(() => _selectedFilter = filter),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.cF9A405 : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? AppColors.cF9A405 : Colors.grey.shade200),
                          ),
                          child: Center(
                            child: Text(
                              '$filter ($count)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? Colors.white : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // List
                Expanded(
                  child: _getFilteredApps(apps).isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.folder_open_rounded, size: 80, color: Colors.grey.shade200),
                              16.g,
                              const Text('No applications found', style: TextStyle(color: Colors.grey, fontSize: 16)),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                          itemCount: _getFilteredApps(apps).length,
                          separatorBuilder: (_, _) => 16.g,
                          itemBuilder: (ctx, i) {
                            final app = _getFilteredApps(apps)[i];
                            return _ApplicationCard(application: app);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final Application application;

  const _ApplicationCard({required this.application});

  Color _getStatusColor() {
    final s = application.status.toLowerCase();
    switch (s) {
      case 'shortlisted':
        return const Color(0xFFE8F5E9);
      case 'viewed':
        return const Color(0xFFE3F2FD);
      case 'sent':
        return const Color(0xFFFFF8E1);
      case 'rejected':
        return const Color(0xFFFFEBEE);
      case 'hired':
        return const Color(0xFF4CAF50);
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusTextColor() {
    final s = application.status.toLowerCase();
    switch (s) {
      case 'shortlisted':
        return const Color(0xFF2E7D32);
      case 'viewed':
        return const Color(0xFF1565C0);
      case 'sent':
        return const Color(0xFFF57F17);
      case 'rejected':
        return const Color(0xFFC62828);
      case 'hired':
        return Colors.white;
      default:
        return Colors.grey.shade700;
    }
  }

  String _formatStatus() {
    final str = application.status;
    if (str.isEmpty) return 'Unknown';
    return str[0].toUpperCase() + str.substring(1).toLowerCase();
  }

  String _timeAgo(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inDays > 8) return '${d.day}/${d.month}/${d.year}';
    if ((diff.inDays / 7).floor() >= 1) return '1 week ago';
    if (diff.inDays >= 2) return '${diff.inDays} days ago';
    if (diff.inDays >= 1) return '1 day ago';
    if (diff.inHours >= 2) return '${diff.inHours} hours ago';
    if (diff.inHours >= 1) return '1 hour ago';
    if (diff.inMinutes >= 2) return '${diff.inMinutes} minutes ago';
    if (diff.inMinutes >= 1) return '1 minute ago';
    return 'just now';
  }

  @override
  Widget build(BuildContext context) {
    final vacancy = application.vacancy;
    final timeStr = application.appliedAt != null ? _timeAgo(application.appliedAt!) : 'recently';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: const Color(0xFF2C4A45), borderRadius: BorderRadius.circular(12)),
            child: vacancy?.employer?.logoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(vacancy!.employer!.logoUrl!, fit: BoxFit.cover),
                  )
                : const Icon(Icons.corporate_fare_rounded, color: Colors.white),
          ),
          16.g,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(vacancy?.title ?? 'Unknown Vacancy', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: _getStatusColor(), borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        _formatStatus(),
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _getStatusTextColor()),
                      ),
                    ),
                  ],
                ),
                4.g,
                Text(
                  [vacancy?.employer?.restaurantName, vacancy?.employer?.city].where((e) => e != null && e.isNotEmpty).join(' • '),
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                6.g,
                Text('Applied $timeStr', style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
