import 'package:equatable/equatable.dart';
import 'package:speed_staff_mobile/features/shared/skills/data/models/skill_model.dart';

enum SkillsStatus { initial, loading, success, failure }

class SkillsState extends Equatable {
  final SkillsStatus status;
  final List<SkillModel> skills;
  final String? errorMessage;

  const SkillsState({
    this.status = SkillsStatus.initial,
    this.skills = const [],
    this.errorMessage,
  });

  SkillsState copyWith({
    SkillsStatus? status,
    List<SkillModel>? skills,
    String? errorMessage,
  }) {
    return SkillsState(
      status: status ?? this.status,
      skills: skills ?? this.skills,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, skills, errorMessage];
}
