import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:speed_staff_mobile/features/shared/tab_box/bloc/tab_box/tab_box_bloc.dart';
import 'package:speed_staff_mobile/config/network/network.dart';

import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/repositories/auth_repository.dart';
import 'package:speed_staff_mobile/features/shared/auth/data/repositories/auth_repository_impl.dart';
import 'package:speed_staff_mobile/features/shared/auth/data/datasources/auth_remote_datasource.dart';
import 'package:speed_staff_mobile/features/shared/auth/data/datasources/auth_local_datasource.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/usecases/send_otp.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/usecases/verify_otp.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/usecases/register_finalize.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/usecases/check_auth_status.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/usecases/get_current_user.dart';
import 'package:speed_staff_mobile/features/shared/auth/domain/usecases/logout.dart';

part 'utils_injection.dart';
part 'auth_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => TabBoxBloc());
  sl.registerLazySingleton(() => TokenManager());

  await _registerUtilsDependencies();
  await _registerAuthDependencies();
}
