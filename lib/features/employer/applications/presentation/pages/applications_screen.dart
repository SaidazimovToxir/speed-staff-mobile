import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_bloc.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_state.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_event.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/applications_filter_chips.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/applications_list_view.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/applications_app_bar.dart';

class ApplicationsScreen extends StatefulWidget {
  final String vacancyId;
  const ApplicationsScreen({super.key, required this.vacancyId});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ApplicationsBloc>().add(
      LoadVacancyApplications(widget.vacancyId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.white, // Match design background color
        appBar: const ApplicationsAppBar(),
        body: BlocBuilder<ApplicationsBloc, ApplicationsState>(
          builder: (context, state) {
            switch (state) {
              case ApplicationsLoading():
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.c1F3C88),
                );
              case ApplicationsLoaded(candidates: final candidates):
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Row(
                        children: [
                          const Expanded(
                            child: TabBar(
                              isScrollable: true,
                              labelColor: AppColors.cF9A405,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: AppColors.cF9A405,
                              tabAlignment: TabAlignment.start,
                              labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                              tabs: [
                                Tab(text: "All"),
                                Tab(text: "New"),
                                Tab(text: "Shortlisted"),
                                Tab(text: "Interviewing"),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.tune, color: Colors.black),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: AppColors.cF6F6F6,
                        child: TabBarView(
                          children: [
                            ApplicationsListView(candidates: candidates),
                            const Center(child: CustomText(text: "New Candidates List")),
                            const Center(child: CustomText(text: "Shortlisted Candidates")),
                            const Center(child: CustomText(text: "Interviewing Candidates")),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              case ApplicationsError(message: final msg):
                return Center(
                  child: CustomText(
                    text: "Error: $msg",
                    color: AppColors.cFF0000,
                  ),
                );
              default:
                return const Center(
                  child: CustomText(text: "Loading applications..."),
                );
            }
          },
        ),
      ),
    );
  }
}
