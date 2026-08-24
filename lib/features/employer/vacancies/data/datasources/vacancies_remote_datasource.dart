import 'package:dio/dio.dart';
import 'package:speed_staff_mobile/config/core/constants/api_constants.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/config/network/dio_client.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/data/models/vacancy_model.dart';

abstract class VacanciesRemoteDataSource {
  Future<List<VacancyModel>> getMyVacancies({int page = 1, int limit = 50});
  Future<VacancyModel> createVacancy(Map<String, dynamic> data);
  Future<VacancyModel> updateVacancy(String id, Map<String, dynamic> data);
  Future<void> changeVacancyStatus(String id, String status);
  Future<void> deleteVacancy(String id);
  // Future<PaginatedResponse<ApplicationShortResponse>> getVacancyApplications(String id);
}

class VacanciesRemoteDataSourceImpl implements VacanciesRemoteDataSource {
  final DioClient _dioClient;

  VacanciesRemoteDataSourceImpl(this._dioClient);

  String _extractErrorMessage(DioException e) {
    if (e.response?.data is Map<String, dynamic>) {
      final data = e.response!.data as Map<String, dynamic>;
      if (data['message'] != null) {
        return data['message'].toString();
      }
      if (data['error_code'] != null) {
        return data['error_code'].toString();
      }
    }
    return e.message ?? e.toString();
  }

  @override
  Future<List<VacancyModel>> getMyVacancies({int page = 1, int limit = 50}) async {
    try {
      final response = await _dioClient.get(ApiConstants.vacancies, queryParameters: {'page': page, 'limit': limit});
      final List<dynamic> items = response.data['data']?['items'] ?? response.data['items'] ?? response.data;
      return items.map((e) => VacancyModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<VacancyModel> createVacancy(Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.post(ApiConstants.vacancies, data: data);
      return VacancyModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      // Handle VACANCY_LIMIT_REACHED specifically
      if (e.response?.statusCode == 400 && e.response?.data?['error_code'] == 'VACANCY_LIMIT_REACHED') {
        throw ServerException('VACANCY_LIMIT_REACHED');
      }
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<VacancyModel> updateVacancy(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.put('${ApiConstants.vacancies}/$id', data: data);
      return VacancyModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> changeVacancyStatus(String id, String status) async {
    try {
      await _dioClient.patch('${ApiConstants.vacancies}/$id/status', data: {'status': status});
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteVacancy(String id) async {
    try {
      await _dioClient.delete('${ApiConstants.vacancies}/$id');
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
