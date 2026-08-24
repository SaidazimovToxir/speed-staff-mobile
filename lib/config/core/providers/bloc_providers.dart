import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/shared/tab_box/bloc/tab_box/tab_box_bloc.dart';
import 'package:speed_staff_mobile/features/user/user_home/presentation/bloc/home_bloc.dart';
import 'package:speed_staff_mobile/features/user/user_home/presentation/bloc/restaurant_detail_bloc.dart';
import 'package:speed_staff_mobile/features/shared/notifications/presentation/bloc/notification_bloc.dart';
import 'package:speed_staff_mobile/features/user/user_home/data/repositories/mock_home_repository.dart';
import 'package:speed_staff_mobile/features/shared/notifications/data/repositories/mock_notification_repository.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_event.dart';
import 'package:speed_staff_mobile/config/core/di/injection_container.dart';

import 'package:speed_staff_mobile/features/employer/employer_home/presentation/bloc/employer_home_bloc.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/bloc/employer_home_event.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/bloc/vacancies_bloc.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/bloc/vacancies_event.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_bloc.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/bloc/applications_event.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_bloc.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_event.dart';

import 'package:speed_staff_mobile/features/shared/locations/presentation/bloc/location_bloc.dart';
import 'package:speed_staff_mobile/features/shared/locations/presentation/bloc/location_event.dart';
import 'package:speed_staff_mobile/features/shared/skills/presentation/bloc/skills_bloc.dart';
import 'package:speed_staff_mobile/features/shared/skills/presentation/bloc/skills_event.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_bloc.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_event.dart';

class MyBlocProviders {
  static final MockHomeRepository _homeRepo = MockHomeRepository();
  static final MockNotificationRepository _notifRepo = MockNotificationRepository();

  static List<BlocProvider> get providers {
    return [
      BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()..add(CheckAuthStatusEvent())),
      BlocProvider<TabBoxBloc>(create: (context) => TabBoxBloc()),
      BlocProvider<HomeBloc>(create: (context) => HomeBloc(repository: _homeRepo)..add(LoadHomeData())),
      BlocProvider<RestaurantDetailBloc>(create: (context) => RestaurantDetailBloc(repository: _homeRepo)),
      BlocProvider<NotificationBloc>(create: (context) => NotificationBloc(repository: _notifRepo)..add(LoadNotifications())),
      BlocProvider<EmployerHomeBloc>(create: (context) => sl<EmployerHomeBloc>()..add(LoadDashboardStats())),
      BlocProvider<VacanciesBloc>(create: (context) => sl<VacanciesBloc>()..add(const LoadMyVacancies())),
      BlocProvider<ApplicationsBloc>(create: (context) => sl<ApplicationsBloc>()..add(const LoadVacancyApplications('1'))),
      BlocProvider<EmployerProfileBloc>(create: (context) => sl<EmployerProfileBloc>()..add(LoadEmployerProfile())),
      BlocProvider<LocationBloc>(create: (context) => sl<LocationBloc>()..add(const FetchRegions())),
      BlocProvider<SkillsBloc>(create: (context) => sl<SkillsBloc>()..add(const FetchSkills())),
      BlocProvider<SeekerProfileBloc>(create: (context) => sl<SeekerProfileBloc>()..add(const LoadSeekerProfile())),
    ];
  }
}
