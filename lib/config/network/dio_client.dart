import 'package:dio/dio.dart';
import 'package:speed_staff_mobile/config/core/constants/constants.dart';
import 'package:speed_staff_mobile/config/core/error/error.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_event.dart';
import 'package:speed_staff_mobile/features/shared/auth/data/datasources/auth_local_datasource.dart';
import 'package:speed_staff_mobile/config/core/di/injection_container.dart';

/// HTTP client wrapper for making API requests
class DioClient {
  final Dio _dio;
  static const String _baseUrl = ApiConstants.baseUrl;

  /// Creates a new DioClient instance with default configuration
  DioClient(this._dio) {
    _dio
      ..options.baseUrl = _baseUrl
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..options.responseType = ResponseType.json
      ..options.headers = {'Content-Type': 'application/json', 'Accept': 'application/json'}
      ..interceptors.add(_AuthInterceptor())
      // ..interceptors.add(
      //   TalkerDioLogger(
      //     settings: const TalkerDioLoggerSettings(
      //       printRequestHeaders: true,
      //       printResponseHeaders: true,
      //       printRequestData: true,
      //       printResponseData: true,
      //       printResponseMessage: true,
      //       printErrorData: true,
      //       printErrorHeaders: true,
      //       printErrorMessage: true,
      //     ),
      //   ),
      // );
      ..interceptors.add(LogInterceptor(request: true, requestHeader: true, requestBody: true, responseHeader: true, responseBody: true, error: true));
  }

  /// Makes a GET request to the specified [path]
  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get<T>(path, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Makes a POST request to the specified [path]
  Future<Response<T>> post<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async {
    try {
      final response = await _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Makes a DELETE request to the specified [path]
  Future<Response<T>> delete<T>(String path, {Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async {
    try {
      final response = await _dio.delete<T>(path, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    // Check for custom error response format
    if (error.response?.data != null) {
      final data = error.response?.data;
      if (data is Map<String, dynamic> && data['status'] == 'error') {
        return AuthException(data['message'] ?? 'Unknown error occurred');
      }
    }

    // Handle standard error cases
    if (error.response?.data != null && error.response?.data['message'] != null) {
      final message = error.response?.data['message'];
      switch (error.response?.statusCode) {
        case 400:
          return BadRequestException(message);
        case 401:
          return UnauthorizedException(message);
        case 403:
          return ForbiddenException(message);
        case 404:
          return NotFoundException(message);
        case 500:
          return ServerException(message);
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout');
      case DioExceptionType.badResponse:
        return NetworkException('Bad response: ${error.response?.statusCode}');
      case DioExceptionType.cancel:
        return NetworkException('Request cancelled');
      default:
        return NetworkException('Network error occurred');
    }
  }
}

/// Interceptor for handling authentication tokens
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final localDataSource = sl<AuthLocalDataSource>();
      final token = await localDataSource.getToken();

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // Continue without token
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // If request fails with 401 AND it is not the refresh endpoint itself
    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains(ApiConstants.refreshToken)) {
      try {
        final localDataSource = sl<AuthLocalDataSource>();
        final refreshToken = await localDataSource.getRefreshToken();

        if (refreshToken != null) {
          final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
          final response = await dio.post(ApiConstants.refreshToken, data: {'refresh_token': refreshToken});
          final newAccessToken = response.data['tokens']['access_token'];
          final newRefreshToken = response.data['tokens']['refresh_token'];

          await localDataSource.cacheToken(newAccessToken);
          await localDataSource.cacheRefreshToken(newRefreshToken);

          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          final clonedRequest = await dio.request(
            options.path,
            options: Options(method: options.method, headers: options.headers),
            data: options.data,
            queryParameters: options.queryParameters,
          );
          return handler.resolve(clonedRequest);
        } else {
          sl<AuthBloc>().add(LogoutEvent());
        }
      } catch (e) {
        // Refresh failed, auto-logout
        sl<AuthBloc>().add(LogoutEvent());
      }
    }
    handler.next(err);
  }
}
