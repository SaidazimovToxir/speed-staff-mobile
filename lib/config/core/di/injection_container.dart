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
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_bloc.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/bloc/employer_home_bloc.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/data/datasources/employer_home_remote_datasource.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/domain/repositories/employer_home_repository.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/data/repositories/employer_home_repository_impl.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/domain/usecases/get_dashboard_stats.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/domain/usecases/get_recent_applications.dart';
import 'package:speed_staff_mobile/features/employer/applications/data/datasources/applications_remote_datasource.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/repositories/applications_repository.dart';
import 'package:speed_staff_mobile/features/employer/applications/data/repositories/applications_repository_impl.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/usecases/get_vacancy_applications.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/usecases/get_candidate_details.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/usecases/update_application_status.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/data/datasources/vacancies_remote_datasource.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/repositories/vacancies_repository.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/data/repositories/vacancies_repository_impl.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/usecases/get_my_vacancies.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/usecases/create_vacancy.dart';
import 'package:speed_staff_mobile/features/employer/profile/data/datasources/employer_profile_remote_datasource.dart';
import 'package:speed_staff_mobile/features/employer/profile/domain/repositories/employer_profile_repository.dart';
import 'package:speed_staff_mobile/features/employer/profile/data/repositories/employer_profile_repository_impl.dart';
import 'package:speed_staff_mobile/features/employer/profile/domain/usecases/get_employer_profile.dart';
import 'package:speed_staff_mobile/features/employer/profile/domain/usecases/update_employer_profile.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_bloc.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/bloc/vacancies_bloc.dart';

part 'utils_injection.dart';
part 'auth_injection.dart';
part 'employer_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => TabBoxBloc());
  sl.registerLazySingleton(() => TokenManager());

  await _registerUtilsDependencies();
  await _registerAuthDependencies();
  await _registerEmployerDependencies();
}
