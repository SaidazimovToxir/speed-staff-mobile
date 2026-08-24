import 'package:dio/dio.dart';
import 'package:speed_staff_mobile/config/core/constants/api_constants.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/config/network/dio_client.dart';

abstract class UploadRemoteDataSource {
  Future<String> uploadLogo(String filePath);
}

class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final DioClient _dioClient;

  UploadRemoteDataSourceImpl(this._dioClient);

  @override
  Future<String> uploadLogo(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await _dioClient.post(ApiConstants.uploadLogo, data: formData);
      return response.data['url'] as String;
    } on DioException catch (e) {
      throw ServerException(e.message ?? e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
