part of 'tab_box_bloc.dart';

@immutable
sealed class TabBoxEvent {}

class TabBoxInitialEvent extends TabBoxEvent {}

class TabBoxChangeIndexEvent extends TabBoxEvent {
  final int selectedIndex;
  TabBoxChangeIndexEvent(this.selectedIndex);
}

class TabNavigated extends TabBoxEvent {}
