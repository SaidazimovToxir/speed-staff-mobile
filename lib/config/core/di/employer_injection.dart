part of 'injection_container.dart';

Future<void> _registerEmployerDependencies() async {
  // Data Sources
  sl.registerLazySingleton<EmployerHomeRemoteDataSource>(
    () => EmployerHomeMockDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<EmployerHomeRepository>(
    () => EmployerHomeRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetDashboardStats(sl()));
  sl.registerLazySingleton(() => GetRecentApplications(sl()));

  // Applications dependencies
  sl.registerLazySingleton<ApplicationsRemoteDataSource>(
    () => ApplicationsMockDataSourceImpl(),
  );

  sl.registerLazySingleton<ApplicationsRepository>(
    () => ApplicationsRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetVacancyApplications(sl()));
  sl.registerLazySingleton(() => GetCandidateDetails(sl()));
  sl.registerLazySingleton(() => UpdateApplicationStatus(sl()));

  // Vacancies dependencies
  sl.registerLazySingleton<VacanciesRemoteDataSource>(
    () => VacanciesMockDataSourceImpl(),
  );

  sl.registerLazySingleton<VacanciesRepository>(
    () => VacanciesRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetMyVacancies(sl()));
  sl.registerLazySingleton(() => CreateVacancy(sl()));

  // Profile dependencies
  sl.registerLazySingleton<EmployerProfileRemoteDataSource>(
    () => EmployerProfileMockDataSourceImpl(),
  );

  sl.registerLazySingleton<EmployerProfileRepository>(
    () => EmployerProfileRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetEmployerProfile(sl()));
  sl.registerLazySingleton(() => UpdateEmployerProfileUseCase(sl()));

  // Blocs
  sl.registerFactory(() => EmployerHomeBloc(
        getDashboardStats: sl(),
        getRecentApplications: sl(),
      ));
  sl.registerFactory(() => VacanciesBloc(
        getMyVacancies: sl(),
        createVacancy: sl(),
      ));
  sl.registerFactory(() => ApplicationsBloc(
        getVacancyApplications: sl(),
        getCandidateDetails: sl(),
        updateApplicationStatus: sl(),
      ));
  sl.registerFactory(() => EmployerProfileBloc(
        getEmployerProfile: sl(),
        updateEmployerProfile: sl(),
      ));
}
