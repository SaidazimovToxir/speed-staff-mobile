import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_event.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_state.dart';
import 'package:speed_staff_mobile/features/employer/profile/domain/usecases/get_employer_profile.dart';
import 'package:speed_staff_mobile/features/employer/profile/domain/usecases/update_employer_profile.dart';

class EmployerProfileBloc extends Bloc<EmployerProfileEvent, EmployerProfileState> {
  final GetEmployerProfile getEmployerProfile;
  final UpdateEmployerProfileUseCase updateEmployerProfile;

  EmployerProfileBloc({
    required this.getEmployerProfile,
    required this.updateEmployerProfile,
  }) : super(EmployerProfileInitial()) {
    on<LoadEmployerProfile>(_onLoadProfile);
    on<UpdateEmployerProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadEmployerProfile event,
    Emitter<EmployerProfileState> emit,
  ) async {
    emit(EmployerProfileLoading());
    try {
      final result = await getEmployerProfile();
      result.fold(
        (failure) => emit(EmployerProfileError(failure.message)),
        (profileData) => emit(EmployerProfileLoaded(profileData)),
      );
    } catch (e) {
      emit(EmployerProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateEmployerProfile event,
    Emitter<EmployerProfileState> emit,
  ) async {
    emit(EmployerProfileLoading());
    try {
      // Map properties can be adapted later. Sending an empty map for demonstration purposes.
      final result = await updateEmployerProfile({});
      result.fold(
        (failure) => emit(EmployerProfileError(failure.message)),
        (_) => emit(EmployerProfileUpdated()),
      );
    } catch (e) {
      emit(EmployerProfileError(e.toString()));
    }
  }
}
