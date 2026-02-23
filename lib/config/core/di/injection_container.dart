import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../network/network.dart';

part 'utils_injection.dart';

final sl = GetIt.instance;
Future<void> init() async {
  sl.registerLazySingleton(() => TokenManager());

  await _registerUtilsDependencies();
}
