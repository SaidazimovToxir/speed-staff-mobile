import 'package:equatable/equatable.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class FetchRegions extends LocationEvent {
  const FetchRegions();
}
