import 'package:speed_staff_mobile/config/core/constants/api_constants.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/config/network/dio_client.dart';
import 'package:speed_staff_mobile/features/employer/applications/data/models/application_model.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';

abstract class ApplicationsRemoteDataSource {
  Future<PaginatedApplications> getVacancyApplications(
    String vacancyId, {
    String? status,
    int page = 1,
    int limit = 50,
  });

  Future<ApplicationDetailEntity> getApplicationDetail(String applicationId);

  Future<ApplicationDetailEntity> updateApplicationStatus(
    String applicationId,
    String status, {
    String? employerNote,
  });
}

class ApplicationsRemoteDataSourceImpl implements ApplicationsRemoteDataSource {
  final DioClient _dioClient;

  ApplicationsRemoteDataSourceImpl(this._dioClient);


  @override
  Future<PaginatedApplications> getVacancyApplications(
    String vacancyId, {
    String? status,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final params = <String, dynamic>{'page': page, 'limit': limit};
      if (status != null) params['status'] = status;

      final response = await _dioClient.get(
        '${ApiConstants.vacancies}/$vacancyId/applications',
        queryParameters: params,
      );
      final data = response.data as Map<String, dynamic>;
      return PaginatedApplicationsModel.fromJson(data);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ApplicationDetailEntity> getApplicationDetail(String applicationId) async {
    try {
      final response = await _dioClient.get(
        '${ApiConstants.applications}/$applicationId',
      );
      final data = response.data as Map<String, dynamic>;
      return ApplicationDetailModel.fromJson(data);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ApplicationDetailEntity> updateApplicationStatus(
    String applicationId,
    String status, {
    String? employerNote,
  }) async {
    try {
      final body = <String, dynamic>{'status': status};
      if (employerNote != null && employerNote.isNotEmpty) {
        body['employer_note'] = employerNote;
      }
      final response = await _dioClient.patch(
        '${ApiConstants.applications}/$applicationId/status',
        data: body,
      );
      final data = response.data as Map<String, dynamic>;
      return ApplicationDetailModel.fromJson(data);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
