import 'dart:io';
import 'package:dio/dio.dart';
import 'package:speed_staff_mobile/config/core/constants/api_constants.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/config/network/dio_client.dart';
import 'package:speed_staff_mobile/features/seeker/profile/data/datasources/seeker_profile_remote_datasource.dart';
import 'package:speed_staff_mobile/features/seeker/profile/data/models/seeker_profile_model.dart';

class SeekerProfileRemoteDataSourceImpl implements SeekerProfileRemoteDataSource {
  final DioClient _dioClient;
  SeekerProfileRemoteDataSourceImpl(this._dioClient);

  String _extractError(DioException e) {
    if (e.response?.data is Map<String, dynamic>) {
      final data = e.response!.data as Map<String, dynamic>;
      return data['message']?.toString() ?? data['error_code']?.toString() ?? e.message ?? 'Xatolik';
    }
    return e.message ?? 'Xatolik';
  }

  @override
  Future<SeekerProfileModel> getMyProfile() async {
    try {
      final resp = await _dioClient.get(ApiConstants.seekerProfile);
      return SeekerProfileModel.fromJson(resp.data['data'] ?? resp.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw ServerException('PROFILE_NOT_FOUND');
      throw ServerException(_extractError(e));
    }
  }

  @override
  Future<SeekerProfileModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final resp = await _dioClient.put(ApiConstants.seekerProfile, data: data);
      return SeekerProfileModel.fromJson(resp.data['data'] ?? resp.data);
    } on DioException catch (e) {
      throw ServerException(_extractError(e));
    }
  }

  @override
  Future<SeekerExperienceModel> addExperience(Map<String, dynamic> data) async {
    try {
      final resp = await _dioClient.post(ApiConstants.seekerExperiences, data: data);
      return SeekerExperienceModel.fromJson(resp.data['data'] ?? resp.data);
    } on DioException catch (e) {
      throw ServerException(_extractError(e));
    }
  }

  @override
  Future<void> updateExperience(String id, Map<String, dynamic> data) async {
    try {
      await _dioClient.put('${ApiConstants.seekerExperiences}/$id', data: data);
    } on DioException catch (e) {
      throw ServerException(_extractError(e));
    }
  }

  @override
  Future<void> deleteExperience(String id) async {
    try {
      await _dioClient.delete('${ApiConstants.seekerExperiences}/$id');
    } on DioException catch (e) {
      throw ServerException(_extractError(e));
    }
  }

  @override
  Future<SeekerDocumentModel> uploadDocument(String filePath, String title, String docType) async {
    try {
      final fileName = filePath.split('/').last;
      final formData = FormData.fromMap({
        'title': title,
        'doc_type': docType,
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      final resp = await _dioClient.post(ApiConstants.uploadDocument, data: formData);
      final data = resp.data;
      // POST /upload/document returns {url, message} — build a minimal document
      return SeekerDocumentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        docType: docType,
        fileUrl: data['url']?.toString(),
      );
    } on DioException catch (e) {
      throw ServerException(_extractError(e));
    }
  }

  @override
  Future<void> deleteDocument(String id) async {
    try {
      await _dioClient.delete('${ApiConstants.seekerDocuments}/$id');
    } on DioException catch (e) {
      throw ServerException(_extractError(e));
    }
  }

  @override
  Future<void> addSkill(int skillId, String level) async {
    try {
      await _dioClient.post(ApiConstants.seekerSkills, data: {
        'skill_id': skillId,
        'level': level,
      });
    } on DioException catch (e) {
      throw ServerException(_extractError(e));
    }
  }

  @override
  Future<void> removeSkill(int skillId) async {
    try {
      await _dioClient.delete('${ApiConstants.seekerSkills}/$skillId');
    } on DioException catch (e) {
      throw ServerException(_extractError(e));
    }
  }

  @override
  Future<String> uploadAvatar(String filePath) async {
    try {
      final fileName = filePath.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      final resp = await _dioClient.post(ApiConstants.uploadAvatar, data: formData);
      return resp.data['url']?.toString() ?? '';
    } on DioException catch (e) {
      throw ServerException(_extractError(e));
    }
  }

  @override
  Future<String> uploadResume(String filePath) async {
    try {
      final fileName = filePath.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(File(filePath).path, filename: fileName),
      });
      final resp = await _dioClient.post(ApiConstants.uploadResume, data: formData);
      return resp.data['url']?.toString() ?? '';
    } on DioException catch (e) {
      throw ServerException(_extractError(e));
    }
  }

  @override
  Future<List<SkillModel>> getAllSkills() async {
    try {
      final resp = await _dioClient.get('${ApiConstants.seekerSkills}/all?page=1&limit=200');
      final items = resp.data['items'] as List? ?? [];
      return items.map((e) => SkillModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(_extractError(e));
    }
  }
}
