import 'package:dio/dio.dart';
import 'package:speed_staff_mobile/config/core/constants/api_constants.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/config/network/dio_client.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/data/models/dashboard_model.dart';
import 'package:speed_staff_mobile/features/employer/profile/data/models/employer_profile_model.dart';

abstract class EmployerRemoteDataSource {
  Future<EmployerProfileModel> createProfile(Map<String, dynamic> data);
  Future<EmployerProfileModel> getOwnProfile();
  Future<EmployerProfileModel> updateProfile(Map<String, dynamic> data);
  Future<EmployerProfileModel> getEmployerProfile(String employerId);
  Future<DashboardStatsModel> getDashboardStats();
}

class EmployerRemoteDataSourceImpl implements EmployerRemoteDataSource {
  final DioClient _dioClient;

  EmployerRemoteDataSourceImpl(this._dioClient);

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
  Future<EmployerProfileModel> createProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.post(ApiConstants.employerProfile, data: data);
      return EmployerProfileModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<EmployerProfileModel> getOwnProfile() async {
    try {
      final response = await _dioClient.get(ApiConstants.employerProfile);
      return EmployerProfileModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException('PROFILE_NOT_FOUND');
      }
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<EmployerProfileModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.put(ApiConstants.employerProfile, data: data);
      return EmployerProfileModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<EmployerProfileModel> getEmployerProfile(String employerId) async {
    try {
      final response = await _dioClient.get('${ApiConstants.employerProfile}/$employerId');
      return EmployerProfileModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      final response = await _dioClient.get(ApiConstants.employerDashboard);
      return DashboardStatsModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
