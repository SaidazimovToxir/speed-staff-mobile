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
import 'package:speed_staff_mobile/features/employer/employer_home/data/datasources/employer_home_remote_datasource.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/domain/repositories/employer_home_repository.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/data/repositories/employer_home_repository_impl.dart';


import 'package:speed_staff_mobile/features/employer/applications/data/datasources/applications_remote_datasource.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/repositories/applications_repository.dart';
import 'package:speed_staff_mobile/features/employer/applications/data/repositories/applications_repository_impl.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/usecases/get_vacancy_applications.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/usecases/get_application_detail.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/usecases/update_application_status.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/data/datasources/vacancies_remote_datasource.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/repositories/vacancy_repository.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/data/repositories/vacancy_repository_impl.dart';
import 'package:speed_staff_mobile/features/employer/profile/data/datasources/employer_remote_datasource.dart';
import 'package:speed_staff_mobile/features/employer/profile/domain/repositories/employer_repository.dart';
import 'package:speed_staff_mobile/features/employer/profile/data/repositories/employer_repository_impl.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_bloc.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/bloc/vacancies_bloc.dart';

// Shared
import 'package:speed_staff_mobile/features/shared/locations/data/datasources/location_remote_datasource.dart';
import 'package:speed_staff_mobile/features/shared/locations/data/repositories/location_repository_impl.dart';
import 'package:speed_staff_mobile/features/shared/locations/domain/repositories/location_repository.dart';
import 'package:speed_staff_mobile/features/shared/locations/domain/usecases/get_regions.dart';
import 'package:speed_staff_mobile/features/shared/locations/presentation/bloc/location_bloc.dart';

import 'package:speed_staff_mobile/features/shared/skills/data/datasources/skills_remote_datasource.dart';
import 'package:speed_staff_mobile/features/shared/skills/data/repositories/skills_repository_impl.dart';
import 'package:speed_staff_mobile/features/shared/skills/domain/repositories/skills_repository.dart';
import 'package:speed_staff_mobile/features/shared/skills/domain/usecases/get_skills.dart';
import 'package:speed_staff_mobile/features/shared/skills/presentation/bloc/skills_bloc.dart';

import 'package:speed_staff_mobile/features/shared/upload/data/datasources/upload_remote_datasource.dart';
import 'package:speed_staff_mobile/features/shared/upload/data/repositories/upload_repository_impl.dart';
import 'package:speed_staff_mobile/features/shared/upload/domain/repositories/upload_repository.dart';
import 'package:speed_staff_mobile/features/shared/upload/domain/usecases/upload_logo.dart';

import '../../../features/employer/applications/presentation/bloc/applications_bloc.dart';
import '../../../features/employer/employer_home/presentation/bloc/employer_home_bloc.dart';

// Seeker
import 'package:speed_staff_mobile/features/seeker/vacancies/data/datasources/vacancy_feed_remote_datasource.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/data/repositories/vacancy_feed_repository_impl.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/domain/repositories/vacancy_feed_repository.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/presentation/bloc/vacancy_feed_bloc.dart';
import 'package:speed_staff_mobile/features/seeker/applications/data/datasources/application_remote_datasource.dart';
import 'package:speed_staff_mobile/features/seeker/applications/presentation/bloc/application_bloc.dart';
import 'package:speed_staff_mobile/features/seeker/profile/data/datasources/seeker_profile_remote_datasource.dart';
import 'package:speed_staff_mobile/features/seeker/profile/data/datasources/seeker_profile_remote_datasource_impl.dart';
import 'package:speed_staff_mobile/features/seeker/profile/domain/repositories/seeker_profile_repository.dart';
import 'package:speed_staff_mobile/features/seeker/profile/data/repositories/seeker_profile_repository_impl.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_bloc.dart';

part 'utils_injection.dart';
part 'auth_injection.dart';
part 'employer_injection.dart';
part 'shared_injection.dart';
part 'seeker_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => TabBoxBloc());
  sl.registerLazySingleton(() => TokenManager());

  await _registerUtilsDependencies();
  await _registerAuthDependencies();
  await _registerEmployerDependencies();
  await _registerSharedDependencies();
  await _registerSeekerDependencies();
}
