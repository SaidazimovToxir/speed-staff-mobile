import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/seeker/applications/data/datasources/application_remote_datasource.dart';
import 'package:speed_staff_mobile/features/seeker/applications/presentation/bloc/application_state_event.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final ApplicationRemoteDataSource _dataSource;

  ApplicationBloc(this._dataSource) : super(const ApplicationState()) {
    on<ApplyForVacancy>(_onApply);
    on<LoadMyApplications>(_onLoadApplications);
    on<WithdrawApplication>(_onWithdraw);
  }

  Future<void> _onApply(ApplyForVacancy event, Emitter<ApplicationState> emit) async {
    emit(state.copyWith(status: ApplicationStatus.loading));
    try {
      await _dataSource.applyForVacancy(event.vacancyId, coverLetter: event.coverLetter);
      emit(state.copyWith(status: ApplicationStatus.success, successMessage: 'Application submitted successfully!'));
    } catch (e) {
      emit(state.copyWith(status: ApplicationStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadApplications(LoadMyApplications event, Emitter<ApplicationState> emit) async {
    emit(state.copyWith(status: ApplicationStatus.loading));
    try {
      final items = await _dataSource.getMyApplications();
      emit(state.copyWith(status: ApplicationStatus.success, applications: items));
    } catch (e) {
      emit(state.copyWith(status: ApplicationStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onWithdraw(WithdrawApplication event, Emitter<ApplicationState> emit) async {
    emit(state.copyWith(status: ApplicationStatus.loading));
    try {
      final msg = await _dataSource.withdrawApplication(event.applicationId);
      final updated = state.applications.where((a) => a.id != event.applicationId).toList();
      emit(state.copyWith(status: ApplicationStatus.success, applications: updated, successMessage: msg));
    } catch (e) {
      emit(state.copyWith(status: ApplicationStatus.failure, errorMessage: e.toString()));
    }
  }
}
