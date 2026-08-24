import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/config/core/usecases/usecase.dart';
import 'package:speed_staff_mobile/features/shared/locations/domain/usecases/get_regions.dart';
import 'package:speed_staff_mobile/features/shared/locations/presentation/bloc/location_event.dart';
import 'package:speed_staff_mobile/features/shared/locations/presentation/bloc/location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetRegions getRegionsUseCase;

  LocationBloc(this.getRegionsUseCase) : super(const LocationState()) {
    on<FetchRegions>(_onFetchRegions);
  }

  Future<void> _onFetchRegions(FetchRegions event, Emitter<LocationState> emit) async {
    emit(state.copyWith(status: LocationStatus.loading));

    final result = await getRegionsUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(status: LocationStatus.failure, errorMessage: failure.message)),
      (regions) => emit(state.copyWith(status: LocationStatus.success, regions: regions)),
    );
  }
}
