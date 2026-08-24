import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/bloc/employer_home_event.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/bloc/employer_home_state.dart';
import 'package:speed_staff_mobile/features/employer/profile/domain/repositories/employer_repository.dart';

class EmployerHomeBloc extends Bloc<EmployerHomeEvent, EmployerHomeState> {
  final EmployerRepository repository;

  EmployerHomeBloc(this.repository) : super(const EmployerHomeState()) {
    on<LoadDashboardStats>(_onLoadDashboardStats);
  }

  Future<void> _onLoadDashboardStats(LoadDashboardStats event, Emitter<EmployerHomeState> emit) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    final result = await repository.getDashboardStats();
    result.fold(
      (failure) {
        emit(state.copyWith(status: DashboardStatus.failure, errorMessage: failure.message));
      },
      (stats) {
        emit(state.copyWith(status: DashboardStatus.success, stats: stats));
      },
    );
  }
}
