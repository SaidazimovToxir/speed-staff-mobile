import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_bloc.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_event.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_state.dart';
import 'package:speed_staff_mobile/features/seeker/profile/domain/entities/seeker_profile.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_event.dart';

class SeekerProfileScreen extends StatefulWidget {
  const SeekerProfileScreen({super.key});

  @override
  State<SeekerProfileScreen> createState() => _SeekerProfileScreenState();
}

class _SeekerProfileScreenState extends State<SeekerProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SeekerProfileBloc>().add(const LoadSeekerProfile());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cF6F6F6,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const CustomText(text: 'Mening profilim', fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.black),
        centerTitle: false,
        actions: [
          CustomIconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.cF9A405),
            onPressed: () => context.push(RouteNames.editSeekerProfile),
          ),
          CustomIconButton(
            icon: const Icon(Icons.logout_outlined, color: AppColors.cFF0000),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<SeekerProfileBloc, SeekerProfileState>(
        builder: (context, state) {
          if (state.status == SeekerProfileStatus.loading && state.profile == null) {
            return const Center(child: CircularProgressIndicator(color: AppColors.cF9A405));
          }
          if (state.status == SeekerProfileStatus.failure && state.profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 64, color: Colors.grey),
                  16.g,
                  Text(state.errorMessage ?? 'Xatolik', style: const TextStyle(color: Colors.grey)),
                  16.g,
                  TextButton(
                    onPressed: () => context.read<SeekerProfileBloc>().add(const LoadSeekerProfile()),
                    child: const Text(
                      'Qayta urinish',
                      style: TextStyle(color: AppColors.cF9A405, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            );
          }

          final profile = state.profile;
          if (profile == null) return const Center(child: Text('Profil topilmadi'));

          return RefreshIndicator(
            color: AppColors.cF9A405,
            onRefresh: () async => context.read<SeekerProfileBloc>().add(const LoadSeekerProfile()),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(profile),
                  24.g,
                  if (profile.bio != null && profile.bio!.isNotEmpty) ...[_sectionTitle('BIO'), 12.g, _buildBio(profile.bio), 24.g],
                  _sectionTitleWithAction('KO\'NIKMALAR', '+ Qo\'shish', () => context.push(RouteNames.seekerSkills)),
                  12.g,
                  _buildSkills(profile),
                  24.g,
                  _sectionTitleWithAction('TAJRIBA', '+ Qo\'shish', () => context.push(RouteNames.addExperience)),
                  12.g,
                  _buildExperiences(context, profile),
                  24.g,
                  _sectionTitleWithAction('HUJJATLAR', 'Boshqarish', () => context.push(RouteNames.seekerDocuments)),
                  12.g,
                  _buildDocuments(profile),
                  32.g,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(SeekerProfile profile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
            child: profile.avatarUrl == null ? const Icon(Icons.person, size: 46, color: Colors.grey) : null,
          ),
          14.g,
          CustomText(text: profile.fullName.isNotEmpty ? profile.fullName : 'Noma\'lum', fontSize: 20, fontWeight: FontWeight.w800),
          6.g,
          if (profile.city != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                4.g,
                CustomText(text: [profile.city, profile.district].whereType<String>().join(', '), fontSize: 13, color: Colors.grey),
              ],
            ),
          12.g,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _statChip('${profile.experienceYears} yil', Icons.work_outline_rounded),
              _statChip('${profile.rating.toStringAsFixed(1)} ★', Icons.star_rounded, color: AppColors.cF9A405),
              _statChip(profile.isAvailable ? 'Mavjud' : 'Band', Icons.circle, color: profile.isAvailable ? Colors.green : Colors.grey),
            ],
          ),
          if (profile.expectedSalaryMin != null || profile.expectedSalaryMax != null) ...[
            12.g,
            CustomText(
              text: _salaryText(profile.expectedSalaryMin, profile.expectedSalaryMax),
              fontSize: 13,
              color: Colors.green.shade700,
              fontWeight: FontWeight.w700,
            ),
          ],
        ],
      ),
    );
  }

  String _salaryText(int? min, int? max) {
    if (min != null && max != null) return '${_fw(min)} – ${_fw(max)} so\'m';
    if (min != null) return '${_fw(min)} so\'mdan';
    if (max != null) return '${_fw(max)} so\'mgacha';
    return '';
  }

  String _fw(int v) => v.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ' ');

  Widget _statChip(String label, IconData icon, {Color color = Colors.blueGrey}) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        4.g,
        CustomText(text: label, fontSize: 12, fontWeight: FontWeight.w600, color: color),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.blueGrey.shade300, letterSpacing: 1.2),
    );
  }

  Widget _sectionTitleWithAction(String title, String action, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _sectionTitle(title),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.cF9A405),
          ),
        ),
      ],
    );
  }

  Widget _buildBio(String? bio) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Text(bio ?? '', style: TextStyle(fontSize: 14, height: 1.5, color: Colors.blueGrey.shade700)),
    );
  }

  Widget _buildSkills(SeekerProfile profile) {
    if (profile.skills.isEmpty) {
      return GestureDetector(
        onTap: () => context.push(RouteNames.seekerSkills),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Row(
            children: [
              Icon(Icons.add_circle_outline_rounded, color: AppColors.cF9A405),
              SizedBox(width: 8),
              Text('Ko\'nikma qo\'shish', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: profile.skills.map((s) {
        final name = s.nameUz.isNotEmpty ? s.nameUz : (s.nameRu.isNotEmpty ? s.nameRu : s.nameEn);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.cF9A405.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.cF9A405.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.cF9A405),
              ),
              const SizedBox(width: 6),
              Text('• ${s.level}', style: TextStyle(fontSize: 11, color: AppColors.cF9A405.withValues(alpha: 0.7))),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExperiences(BuildContext context, SeekerProfile profile) {
    if (profile.experiences.isEmpty) {
      return GestureDetector(
        onTap: () => context.push(RouteNames.addExperience),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Row(
            children: [
              Icon(Icons.add_circle_outline_rounded, color: AppColors.cF9A405),
              SizedBox(width: 8),
              Text('Tajriba qo\'shish', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }
    return Column(
      children: profile.experiences
          .map(
            (exp) => GestureDetector(
              onTap: () => context.push(RouteNames.addExperience, extra: exp),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(color: Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.corporate_fare_rounded, color: Colors.blueGrey),
                    ),
                    12.g,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: exp.companyName, fontSize: 14, fontWeight: FontWeight.w700),
                          3.g,
                          CustomText(text: exp.position, fontSize: 13, color: Colors.blueGrey),
                          3.g,
                          CustomText(text: '${exp.startDate} – ${exp.currentlyWorkHere ? 'Hozir' : (exp.endDate ?? '')}', fontSize: 12, color: Colors.grey),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 18),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildDocuments(SeekerProfile profile) {
    if (profile.documents.isEmpty) {
      return GestureDetector(
        onTap: () => context.push(RouteNames.seekerDocuments),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Row(
            children: [
              Icon(Icons.add_circle_outline_rounded, color: AppColors.cF9A405),
              SizedBox(width: 8),
              Text('Hujjat yuklash', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: profile.documents
          .map(
            (doc) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(doc.fileUrl?.endsWith('.pdf') == true ? Icons.picture_as_pdf_rounded : Icons.image_rounded, size: 16, color: AppColors.cF9A405),
                  6.g,
                  Expanded(
                    child: CustomText(text: doc.title, fontSize: 13, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis, maxLines: 2),
                  ),
                  if (doc.isVerified) ...[4.g, const Icon(Icons.verified_rounded, size: 14, color: Colors.green)],
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
