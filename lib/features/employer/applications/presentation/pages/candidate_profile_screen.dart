import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_bloc.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_state.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_event.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/candidate_profile_header.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/candidate_core_skills.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/candidate_work_experience.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/candidate_documents_section.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/application_status_sheet.dart';

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
    context.read<ApplicationsBloc>().add(
      LoadCandidateDetails(widget.candidateId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        title: const CustomText(
          text: "Candidate Profile",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
               padding: const EdgeInsets.all(8),
               decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
               child: const Icon(Icons.more_horiz, color: Colors.black, size: 20),
            )
          )
        ],
      ),
      body: BlocBuilder<ApplicationsBloc, ApplicationsState>(
        builder: (context, state) {
          switch (state) {
            case ApplicationsLoading():
              return const Center(
                child: CircularProgressIndicator(color: AppColors.c1F3C88),
              );
            case CandidateDetailsLoaded(candidate: final candidate):
              return SingleChildScrollView(
                child: Column(
                  children: [
                    CandidateProfileHeader(candidate: candidate),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CandidateCoreSkills(skills: candidate.skills ?? []),
                          24.g,
                          CandidateWorkExperience(
                            experiences: candidate.experiences ?? [],
                          ),
                          24.g,
                          CandidateDocumentsSection(
                            documents: candidate.documents ?? [],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                child: CustomText(text: "Loading profile..."),
              );
          }
        },
      ),
      bottomNavigationBar: _buildBottomButtons(context),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20).copyWith(bottom: 30), // Extra padding for safe area
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _showStatusUpdateSheet(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const CustomText(
                text: "Reject",
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          12.g,
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cF9A405,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const CustomText(
                text: "Hire & Contact",
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusUpdateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => ApplicationStatusSheet(
        onStatusSelected: (status) {
          context.read<ApplicationsBloc>().add(
            UpdateApplicationStatusEvent(
              candidateId: widget.candidateId,
              newStatus: status,
            ),
          );
        },
      ),
    );
  }
}
