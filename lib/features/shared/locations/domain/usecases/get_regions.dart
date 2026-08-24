import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/config/core/usecases/usecase.dart';
import 'package:speed_staff_mobile/features/shared/locations/data/models/location_model.dart';
import 'package:speed_staff_mobile/features/shared/locations/domain/repositories/location_repository.dart';

class GetRegions implements UseCase<List<RegionModel>, NoParams> {
  final LocationRepository repository;

  GetRegions(this.repository);

  @override
  Future<Either<Failure, List<RegionModel>>> call(NoParams params) async {
    return await repository.getRegions();
  }
}
