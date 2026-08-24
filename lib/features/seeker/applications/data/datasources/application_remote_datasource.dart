import 'package:dio/dio.dart';
import 'package:speed_staff_mobile/config/core/constants/api_constants.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/config/network/dio_client.dart';
import 'package:speed_staff_mobile/features/seeker/applications/data/models/application_model.dart';

abstract class ApplicationRemoteDataSource {
  Future<ApplicationModel> applyForVacancy(String vacancyId, {String? coverLetter});
  Future<List<ApplicationModel>> getMyApplications({String? status, int page = 1, int limit = 50});
  Future<String> withdrawApplication(String applicationId);
}

class ApplicationRemoteDataSourceImpl implements ApplicationRemoteDataSource {
  final DioClient _dioClient;

  ApplicationRemoteDataSourceImpl(this._dioClient);

  String _extractError(DioException e) {
    if (e.response?.data is Map<String, dynamic>) {
      final d = e.response!.data as Map<String, dynamic>;
      return d['message']?.toString() ?? d['error_code']?.toString() ?? e.message ?? '';
    }
    return e.message ?? e.toString();
  }

  @override
  Future<ApplicationModel> applyForVacancy(String vacancyId, {String? coverLetter}) async {
    try {
      final body = <String, dynamic>{'vacancy_id': vacancyId};
      if (coverLetter != null && coverLetter.isNotEmpty) body['cover_letter'] = coverLetter;
      final response = await _dioClient.post(ApiConstants.applications, data: body);
      final data = response.data is Map && response.data['data'] != null ? response.data['data'] : response.data;
      return ApplicationModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(_extractError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ApplicationModel>> getMyApplications({String? status, int page = 1, int limit = 50}) async {
    try {
      final params = <String, dynamic>{'page': page, 'limit': limit};
      if (status != null) params['status'] = status;
      final response = await _dioClient.get(ApiConstants.applications, queryParameters: params);
      final items = response.data is Map
          ? (response.data['items'] as List<dynamic>? ?? [])
          : (response.data as List<dynamic>? ?? []);
      return items.map((e) => ApplicationModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(_extractError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> withdrawApplication(String applicationId) async {
    try {
      final response = await _dioClient.delete('${ApiConstants.applications}/$applicationId');
      return response.data['message']?.toString() ?? 'Application withdrawn';
    } on DioException catch (e) {
      throw ServerException(_extractError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
