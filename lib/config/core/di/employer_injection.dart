part of 'injection_container.dart';

Future<void> _registerEmployerDependencies() async {
  // --- EMPLOYER & DASHBOARD ---

  // Data Sources
  sl.registerLazySingleton<EmployerHomeRemoteDataSource>(
    () => EmployerHomeRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<EmployerRemoteDataSource>(
    () => EmployerRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<EmployerHomeRepository>(
    () => EmployerHomeRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<EmployerRepository>(
    () => EmployerRepositoryImpl(sl()),
  );

  // --- VACANCIES ---

  // Data Sources
  sl.registerLazySingleton<VacanciesRemoteDataSource>(
    () => VacanciesRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<VacanciesRepository>(
    () => VacanciesRepositoryImpl(sl()),
  );

  // --- APPLICATIONS (Real API implementation) ---
  sl.registerLazySingleton<ApplicationsRemoteDataSource>(
    () => ApplicationsRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ApplicationsRepository>(
    () => ApplicationsRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetVacancyApplications(sl()));
  sl.registerLazySingleton(() => GetApplicationDetail(sl()));
  sl.registerLazySingleton(() => UpdateApplicationStatus(sl()));

  // --- BLOCS ---
  sl.registerFactory(() => EmployerHomeBloc(sl()));
  sl.registerFactory(() => VacanciesBloc(sl()));
  sl.registerFactory(() => EmployerProfileBloc(
    repository: sl(),
    uploadLogoUseCase: sl(),
  ));

  sl.registerFactory(() => ApplicationsBloc(
    getVacancyApplications: sl(),
    getApplicationDetail: sl(),
    updateApplicationStatus: sl(),
  ));
}
