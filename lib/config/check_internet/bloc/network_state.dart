part of 'network_bloc.dart';

class NetworkState extends Equatable {
  final StatusConnectivity? status;
  final bool? isAlertSet;

  const NetworkState({
    this.status,
    this.isAlertSet,
  });

  NetworkState copyWith({StatusConnectivity? status, bool? isAlertSet}) {
    return NetworkState(
      status: status ?? this.status,
      isAlertSet: isAlertSet ?? this.isAlertSet,
    );
  }

  @override
  List<Object?> get props => [status, isAlertSet];
}

enum StatusConnectivity { unknown, connected, disconnected }
