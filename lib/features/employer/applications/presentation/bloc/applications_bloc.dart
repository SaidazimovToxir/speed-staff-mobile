import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_event.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_state.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/usecases/get_vacancy_applications.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/usecases/get_application_detail.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/usecases/update_application_status.dart';

class ApplicationsBloc extends Bloc<ApplicationsEvent, ApplicationsState> {
  final GetVacancyApplications getVacancyApplications;
  final GetApplicationDetail getApplicationDetail;
  final UpdateApplicationStatus updateApplicationStatus;

  ApplicationsBloc({
    required this.getVacancyApplications,
    required this.getApplicationDetail,
    required this.updateApplicationStatus,
  }) : super(ApplicationsInitial()) {
    on<LoadVacancyApplications>(_onLoadApplications);
    on<LoadApplicationDetail>(_onLoadApplicationDetail);
    on<UpdateApplicationStatusEvent>(_onUpdateStatus);
  }

  Future<void> _onLoadApplications(
    LoadVacancyApplications event,
    Emitter<ApplicationsState> emit,
  ) async {
    emit(ApplicationsLoading());
    final result = await getVacancyApplications(
      GetVacancyApplicationsParams(
        vacancyId: event.vacancyId,
        status: event.status,
        page: event.page,
        limit: event.limit,
      ),
    );
    result.fold(
      (failure) => emit(ApplicationsError(failure.message)),
      (paginated) => emit(ApplicationsLoaded(
        paginated,
        vacancyId: event.vacancyId,
        activeStatus: event.status,
      )),
    );
  }

  Future<void> _onLoadApplicationDetail(
    LoadApplicationDetail event,
    Emitter<ApplicationsState> emit,
  ) async {
    emit(ApplicationsLoading());
    final result = await getApplicationDetail(event.applicationId);
    result.fold(
      (failure) => emit(ApplicationsError(failure.message)),
      (application) => emit(ApplicationDetailLoaded(application)),
    );
  }

  Future<void> _onUpdateStatus(
    UpdateApplicationStatusEvent event,
    Emitter<ApplicationsState> emit,
  ) async {
    // Joriy application ni saqlab, faqat updating state
    final currentState = state;
    if (currentState is ApplicationDetailLoaded) {
      emit(ApplicationStatusUpdating(currentState.application));
    }
    final result = await updateApplicationStatus(
      UpdateApplicationStatusParams(
        applicationId: event.applicationId,
        status: event.newStatus,
        employerNote: event.employerNote,
      ),
    );
    result.fold(
      (failure) => emit(ApplicationsError(failure.message)),
      (application) => emit(ApplicationStatusUpdated(application)),
    );
  }
}
