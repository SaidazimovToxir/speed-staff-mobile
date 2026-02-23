part of 'network_bloc.dart';

sealed class NetworkEvent {}

class ConnectedEvent extends NetworkEvent {}
class DisconnectedEvent extends NetworkEvent {}
