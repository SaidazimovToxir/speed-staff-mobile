import 'package:equatable/equatable.dart';
import 'package:speed_staff_mobile/features/seeker/profile/data/models/seeker_profile_model.dart';
import 'package:speed_staff_mobile/features/seeker/profile/domain/entities/seeker_profile.dart';

enum SeekerProfileStatus { initial, loading, success, failure }

class SeekerProfileState extends Equatable {
  final SeekerProfileStatus status;
  final SeekerProfile? profile;
  final String? errorMessage;
  final String? successMessage;
  final List<SkillModel> allSkills;

  const SeekerProfileState({
    this.status = SeekerProfileStatus.initial,
    this.profile,
    this.errorMessage,
    this.successMessage,
    this.allSkills = const [],
  });

  SeekerProfileState copyWith({
    SeekerProfileStatus? status,
    SeekerProfile? profile,
    String? errorMessage,
    String? successMessage,
    List<SkillModel>? allSkills,
  }) {
    return SeekerProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
      successMessage: successMessage,
      allSkills: allSkills ?? this.allSkills,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage, successMessage, allSkills];
}
