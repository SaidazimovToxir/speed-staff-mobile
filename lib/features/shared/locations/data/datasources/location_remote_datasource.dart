import 'package:dio/dio.dart';
import 'package:speed_staff_mobile/config/core/constants/api_constants.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/config/network/dio_client.dart';
import 'package:speed_staff_mobile/features/shared/locations/data/models/location_model.dart';

abstract class LocationRemoteDataSource {
  Future<List<RegionModel>> getRegions();
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final DioClient _dioClient;

  LocationRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<RegionModel>> getRegions() async {
    try {
      final response = await _dioClient.get(ApiConstants.locationsRegions);
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((e) => RegionModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
