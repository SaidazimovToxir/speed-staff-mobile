import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:speed_staff_mobile/config/config.dart';

part 'tab_box_event.dart';

part 'tab_box_state.dart';

class TabBoxBloc extends Bloc<TabBoxEvent, TabBoxState> {
  TabBoxBloc() : super(TabBoxState()) {
    on<TabBoxChangeIndexEvent>((event, emit) {
      emit(state.copyWith(selectedIndex: event.selectedIndex));
    });
  }
}

// class TabBoxBloc extends Bloc<TabBoxEvent, TabBoxState> {
//   TabBoxBloc() : super(TabBoxState()) {
//     on<TabNavigated>((event, emit) {
//       emit(state.copyWith(hasNavigated: true));
//     });
//   }
// }
