import 'package:equatable/equatable.dart';
import 'package:speed_staff_mobile/features/shared/locations/data/models/location_model.dart';

enum LocationStatus { initial, loading, success, failure }

class LocationState extends Equatable {
  final LocationStatus status;
  final List<RegionModel> regions;
  final String? errorMessage;

  const LocationState({
    this.status = LocationStatus.initial,
    this.regions = const [],
    this.errorMessage,
  });

  LocationState copyWith({
    LocationStatus? status,
    List<RegionModel>? regions,
    String? errorMessage,
  }) {
    return LocationState(
      status: status ?? this.status,
      regions: regions ?? this.regions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, regions, errorMessage];
}
