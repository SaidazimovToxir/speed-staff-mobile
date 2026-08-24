import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/config/core/usecases/usecase.dart';
import 'package:speed_staff_mobile/features/shared/skills/data/models/skill_model.dart';
import 'package:speed_staff_mobile/features/shared/skills/domain/repositories/skills_repository.dart';

class GetSkills implements UseCase<List<SkillModel>, GetSkillsParams> {
  final SkillsRepository repository;

  GetSkills(this.repository);

  @override
  Future<Either<Failure, List<SkillModel>>> call(GetSkillsParams params) async {
    return await repository.getSkills(q: params.q, category: params.category);
  }
}

class GetSkillsParams {
  final String? q;
  final String? category;

  GetSkillsParams({this.q, this.category});
}
