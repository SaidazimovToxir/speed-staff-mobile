import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/employer/profile/domain/repositories/employer_repository.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_event.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_state.dart';
import 'package:speed_staff_mobile/features/shared/upload/domain/usecases/upload_logo.dart';

class EmployerProfileBloc extends Bloc<EmployerProfileEvent, EmployerProfileState> {
  final EmployerRepository repository;
  final UploadLogo uploadLogoUseCase;

  EmployerProfileBloc({
    required this.repository,
    required this.uploadLogoUseCase,
  }) : super(const EmployerProfileState()) {
    on<LoadEmployerProfile>(_onLoadProfile);
    on<CreateEmployerProfile>(_onCreateProfile);
    on<UpdateEmployerProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(LoadEmployerProfile event, Emitter<EmployerProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await repository.getOwnProfile();
    result.fold(
      (failure) {
        if (failure.message == 'PROFILE_NOT_FOUND') {
          emit(state.copyWith(status: ProfileStatus.notFound));
        } else {
          emit(state.copyWith(status: ProfileStatus.failure, errorMessage: failure.message));
        }
      },
      (profile) {
        emit(state.copyWith(status: ProfileStatus.success, profile: profile));
      },
    );
  }

  Future<void> _onCreateProfile(CreateEmployerProfile event, Emitter<EmployerProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    
    final Map<String, dynamic> dataToSubmit = Map.from(event.data);

    if (event.logoPath != null) {
      final uploadResult = await uploadLogoUseCase(UploadLogoParams(filePath: event.logoPath!));
      if (uploadResult.isLeft()) {
        final failure = uploadResult.fold((l) => l, (r) => null);
        emit(state.copyWith(status: ProfileStatus.failure, errorMessage: "Logo upload failed: ${failure?.message}"));
        return;
      }
      dataToSubmit['logo_url'] = uploadResult.getOrElse(() => '');
    }

    final result = await repository.createProfile(dataToSubmit);
    result.fold(
      (failure) {
        emit(state.copyWith(status: ProfileStatus.failure, errorMessage: failure.message));
      },
      (profile) {
        emit(state.copyWith(status: ProfileStatus.success, profile: profile));
      },
    );
  }

  Future<void> _onUpdateProfile(UpdateEmployerProfile event, Emitter<EmployerProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    
    final Map<String, dynamic> dataToSubmit = Map.from(event.data);

    if (event.logoPath != null) {
      final uploadResult = await uploadLogoUseCase(UploadLogoParams(filePath: event.logoPath!));
      if (uploadResult.isLeft()) {
        final failure = uploadResult.fold((l) => l, (r) => null);
        emit(state.copyWith(status: ProfileStatus.failure, errorMessage: "Logo upload failed: ${failure?.message}"));
        return;
      }
      dataToSubmit['logo_url'] = uploadResult.getOrElse(() => '');
    }

    final result = await repository.updateProfile(dataToSubmit);
    result.fold(
      (failure) {
        emit(state.copyWith(status: ProfileStatus.failure, errorMessage: failure.message));
      },
      (profile) {
        emit(state.copyWith(status: ProfileStatus.success, profile: profile));
      },
    );
  }
}
