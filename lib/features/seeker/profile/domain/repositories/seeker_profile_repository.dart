import 'package:dartz/dartz.dart';
import 'package:speed_staff_mobile/config/core/error/failures.dart';
import 'package:speed_staff_mobile/features/seeker/profile/domain/entities/seeker_profile.dart';
import 'package:speed_staff_mobile/features/seeker/profile/data/models/seeker_profile_model.dart';

abstract class SeekerProfileRepository {
  Future<Either<Failure, SeekerProfile>> getMyProfile();
  Future<Either<Failure, SeekerProfile>> updateProfile(Map<String, dynamic> data);
  Future<Either<Failure, SeekerExperience>> addExperience(Map<String, dynamic> data);
  Future<Either<Failure, void>> updateExperience(String id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteExperience(String id);
  Future<Either<Failure, SeekerDocument>> uploadDocument(String filePath, String title, String docType);
  Future<Either<Failure, void>> deleteDocument(String id);
  Future<Either<Failure, void>> addSkill(int skillId, String level);
  Future<Either<Failure, void>> removeSkill(int skillId);
  Future<Either<Failure, String>> uploadAvatar(String filePath);
  Future<Either<Failure, String>> uploadResume(String filePath);
  Future<Either<Failure, List<SkillModel>>> getAllSkills();
}
