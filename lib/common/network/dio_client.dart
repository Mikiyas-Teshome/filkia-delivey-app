import 'package:dio/dio.dart';
import 'package:zenbil_driver_app/common/contants/constants.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      // baseUrl: 'https://signal.bekurtechsolution.com/',
      // connectTimeout: Duration(seconds: 5), // 5 seconds
      // receiveTimeout: Duration(seconds: 3), // 3 seconds
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add interceptors for logging, authentication, etc.
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add Authorization token dynamically if required
        options.headers['Authorization'] =
            'Bearer <token>'; // Replace with actual token logic
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Log or process responses if needed
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // Handle errors globally
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;
}
