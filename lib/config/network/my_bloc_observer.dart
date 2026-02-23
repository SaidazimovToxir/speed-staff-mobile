import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    developer.log("Created: ${bloc.runtimeType}", name: "bloc", level: 800);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    developer.log("Event: $event", name: "bloc", level: 800);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    developer.log("Transition: $transition", name: "bloc", level: 800);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    developer.log("Bloc Error: $error", name: "bloc", level: 1000, error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    developer.log("State Change: $change", name: "bloc", level: 800);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    developer.log("Closed: ${bloc.runtimeType}", name: "bloc", level: 800);
  }
}
