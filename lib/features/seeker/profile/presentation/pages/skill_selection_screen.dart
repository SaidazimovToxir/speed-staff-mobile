import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_bloc.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_event.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_state.dart';

class SkillSelectionScreen extends StatefulWidget {
  const SkillSelectionScreen({super.key});
  @override
  State<SkillSelectionScreen> createState() => _SkillSelectionScreenState();
}

class _SkillSelectionScreenState extends State<SkillSelectionScreen> {
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SeekerProfileBloc>().add(const LoadAllSkills());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  static const Map<String, String> _levels = {'beginner': 'Boshlang\'ich', 'intermediate': 'O\'rta', 'expert': 'Ekspert'};

  bool _hasSkill(SeekerProfileState state, int skillId) {
    return state.profile?.skills.any((s) => s.skillId == skillId) ?? false;
  }

  String _skillLevel(SeekerProfileState state, int skillId) {
    final match = state.profile?.skills.where((s) => s.skillId == skillId);
    return match?.isNotEmpty == true ? match!.first.level : '';
  }

  void _showLevelPicker(BuildContext ctx, int skillId, bool isAdded) {
    if (isAdded) {
      // Remove skill
      ctx.read<SeekerProfileBloc>().add(RemoveSeekerSkill(skillId));
      return;
    }
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (bCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(text: 'Daraja tanlang', fontSize: 17, fontWeight: FontWeight.w800),
              16.g,
              ..._levels.entries.map(
                (e) => ListTile(
                  title: Text(e.value, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(e.key, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.cF9A405),
                  onTap: () {
                    Navigator.pop(bCtx);
                    ctx.read<SeekerProfileBloc>().add(AddSeekerSkill(skillId: skillId, level: e.key));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeekerProfileBloc, SeekerProfileState>(
      listener: (ctx, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!), backgroundColor: AppColors.cFF0000, behavior: SnackBarBehavior.floating));
          ctx.read<SeekerProfileBloc>().add(const ClearSeekerProfileMessages());
        }
      },
      builder: (context, state) {
        final isLoading = state.status == SeekerProfileStatus.loading;
        final allSkills = state.allSkills;
        final filtered = _searchQuery.isEmpty
            ? allSkills
            : allSkills
                  .where(
                    (s) =>
                        s.nameUz.toLowerCase().contains(_searchQuery) ||
                        s.nameRu.toLowerCase().contains(_searchQuery) ||
                        s.nameEn.toLowerCase().contains(_searchQuery),
                  )
                  .toList();

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
              onPressed: () {
                if (context.canPop()) context.pop();
              },
            ),
            title: const CustomText(text: 'Ko\'nikmalar', fontSize: 17, fontWeight: FontWeight.w800),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Ko\'nikma qidirish...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                ),
              ),
              if (isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator(color: AppColors.cF9A405)),
                )
              else if (allSkills.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('Ko\'nikmalar yuklanmadi', style: TextStyle(color: Colors.grey)),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      final skill = filtered[i];
                      final added = _hasSkill(state, skill.id);
                      final level = _skillLevel(state, skill.id);
                      final name = skill.nameUz.isNotEmpty ? skill.nameUz : (skill.nameRu.isNotEmpty ? skill.nameRu : skill.nameEn);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: added ? AppColors.cF9A405.withValues(alpha: 0.05) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: added ? AppColors.cF9A405.withValues(alpha: 0.3) : Colors.grey.shade200),
                        ),
                        child: ListTile(
                          title: Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                          subtitle: Text(skill.category, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          trailing: added
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _levels[level] ?? level,
                                      style: const TextStyle(fontSize: 11, color: AppColors.cF9A405, fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.check_circle_rounded, color: AppColors.cF9A405, size: 22),
                                  ],
                                )
                              : Icon(Icons.add_circle_outline_rounded, color: Colors.grey.shade400, size: 22),
                          onTap: () => _showLevelPicker(context, skill.id, added),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
