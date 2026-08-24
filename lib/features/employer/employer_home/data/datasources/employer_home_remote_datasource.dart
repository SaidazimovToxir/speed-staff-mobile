import 'package:dio/dio.dart';
import 'package:speed_staff_mobile/config/core/constants/api_constants.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/config/network/dio_client.dart';
import 'package:speed_staff_mobile/features/employer/applications/data/models/application_model.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/data/models/dashboard_model.dart';

abstract class EmployerHomeRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats();
  Future<List<ApplicationShortModel>> getRecentApplications();
}

class EmployerHomeRemoteDataSourceImpl implements EmployerHomeRemoteDataSource {
  final DioClient _dioClient;

  EmployerHomeRemoteDataSourceImpl(this._dioClient);

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      final response = await _dioClient.get(ApiConstants.employerDashboard);
      final statsData = response.data['data'] != null
          ? response.data['data']['stats']
          : response.data['stats'];
      if (statsData == null) {
        throw ServerException("Missing stats data");
      }
      return DashboardStatsModel.fromJson(statsData);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to get dashboard stats');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ApplicationShortModel>> getRecentApplications() async {
    try {
      final response = await _dioClient.get(ApiConstants.employerDashboard);
      final applicationsData = response.data['data'] != null
          ? response.data['data']['recent_applications']
          : response.data['recent_applications'];
      if (applicationsData == null) return [];
      return (applicationsData as List)
          .map((e) => ApplicationShortModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to get recent applications');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
