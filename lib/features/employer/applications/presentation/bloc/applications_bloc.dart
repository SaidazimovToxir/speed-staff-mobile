import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_event.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_state.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/usecases/get_vacancy_applications.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/usecases/get_candidate_details.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/usecases/update_application_status.dart';

class ApplicationsBloc extends Bloc<ApplicationsEvent, ApplicationsState> {
  final GetVacancyApplications getVacancyApplications;
  final GetCandidateDetails getCandidateDetails;
  final UpdateApplicationStatus updateApplicationStatus;

  ApplicationsBloc({
    required this.getVacancyApplications,
    required this.getCandidateDetails,
    required this.updateApplicationStatus,
  }) : super(ApplicationsInitial()) {
    on<LoadVacancyApplications>(_onLoadApplications);
    on<LoadCandidateDetails>(_onLoadCandidateDetails);
    on<UpdateApplicationStatusEvent>(_onUpdateStatus);
  }

  Future<void> _onLoadApplications(
    LoadVacancyApplications event,
    Emitter<ApplicationsState> emit,
  ) async {
    emit(ApplicationsLoading());
    try {
      final result = await getVacancyApplications();
      result.fold(
        (failure) => emit(ApplicationsError(failure.message)),
        (candidates) => emit(ApplicationsLoaded(candidates)),
      );
    } catch (e) {
      emit(ApplicationsError(e.toString()));
    }
  }

  Future<void> _onLoadCandidateDetails(
    LoadCandidateDetails event,
    Emitter<ApplicationsState> emit,
  ) async {
    emit(ApplicationsLoading());
    try {
      final result = await getCandidateDetails(event.candidateId);
      result.fold(
        (failure) => emit(ApplicationsError(failure.message)),
        (candidate) => emit(CandidateDetailsLoaded(candidate)),
      );
    } catch (e) {
      emit(ApplicationsError(e.toString()));
    }
  }

  Future<void> _onUpdateStatus(
    UpdateApplicationStatusEvent event,
    Emitter<ApplicationsState> emit,
  ) async {
    emit(ApplicationsLoading());
    try {
      final result = await updateApplicationStatus(event.newStatus);
      result.fold(
        (failure) => emit(ApplicationsError(failure.message)),
        (status) => emit(ApplicationStatusUpdated(status)),
      );
    } catch (e) {
      emit(ApplicationsError(e.toString()));
    }
  }
}
