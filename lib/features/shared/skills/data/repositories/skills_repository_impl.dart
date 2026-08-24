import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/shared/skills/data/datasources/skills_remote_datasource.dart';
import 'package:speed_staff_mobile/features/shared/skills/data/models/skill_model.dart';
import 'package:speed_staff_mobile/features/shared/skills/domain/repositories/skills_repository.dart';

class SkillsRepositoryImpl implements SkillsRepository {
  final SkillsRemoteDataSource remoteDataSource;

  SkillsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<SkillModel>>> getSkills({String? q, String? category}) async {
    try {
      final result = await remoteDataSource.getSkills(q: q, category: category);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
