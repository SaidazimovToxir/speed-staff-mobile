import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/shared/locations/data/models/location_model.dart';

abstract class LocationRepository {
  Future<Either<Failure, List<RegionModel>>> getRegions();
}
