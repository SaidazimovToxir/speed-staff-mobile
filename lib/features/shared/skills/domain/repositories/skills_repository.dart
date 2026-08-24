import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/shared/skills/data/models/skill_model.dart';

abstract class SkillsRepository {
  Future<Either<Failure, List<SkillModel>>> getSkills({String? q, String? category});
}
