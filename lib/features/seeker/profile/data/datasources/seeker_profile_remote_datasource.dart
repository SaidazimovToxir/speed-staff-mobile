import 'package:speed_staff_mobile/features/seeker/profile/data/models/seeker_profile_model.dart';

abstract class SeekerProfileRemoteDataSource {
  Future<SeekerProfileModel> getMyProfile();
  Future<SeekerProfileModel> updateProfile(Map<String, dynamic> data);
  Future<SeekerExperienceModel> addExperience(Map<String, dynamic> data);
  Future<void> updateExperience(String id, Map<String, dynamic> data);
  Future<void> deleteExperience(String id);
  Future<SeekerDocumentModel> uploadDocument(String filePath, String title, String docType);
  Future<void> deleteDocument(String id);
  Future<void> addSkill(int skillId, String level);
  Future<void> removeSkill(int skillId);
  Future<String> uploadAvatar(String filePath);
  Future<String> uploadResume(String filePath);
  Future<List<SkillModel>> getAllSkills();
}
