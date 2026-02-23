import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/tab_box/bloc/tab_box/tab_box_bloc.dart';

class MyBlocProviders {
  static List<BlocProvider<TabBoxBloc>> get providers {
    return [BlocProvider(create: (context) => TabBoxBloc())];
  }
}
