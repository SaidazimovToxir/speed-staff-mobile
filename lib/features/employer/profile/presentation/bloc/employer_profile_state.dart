import 'package:speed_staff_mobile/features/employer/profile/domain/entities/employer_profile.dart';

enum ProfileStatus { initial, loading, success, notFound, failure }

class EmployerProfileState {
  final ProfileStatus status;
  final EmployerProfile? profile;
  final String? errorMessage;

  const EmployerProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  EmployerProfileState copyWith({
    ProfileStatus? status,
    EmployerProfile? profile,
    String? errorMessage,
  }) {
    return EmployerProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
