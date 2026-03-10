import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/bloc/employer_home_event.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/bloc/employer_home_state.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/domain/usecases/get_dashboard_stats.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/domain/usecases/get_recent_applications.dart';

class EmployerHomeBloc extends Bloc<EmployerHomeEvent, EmployerHomeState> {
  final GetDashboardStats getDashboardStats;
  final GetRecentApplications getRecentApplications;

  EmployerHomeBloc({
    required this.getDashboardStats,
    required this.getRecentApplications,
  }) : super(EmployerHomeInitial()) {
    on<LoadEmployerDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadEmployerDashboard event,
    Emitter<EmployerHomeState> emit,
  ) async {
    emit(EmployerHomeLoading());
    try {
      final statsResult = await getDashboardStats();
      final applicationsResult = await getRecentApplications();

      statsResult.fold(
        (failure) => emit(EmployerHomeError(failure.message)),
        (stats) {
          applicationsResult.fold(
            (failure) => emit(EmployerHomeError(failure.message)),
            (applications) => emit(EmployerHomeLoaded(stats: stats, recentApplications: applications)),
          );
        },
      );
    } catch (e) {
      emit(EmployerHomeError(e.toString()));
    }
  }
}
