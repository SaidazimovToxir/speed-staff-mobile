import 'package:speed_staff_mobile/config/core/constants/api_constants.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/config/network/dio_client.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/data/models/vacancy_model.dart';
import 'package:dio/dio.dart';

abstract class VacancyFeedRemoteDataSource {
  Future<PaginatedVacanciesModel> getVacancyFeed({
    String? position, String? city, String? workType,
    int? salaryMin, int? salaryMax, int page = 1, int limit = 20,
  });

  Future<PaginatedVacanciesModel> searchVacancies({
    String? q, String? position, String? city, String? workType,
    int page = 1, int limit = 20,
  });

  Future<VacancyModel> getVacancyDetail(String vacancyId);

  Future<String> saveVacancy(String vacancyId);
  Future<String> removeSavedVacancy(String vacancyId);
  Future<PaginatedVacanciesModel> getSavedVacancies({int page = 1, int limit = 50});
}

class VacancyFeedRemoteDataSourceImpl implements VacancyFeedRemoteDataSource {
  final DioClient _dioClient;

  VacancyFeedRemoteDataSourceImpl(this._dioClient);

  String _extractErrorMessage(DioException e) {
    if (e.response?.data is Map<String, dynamic>) {
      final data = e.response!.data as Map<String, dynamic>;
      return data['message']?.toString() ?? data['error_code']?.toString() ?? e.message ?? e.toString();
    }
    return e.message ?? e.toString();
  }

  @override
  Future<PaginatedVacanciesModel> getVacancyFeed({
    String? position, String? city, String? workType,
    int? salaryMin, int? salaryMax, int page = 1, int limit = 20,
  }) async {
    try {
      final params = <String, dynamic>{'page': page, 'limit': limit};
      if (position != null) params['position'] = position;
      if (city != null) params['city'] = city;
      if (workType != null) params['work_type'] = workType;
      if (salaryMin != null) params['salary_min'] = salaryMin;
      if (salaryMax != null) params['salary_max'] = salaryMax;
      final response = await _dioClient.get(ApiConstants.vacancies, queryParameters: params);
      return PaginatedVacanciesModel.fromJson(response.data is Map ? response.data : {'items': response.data, 'meta': {}});
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PaginatedVacanciesModel> searchVacancies({
    String? q, String? position, String? city, String? workType,
    int page = 1, int limit = 20,
  }) async {
    try {
      final params = <String, dynamic>{'page': page, 'limit': limit};
      if (q != null && q.isNotEmpty) params['q'] = q;
      if (position != null) params['position'] = position;
      if (city != null) params['city'] = city;
      if (workType != null) params['work_type'] = workType;
      final response = await _dioClient.get(ApiConstants.searchVacancies, queryParameters: params);
      return PaginatedVacanciesModel.fromJson(response.data is Map ? response.data : {'items': response.data, 'meta': {}});
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<VacancyModel> getVacancyDetail(String vacancyId) async {
    try {
      final response = await _dioClient.get('${ApiConstants.vacancies}/$vacancyId');
      final data = response.data is Map && response.data['data'] != null ? response.data['data'] : response.data;
      return VacancyModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> saveVacancy(String vacancyId) async {
    try {
      final response = await _dioClient.post('${ApiConstants.vacancies}/$vacancyId/save');
      return response.data['message']?.toString() ?? 'Vacancy saved';
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> removeSavedVacancy(String vacancyId) async {
    try {
      final response = await _dioClient.delete('${ApiConstants.vacancies}/$vacancyId/save');
      return response.data['message']?.toString() ?? 'Removed from bookmarks';
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PaginatedVacanciesModel> getSavedVacancies({int page = 1, int limit = 50}) async {
    try {
      final response = await _dioClient.get(ApiConstants.seekerSavedVacancies, queryParameters: {'page': page, 'limit': limit});
      return PaginatedVacanciesModel.fromJson(response.data is Map ? response.data : {'items': response.data, 'meta': {}});
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
