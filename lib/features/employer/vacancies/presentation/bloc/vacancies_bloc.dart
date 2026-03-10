import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/bloc/vacancies_event.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/bloc/vacancies_state.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/usecases/get_my_vacancies.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/usecases/create_vacancy.dart';

class VacanciesBloc extends Bloc<VacanciesEvent, VacanciesState> {
  final GetMyVacancies getMyVacancies;
  final CreateVacancy createVacancy;

  VacanciesBloc({
    required this.getMyVacancies,
    required this.createVacancy,
  }) : super(VacanciesInitial()) {
    on<LoadMyVacancies>(_onLoadMyVacancies);
    on<CreateVacancyEvent>(_onCreateVacancy);
  }

  Future<void> _onLoadMyVacancies(
    LoadMyVacancies event,
    Emitter<VacanciesState> emit,
  ) async {
    emit(VacanciesLoading());
    try {
      final result = await getMyVacancies();
      result.fold(
        (failure) => emit(VacanciesError(failure.message)),
        (vacancies) => emit(VacanciesLoaded(vacancies)),
      );
    } catch (e) {
      emit(VacanciesError(e.toString()));
    }
  }

  Future<void> _onCreateVacancy(
    CreateVacancyEvent event,
    Emitter<VacanciesState> emit,
  ) async {
    emit(VacanciesLoading());
    try {
      // Create empty map or fetch from event if it had fields. Currently it doesn't, so use empty.
      final result = await createVacancy({});
      result.fold(
        (failure) => emit(VacanciesError(failure.message)),
        (_) => emit(VacancyCreated()),
      );
    } catch (e) {
      emit(VacanciesError(e.toString()));
    }
  }
}
