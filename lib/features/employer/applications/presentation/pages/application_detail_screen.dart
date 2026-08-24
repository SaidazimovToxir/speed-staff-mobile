import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_bloc.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_state.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_event.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/candidate_profile_header.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/application_status_sheet.dart';

class ApplicationDetailScreen extends StatefulWidget {
  final String applicationId;
  const ApplicationDetailScreen({super.key, required this.applicationId});

  @override
  State<ApplicationDetailScreen> createState() => _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState extends State<ApplicationDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ApplicationsBloc>().add(
      LoadApplicationDetail(widget.applicationId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApplicationsBloc, ApplicationsState>(
      listenWhen: (prev, curr) =>
          curr is ApplicationStatusUpdated || curr is ApplicationsError,
      listener: (context, state) {
        if (state is ApplicationStatusUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Status yangilandi!"),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
        if (state is ApplicationsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.cFF0000,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      builder: (context, state) {
        ApplicationDetailEntity? application;
        bool isUpdating = false;

        if (state is ApplicationDetailLoaded) {
          application = state.application;
        } else if (state is ApplicationStatusUpdated) {
          application = state.application;
        } else if (state is ApplicationStatusUpdating) {
          application = state.application;
          isUpdating = true;
        }

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () { if (context.canPop()) context.pop(); },
            ),
            title: const CustomText(
              text: "Ariza",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: _buildBody(context, state, application, isUpdating),
          bottomNavigationBar: application != null
              ? _buildBottomButtons(context, application, isUpdating)
              : null,
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ApplicationsState state,
    ApplicationDetailEntity? application,
    bool isUpdating,
  ) {
    if (state is ApplicationsLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.c1F3C88),
      );
    }

    if (application == null) {
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
                onPressed: () => context.read<ApplicationsBloc>().add(
                  LoadApplicationDetail(widget.applicationId),
                ),
                width: 160,
                height: 44,
              ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seeker header
          CandidateProfileHeader(seeker: application.seeker),
          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badge
                _buildStatusRow(application),
                16.g,

                // Ariza vaqtlari
                _buildTimingCard(application),
                20.g,

                // Cover letter
                if (application.coverLetter != null &&
                    application.coverLetter!.isNotEmpty) ...[
                  _buildSection(
                    icon: Icons.mail_outline_rounded,
                    title: "Murojaat maktubi",
                    child: Text(
                      application.coverLetter!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                  ),
                  20.g,
                ],

                // Employer note
                if (application.employerNote != null &&
                    application.employerNote!.isNotEmpty) ...[
                  _buildSection(
                    icon: Icons.sticky_note_2_outlined,
                    title: "Izohingiz",
                    child: Text(
                      application.employerNote!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                  ),
                  20.g,
                ],

                // Vacancy info
                _buildSection(
                  icon: Icons.work_outline_rounded,
                  title: "Vakansiya",
                  child: _buildVacancyCard(application.vacancy),
                ),
                20.g,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(ApplicationDetailEntity application) {
    final cfg = _statusConfig(application.status);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: cfg.backgroundColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(cfg.icon, color: cfg.textColor, size: 15),
              6.g,
              CustomText(
                text: _statusLabel(application.status),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: cfg.textColor,
              ),
            ],
          ),
        ),
        if (application.isFinal) ...[
          12.g,
          const Icon(Icons.lock_rounded, color: Colors.grey, size: 16),
          4.g,
          CustomText(text: "Yakunlandi", fontSize: 12, color: Colors.grey.shade500),
        ],
      ],
    );
  }

  Widget _buildTimingCard(ApplicationDetailEntity application) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _buildTimingRow(
            Icons.send_rounded,
            "Ariza yuborildi",
            DateFormat('dd MMM yyyy, HH:mm').format(application.appliedAt),
          ),
          if (application.viewedAt != null) ...[
            Divider(height: 16, color: Colors.grey.shade200),
            _buildTimingRow(
              Icons.remove_red_eye_rounded,
              "Ko'rildi",
              DateFormat('dd MMM yyyy, HH:mm').format(application.viewedAt!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimingRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.c1F3C88, size: 16),
        10.g,
        Expanded(
          child: CustomText(text: label, fontSize: 13, color: Colors.grey.shade600),
        ),
        CustomText(text: value, fontSize: 13, fontWeight: FontWeight.w600),
      ],
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.c1F3C88, size: 18),
            8.g,
            CustomText(text: title, fontSize: 15, fontWeight: FontWeight.bold),
          ],
        ),
        12.g,
        child,
      ],
    );
  }

  Widget _buildVacancyCard(VacancyShortEntity vacancy) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.c1F3C88.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.c1F3C88.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: vacancy.title, fontSize: 15, fontWeight: FontWeight.bold),
          6.g,
          CustomText(text: vacancy.position, fontSize: 13, color: Colors.grey.shade600),
          if (vacancy.salaryMin != null || vacancy.salaryMax != null) ...[
            8.g,
            Row(
              children: [
                const Icon(Icons.attach_money_rounded, size: 16, color: Colors.green),
                3.g,
                CustomText(
                  text: _salaryText(vacancy),
                  fontSize: 13,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _salaryText(VacancyShortEntity v) {
    final format = NumberFormat('#,###');
    if (v.salaryMin != null && v.salaryMax != null) {
      return '${format.format(v.salaryMin)} – ${format.format(v.salaryMax)} so\'m';
    } else if (v.salaryMin != null) {
      return '${format.format(v.salaryMin)} so\'mdan';
    }
    return 'Kelishiladi';
  }

  Widget _buildBottomButtons(
    BuildContext context,
    ApplicationDetailEntity application,
    bool isUpdating,
  ) {
    final allowed = application.allowedTransitions;
    final isFinal = application.isFinal;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: isFinal
          ? Center(
              child: CustomText(
                text: application.status == 'hired'
                    ? "✓ Nomzod qabul qilingan"
                    : "✗ Nomzod rad etilgan",
                color: application.status == 'hired'
                    ? Colors.green.shade700
                    : Colors.red.shade700,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            )
          : Row(
              children: [
                if (allowed.contains('rejected'))
                  Expanded(
                    child: PrimaryButton(
                      text: "Rad etish",
                      isOutlined: true,
                      isLoading: isUpdating,
                      onPressed: () => _showStatusSheet(context, application),
                      height: 52,
                      textColor: Colors.red,
                      color: Colors.red,
                    ),
                  ),
                if (allowed.contains('rejected') && allowed.length > 1) 12.g,
                if (allowed.contains('shortlisted'))
                  Expanded(
                    child: PrimaryButton(
                      text: "Tanlash",
                      isLoading: isUpdating,
                      onPressed: () => _updateStatus(context, application.id, 'shortlisted'),
                      height: 52,
                      color: AppColors.cF9A405,
                    ),
                  ),
                if (allowed.contains('hired'))
                  Expanded(
                    child: PrimaryButton(
                      text: "Qabul qilish",
                      isLoading: isUpdating,
                      onPressed: () => _showHireDialog(context, application),
                      height: 52,
                      color: Colors.green.shade600,
                    ),
                  ),
              ],
            ),
    );
  }

  void _showStatusSheet(BuildContext context, ApplicationDetailEntity application) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => ApplicationStatusSheet(
        currentStatus: application.status,
        allowedTransitions: application.allowedTransitions,
        onStatusSelected: (status, note) {
          context.read<ApplicationsBloc>().add(
            UpdateApplicationStatusEvent(
              applicationId: application.id,
              newStatus: status,
              employerNote: note,
            ),
          );
        },
      ),
    );
  }

  void _showHireDialog(BuildContext context, ApplicationDetailEntity application) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Nomzodni qabul qilish?", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          "${application.seeker.fullName} ni qabul qilyapsiz. Bu amalni qaytarib bo'lmaydi.",
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            child: const Text("Bekor qilish"),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _updateStatus(context, application.id, 'hired');
            },
            child: const Text("Ha, qabul"),
          ),
        ],
      ),
    );
  }

  void _updateStatus(BuildContext context, String id, String status, {String? note}) {
    context.read<ApplicationsBloc>().add(
      UpdateApplicationStatusEvent(
        applicationId: id,
        newStatus: status,
        employerNote: note,
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'sent': return 'Yangi ariza';
      case 'viewed': return "Ko'rildi";
      case 'shortlisted': return 'Tanlangan';
      case 'hired': return 'Qabul qilingan';
      case 'rejected': return 'Rad etilgan';
      default: return status;
    }
  }

  ({Color textColor, Color backgroundColor, IconData icon}) _statusConfig(String status) {
    switch (status) {
      case 'sent':
        return (textColor: Colors.blue.shade700, backgroundColor: Colors.blue.shade50, icon: Icons.send_rounded);
      case 'viewed':
        return (textColor: AppColors.cF9A405, backgroundColor: AppColors.cF9A405.withValues(alpha: 0.1), icon: Icons.remove_red_eye_rounded);
      case 'shortlisted':
        return (textColor: Colors.green.shade700, backgroundColor: Colors.green.shade50, icon: Icons.star_rounded);
      case 'hired':
        return (textColor: Colors.teal.shade700, backgroundColor: Colors.teal.shade50, icon: Icons.check_circle_rounded);
      case 'rejected':
        return (textColor: Colors.red.shade700, backgroundColor: Colors.red.shade50, icon: Icons.cancel_rounded);
      default:
        return (textColor: Colors.grey.shade700, backgroundColor: Colors.grey.shade100, icon: Icons.info_rounded);
    }
  }
}
