part of 'injection_container.dart';

Future<void> _registerSharedDependencies() async {
  // Remote Data Sources
  sl.registerLazySingleton<LocationRemoteDataSource>(() => LocationRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<SkillsRemoteDataSource>(() => SkillsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<UploadRemoteDataSource>(() => UploadRemoteDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl(sl()));
  sl.registerLazySingleton<SkillsRepository>(() => SkillsRepositoryImpl(sl()));
  sl.registerLazySingleton<UploadRepository>(() => UploadRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetRegions(sl()));
  sl.registerLazySingleton(() => GetSkills(sl()));
  sl.registerLazySingleton(() => UploadLogo(sl()));

  // Blocs
  sl.registerFactory(() => LocationBloc(sl()));
  sl.registerFactory(() => SkillsBloc(sl()));
}
