import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/seeker/profile/domain/repositories/seeker_profile_repository.dart';
import 'seeker_profile_event.dart';
import 'seeker_profile_state.dart';

class SeekerProfileBloc extends Bloc<SeekerProfileEvent, SeekerProfileState> {
  final SeekerProfileRepository repository;

  SeekerProfileBloc(this.repository) : super(const SeekerProfileState()) {
    on<LoadSeekerProfile>(_onLoadProfile);
    on<UpdateSeekerProfile>(_onUpdateProfile);
    on<AddSeekerSkill>(_onAddSkill);
    on<RemoveSeekerSkill>(_onRemoveSkill);
    on<LoadAllSkills>(_onLoadAllSkills);
    on<AddSeekerExperience>(_onAddExperience);
    on<EditSeekerExperience>(_onEditExperience);
    on<DeleteSeekerExperience>(_onDeleteExperience);
    on<UploadSeekerDocument>(_onUploadDocument);
    on<DeleteSeekerDocument>(_onDeleteDocument);
    on<UploadSeekerAvatar>(_onUploadAvatar);
    on<UploadSeekerResume>(_onUploadResume);
    on<ClearSeekerProfileMessages>(_onClearMessages);
  }

  Future<void> _onLoadProfile(LoadSeekerProfile event, Emitter<SeekerProfileState> emit) async {
    emit(state.copyWith(status: SeekerProfileStatus.loading));
    final result = await repository.getMyProfile();
    result.fold(
      (f) => emit(state.copyWith(status: SeekerProfileStatus.failure, errorMessage: f.message)),
      (profile) => emit(state.copyWith(status: SeekerProfileStatus.success, profile: profile)),
    );
  }

  Future<void> _onUpdateProfile(UpdateSeekerProfile event, Emitter<SeekerProfileState> emit) async {
    emit(state.copyWith(status: SeekerProfileStatus.loading));
    final result = await repository.updateProfile(event.data);
    result.fold(
      (f) => emit(state.copyWith(status: SeekerProfileStatus.failure, errorMessage: f.message)),
      (profile) => emit(state.copyWith(status: SeekerProfileStatus.success, profile: profile, successMessage: 'Profil yangilandi')),
    );
  }

  Future<void> _onAddSkill(AddSeekerSkill event, Emitter<SeekerProfileState> emit) async {
    emit(state.copyWith(status: SeekerProfileStatus.loading));
    final result = await repository.addSkill(event.skillId, event.level);
    result.fold(
      (f) => emit(state.copyWith(status: SeekerProfileStatus.failure, errorMessage: f.message)),
      (_) {
        add(const LoadSeekerProfile());
        emit(state.copyWith(status: SeekerProfileStatus.success, successMessage: 'Ko\'nikma qo\'shildi'));
      },
    );
  }

  Future<void> _onRemoveSkill(RemoveSeekerSkill event, Emitter<SeekerProfileState> emit) async {
    emit(state.copyWith(status: SeekerProfileStatus.loading));
    final result = await repository.removeSkill(event.skillId);
    result.fold(
      (f) => emit(state.copyWith(status: SeekerProfileStatus.failure, errorMessage: f.message)),
      (_) {
        add(const LoadSeekerProfile());
        emit(state.copyWith(status: SeekerProfileStatus.success, successMessage: 'Ko\'nikma o\'chirildi'));
      },
    );
  }

  Future<void> _onLoadAllSkills(LoadAllSkills event, Emitter<SeekerProfileState> emit) async {
    final result = await repository.getAllSkills();
    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (skills) => emit(state.copyWith(allSkills: skills)),
    );
  }

  Future<void> _onAddExperience(AddSeekerExperience event, Emitter<SeekerProfileState> emit) async {
    emit(state.copyWith(status: SeekerProfileStatus.loading));
    final result = await repository.addExperience(event.data);
    result.fold(
      (f) => emit(state.copyWith(status: SeekerProfileStatus.failure, errorMessage: f.message)),
      (_) {
        add(const LoadSeekerProfile());
        emit(state.copyWith(status: SeekerProfileStatus.success, successMessage: 'Tajriba qo\'shildi'));
      },
    );
  }

  Future<void> _onEditExperience(EditSeekerExperience event, Emitter<SeekerProfileState> emit) async {
    emit(state.copyWith(status: SeekerProfileStatus.loading));
    final result = await repository.updateExperience(event.id, event.data);
    result.fold(
      (f) => emit(state.copyWith(status: SeekerProfileStatus.failure, errorMessage: f.message)),
      (_) {
        add(const LoadSeekerProfile());
        emit(state.copyWith(status: SeekerProfileStatus.success, successMessage: 'Tajriba yangilandi'));
      },
    );
  }

  Future<void> _onDeleteExperience(DeleteSeekerExperience event, Emitter<SeekerProfileState> emit) async {
    emit(state.copyWith(status: SeekerProfileStatus.loading));
    final result = await repository.deleteExperience(event.id);
    result.fold(
      (f) => emit(state.copyWith(status: SeekerProfileStatus.failure, errorMessage: f.message)),
      (_) {
        add(const LoadSeekerProfile());
        emit(state.copyWith(status: SeekerProfileStatus.success, successMessage: 'Tajriba o\'chirildi'));
      },
    );
  }

  Future<void> _onUploadDocument(UploadSeekerDocument event, Emitter<SeekerProfileState> emit) async {
    emit(state.copyWith(status: SeekerProfileStatus.loading));
    final result = await repository.uploadDocument(event.filePath, event.title, event.docType);
    result.fold(
      (f) => emit(state.copyWith(status: SeekerProfileStatus.failure, errorMessage: f.message)),
      (_) {
        add(const LoadSeekerProfile());
        emit(state.copyWith(status: SeekerProfileStatus.success, successMessage: 'Hujjat yuklandi'));
      },
    );
  }

  Future<void> _onDeleteDocument(DeleteSeekerDocument event, Emitter<SeekerProfileState> emit) async {
    emit(state.copyWith(status: SeekerProfileStatus.loading));
    final result = await repository.deleteDocument(event.id);
    result.fold(
      (f) => emit(state.copyWith(status: SeekerProfileStatus.failure, errorMessage: f.message)),
      (_) {
        add(const LoadSeekerProfile());
        emit(state.copyWith(status: SeekerProfileStatus.success, successMessage: 'Hujjat o\'chirildi'));
      },
    );
  }

  Future<void> _onUploadAvatar(UploadSeekerAvatar event, Emitter<SeekerProfileState> emit) async {
    emit(state.copyWith(status: SeekerProfileStatus.loading));
    final result = await repository.uploadAvatar(event.filePath);
    result.fold(
      (f) => emit(state.copyWith(status: SeekerProfileStatus.failure, errorMessage: f.message)),
      (_) {
        add(const LoadSeekerProfile());
        emit(state.copyWith(status: SeekerProfileStatus.success, successMessage: 'Rasm yangilandi'));
      },
    );
  }

  Future<void> _onUploadResume(UploadSeekerResume event, Emitter<SeekerProfileState> emit) async {
    emit(state.copyWith(status: SeekerProfileStatus.loading));
    final result = await repository.uploadResume(event.filePath);
    result.fold(
      (f) => emit(state.copyWith(status: SeekerProfileStatus.failure, errorMessage: f.message)),
      (_) {
        add(const LoadSeekerProfile());
        emit(state.copyWith(status: SeekerProfileStatus.success, successMessage: 'Rezyume yuklandi'));
      },
    );
  }

  void _onClearMessages(ClearSeekerProfileMessages event, Emitter<SeekerProfileState> emit) {
    emit(SeekerProfileState(status: state.status, profile: state.profile, allSkills: state.allSkills));
  }
}
