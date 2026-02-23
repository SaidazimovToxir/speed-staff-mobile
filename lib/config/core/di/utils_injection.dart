part of 'injection_container.dart';

Future<void> _registerUtilsDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // FCM Service
  // sl.registerLazySingleton(() => FCMService());
  // await sl<FCMService>().initialize();

  // Device Info
  // sl.registerLazySingleton(() => DeviceInfoPlugin());
  // sl.registerLazySingleton(() => DeviceInfoService(sl()));

  // Dio
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioClient(sl()));

  // await _registerHiveDependencies();
}
