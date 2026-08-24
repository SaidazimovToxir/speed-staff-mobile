import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_bloc.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_state.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_event.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/applications_list_view.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/applications_app_bar.dart';

class ApplicationsScreen extends StatefulWidget {
  final String vacancyId;
  const ApplicationsScreen({super.key, required this.vacancyId});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen>
    with SingleTickerProviderStateMixin {

  static const _tabs = [
    ('Barchasi', null),
    ('Yangi', 'sent'),
    ('Tanlangan', 'shortlisted'),
    ('Qabul', 'hired'),
    ('Rad', 'rejected'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _load(_tabs[_tabController.index].$2);
      }
    });
    _load(null);
  }

  void _load(String? status) {
    context.read<ApplicationsBloc>().add(
      LoadVacancyApplications(widget.vacancyId, status: status),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const ApplicationsAppBar(),
      body: Column(
        children: [
          // TabBar
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.cF9A405,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.cF9A405,
              tabAlignment: TabAlignment.start,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              tabs: _tabs.map((t) => Tab(text: t.$1)).toList(),
            ),
          ),
          // Content
          Expanded(
            child: Container(
              color: AppColors.cF6F6F6,
              child: BlocBuilder<ApplicationsBloc, ApplicationsState>(
                builder: (context, state) {
                  if (state is ApplicationsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.c1F3C88),
                    );
                  }
                  if (state is ApplicationsLoaded) {
                    return TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: _tabs.map((t) {
                        final items = state.paginated.items;
                        return ApplicationsListView(applications: items);
                      }).toList(),
                    );
                  }
                  if (state is ApplicationsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.cFF0000, size: 48),
                          12.g,
                          CustomText(text: state.message, color: AppColors.cFF0000),
                          16.g,
                          PrimaryButton(
                            text: "Qayta urinish",
                            onPressed: () => _load(_tabs[_tabController.index].$2),
                            width: 160,
                            height: 44,
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
