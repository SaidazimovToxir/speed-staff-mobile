part of 'injection_container.dart';

Future<void> _registerSeekerDependencies() async {
  // Data Sources
  sl.registerLazySingleton<VacancyFeedRemoteDataSource>(
    () => VacancyFeedRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ApplicationRemoteDataSource>(
    () => ApplicationRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SeekerProfileRemoteDataSource>(
    () => SeekerProfileRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<VacancyFeedRepository>(
    () => VacancyFeedRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<SeekerProfileRepository>(
    () => SeekerProfileRepositoryImpl(sl()),
  );

  // BLoCs (factory so each screen gets a fresh instance)
  sl.registerFactory(() => VacancyFeedBloc(sl()));
  sl.registerFactory(() => ApplicationBloc(sl()));
  sl.registerFactory(() => SeekerProfileBloc(sl()));
}
