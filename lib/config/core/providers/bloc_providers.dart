import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/tab_box/bloc/tab_box/tab_box_bloc.dart';
import 'package:speed_staff_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:speed_staff_mobile/features/home/presentation/bloc/restaurant_detail_bloc.dart';
import 'package:speed_staff_mobile/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:speed_staff_mobile/features/home/data/repositories/mock_home_repository.dart';
import 'package:speed_staff_mobile/features/notifications/data/repositories/mock_notification_repository.dart';

class MyBlocProviders {
  static final MockHomeRepository _homeRepo = MockHomeRepository();
  static final MockNotificationRepository _notifRepo = MockNotificationRepository();

  static List<BlocProvider> get providers {
    return [
      BlocProvider<TabBoxBloc>(create: (context) => TabBoxBloc()),
      BlocProvider<HomeBloc>(create: (context) => HomeBloc(repository: _homeRepo)..add(LoadHomeData())),
      BlocProvider<RestaurantDetailBloc>(create: (context) => RestaurantDetailBloc(repository: _homeRepo)),
      BlocProvider<NotificationBloc>(create: (context) => NotificationBloc(repository: _notifRepo)..add(LoadNotifications())),
    ];
  }
}
