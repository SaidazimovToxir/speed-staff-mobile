import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/seeker/applications/presentation/bloc/application_bloc.dart';
import 'package:speed_staff_mobile/features/seeker/applications/presentation/bloc/application_state_event.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/domain/entities/vacancy.dart';
import 'package:toastification/toastification.dart';

class ApplyVacancyScreen extends StatefulWidget {
  final Vacancy vacancy;
  const ApplyVacancyScreen({super.key, required this.vacancy});

  @override
  State<ApplyVacancyScreen> createState() => _ApplyVacancyScreenState();
}

class _ApplyVacancyScreenState extends State<ApplyVacancyScreen> {
  late final ApplicationBloc _bloc;
  final _coverLetterController = TextEditingController();
  bool _attachResume = true;

  @override
  void initState() {
    super.initState();
    _bloc = sl<ApplicationBloc>();
  }

  @override
  void dispose() {
    _bloc.close();
    _coverLetterController.dispose();
    super.dispose();
  }

  void _submit() {
    _bloc.add(ApplyForVacancy(widget.vacancy.id, coverLetter: _coverLetterController.text.trim().isNotEmpty ? _coverLetterController.text.trim() : null));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<ApplicationBloc, ApplicationState>(
        listenWhen: (prev, curr) => curr.status == ApplicationStatus.success || curr.status == ApplicationStatus.failure,
        listener: (context, state) {
          if (state.status == ApplicationStatus.success) {
            toastification.show(
              context: context,
              title: const Text('Application submitted! 🎉'),
              type: ToastificationType.success,
              style: ToastificationStyle.fillColored,
              autoCloseDuration: const Duration(seconds: 3),
            );
            if (context.canPop()) context.pop();
          } else if (state.status == ApplicationStatus.failure) {
            toastification.show(
              context: context,
              title: Text(state.errorMessage ?? 'Failed to apply'),
              type: ToastificationType.error,
              style: ToastificationStyle.fillColored,
              autoCloseDuration: const Duration(seconds: 3),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == ApplicationStatus.loading;
          return Scaffold(
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
              title: const CustomText(text: 'Apply for Vacancy', fontSize: 17, fontWeight: FontWeight.w800),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    'SEEKER: APPLY TO VACANCY',
                    style: TextStyle(fontSize: 10, color: AppColors.cF9A405, fontWeight: FontWeight.w700, letterSpacing: 1.2),
                  ),
                  2.g,
                  const Text(
                    'APPLICATION FORM',
                    style: TextStyle(fontSize: 11, color: AppColors.cF9A405, fontWeight: FontWeight.w700, letterSpacing: 1),
                  ),
                  8.g,
                  CustomText(text: widget.vacancy.title, fontSize: 22, fontWeight: FontWeight.w900),
                  6.g,
                  Text(
                    [widget.vacancy.employer?.city, widget.vacancy.workType].where((e) => e != null && e.isNotEmpty).join(' • '),
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  32.g,

                  // Cover Letter
                  Row(
                    children: [
                      const CustomText(text: 'Cover Letter', fontSize: 16, fontWeight: FontWeight.w700),
                      6.g,
                      Text('(Optional)', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                    ],
                  ),
                  6.g,
                  const CustomText(text: 'Why are you a good fit for this role?', fontSize: 13),
                  12.g,
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: _coverLetterController,
                            maxLines: 6,
                            maxLength: 1000,
                            decoration: const InputDecoration(
                              hintText: 'Explain why your skills and experience make you a great fit for this role...',
                              hintStyle: TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
                              border: InputBorder.none,
                              counterText: '',
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: Text('${_coverLetterController.text.length}/1000 characters', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
                        ),
                      ],
                    ),
                  ),
                  24.g,

                  // Attach Resume
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: const Color(0xFFFFF3D6), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.description_outlined, color: AppColors.cF9A405, size: 22),
                        ),
                        14.g,
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: 'Attach Resume', fontSize: 14, fontWeight: FontWeight.w700),
                              SizedBox(height: 4),
                              CustomText(text: 'Uses your default profile resume (PDF)', fontSize: 12),
                            ],
                          ),
                        ),
                        Switch(value: _attachResume, onChanged: (val) => setState(() => _attachResume = val), activeTrackColor: AppColors.cF9A405),
                      ],
                    ),
                  ),
                  20.g,

                  // Info note
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFFFFF8EC), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline_rounded, color: AppColors.cF9A405, size: 18),
                        12.g,
                        const Expanded(
                          child: Text(
                            'Your profile information and contact details will be shared with the hiring team along with this application.',
                            style: TextStyle(fontSize: 12, color: Color(0xFF8B6914), height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  40.g,

                  // Submit Button
                  isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.cF9A405))
                      : PrimaryButton(text: 'Submit Application  ▶', onPressed: _submit),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
