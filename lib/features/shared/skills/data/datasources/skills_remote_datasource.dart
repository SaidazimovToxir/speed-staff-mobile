import 'package:dio/dio.dart';
import 'package:speed_staff_mobile/config/core/constants/api_constants.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/config/network/dio_client.dart';
import 'package:speed_staff_mobile/features/shared/skills/data/models/skill_model.dart';

abstract class SkillsRemoteDataSource {
  Future<List<SkillModel>> getSkills({String? q, String? category});
}

class SkillsRemoteDataSourceImpl implements SkillsRemoteDataSource {
  final DioClient _dioClient;

  SkillsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<SkillModel>> getSkills({String? q, String? category}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (q != null && q.isNotEmpty) queryParams['q'] = q;
      if (category != null && category.isNotEmpty) queryParams['category'] = category;

      final response = await _dioClient.get(ApiConstants.searchSkills, queryParameters: queryParams);
      final List<dynamic> data = response.data is List
          ? response.data as List<dynamic>
          : (response.data['data'] ?? response.data['skills'] ?? []) as List<dynamic>;
      return data.map((e) => SkillModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
