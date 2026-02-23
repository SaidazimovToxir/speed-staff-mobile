import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/tab_box/bloc/tab_box/tab_box_bloc.dart';
import '../../network/network.dart';

part 'utils_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => TabBoxBloc());
  sl.registerLazySingleton(() => TokenManager());

  await _registerUtilsDependencies();
}
