import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_bloc.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_state.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_event.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/candidate_profile_header.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/candidate_core_skills.dart';

class CandidateProfileScreen extends StatefulWidget {
  final String candidateId;
  const CandidateProfileScreen({super.key, required this.candidateId});

  @override
  State<CandidateProfileScreen> createState() => _CandidateProfileScreenState();
}

class _CandidateProfileScreenState extends State<CandidateProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ApplicationsBloc>().add(LoadApplicationDetail(widget.candidateId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationsBloc, ApplicationsState>(
      builder: (context, state) {
        ApplicationDetailEntity? application;
        if (state is ApplicationDetailLoaded) application = state.application;
        if (state is ApplicationStatusUpdated) application = state.application;
        if (state is ApplicationStatusUpdating) application = state.application;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                if (context.canPop()) context.pop();
              },
            ),
            title: const CustomText(text: "Nomzod profili", fontSize: 18, fontWeight: FontWeight.bold),
          ),
          body: () {
            if (state is ApplicationsLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.c1F3C88));
            }
            if (application != null) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    CandidateProfileHeader(seeker: application.seeker),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [CandidateCoreSkills(skills: const [])],
                      ),
                    ),
                  ],
                ),
              );
            }
            if (state is ApplicationsError) {
              return Center(
                child: CustomText(text: state.message, color: AppColors.cFF0000),
              );
            }
            return const Center(child: CustomText(text: "Yuklanmoqda..."));
          }(),
          bottomNavigationBar: application != null ? _buildBottomButtons(context, application) : null,
        );
      },
    );
  }

  Widget _buildBottomButtons(BuildContext context, ApplicationDetailEntity application) {
    final isFinal = application.isFinal;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: isFinal
          ? Center(
              child: CustomText(
                text: application.status == 'hired' ? "✓ Qabul qilingan" : "✗ Rad etilgan",
                fontWeight: FontWeight.w700,
                color: application.status == 'hired' ? Colors.green.shade700 : Colors.red.shade700,
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: "Rad etish",
                    isOutlined: true,
                    onPressed: () => _showSheet(context, application, 'rejected'),
                    height: 52,
                    textColor: Colors.red,
                    color: Colors.red,
                  ),
                ),
                12.g,
                Expanded(
                  child: PrimaryButton(
                    text: application.status == 'shortlisted' ? "Qabul" : "Tanlash",
                    onPressed: () => _showSheet(context, application, application.status == 'shortlisted' ? 'hired' : 'shortlisted'),
                    height: 52,
                    color: AppColors.cF9A405,
                  ),
                ),
              ],
            ),
    );
  }

  void _showSheet(BuildContext context, ApplicationDetailEntity application, String target) {
    if (application.allowedTransitions.isEmpty) return;
    context.read<ApplicationsBloc>().add(UpdateApplicationStatusEvent(applicationId: application.id, newStatus: target));
  }
}
