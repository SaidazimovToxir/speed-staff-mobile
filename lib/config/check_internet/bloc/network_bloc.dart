import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  StreamSubscription? subscription;

  NetworkBloc() : super(const NetworkState(status: StatusConnectivity.disconnected)) {
    _initConnectivity();

    subscription = Connectivity().onConnectivityChanged.listen((status) async {
      if (status.contains(ConnectivityResult.mobile) ||
          status.contains(ConnectivityResult.wifi) ||
          status.contains(ConnectivityResult.vpn)) {
        add(ConnectedEvent());
      } else {
        add(DisconnectedEvent());
      }
    });

    on<ConnectedEvent>((event, emit) {
      emit(state.copyWith(status: StatusConnectivity.connected));
    });

    on<DisconnectedEvent>((event, emit) {
      emit(state.copyWith(status: StatusConnectivity.disconnected));
    });
  }

  Future<void> _initConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
     print("nnn12 ${connectivityResult}");
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.vpn)) {
      add(ConnectedEvent());
    } else {
      add(DisconnectedEvent());
    }
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
