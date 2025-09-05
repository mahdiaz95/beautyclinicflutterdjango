import 'package:PARLACLINIC/features/auth/repositories/auth_local_repository.dart';
import 'package:PARLACLINIC/features/auth/view/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../core/constants/server_constant.dart';
import '../core/providers/current_user_notifier.dart';
import '../features/auth/model/user_model.dart';

final upgradeDetailsProvider = StateProvider<String?>((ref) => null);

class ApiService {
  final Dio _dio;
  final Ref _ref;

  ApiService(this._ref)
      : _dio = Dio(BaseOptions(
          baseUrl: '${ServerConstant.serverURL}/api',
          headers: {'Content-Type': 'application/json'},
        )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _ref.read(authLocalRepositoryProvider).getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (DioException e, handler) {
        final status = e.response?.statusCode;
        String errorMessage = 'خطا در برقراری ارتباط با سرور';
        String? djangoError = _extractDjangoError(e.response?.data);

        switch (status) {
          case 401:
            errorMessage = 'نشست شما منقضی شده است. لطفا دوباره وارد شوید.';
            if (djangoError != null) {
              errorMessage += ' ($djangoError)';
            }
            _ref.read(currentUserNotifierProvider.notifier).removeUser();
            _ref.read(authLocalRepositoryProvider).clearToken();
            _navigateToLogin();
            break;
          case 403:
            errorMessage = 'شما اجازه چنین کاری را ندارید.';
            if (djangoError != null) {
              errorMessage += ' ($djangoError)';
            }
            break;
          case 404:
            errorMessage = 'منبع مورد نظر پیدا نشد.';
            if (djangoError != null) {
              errorMessage += ' ($djangoError)';
            }
            break;
          case 429:
            errorMessage = 'تعداد درخواست‌ها بیش از حد مجاز است.';
            if (djangoError != null) {
              errorMessage += ' ($djangoError)';
            }
            break;
          case 426:
            final details = e.response?.data['detail'] ?? 'app is outdated';
            errorMessage = 'لطفا اپلیکیشن را به روز کنید. لینک: $details';
            if (djangoError != null && djangoError != details) {
              errorMessage += ' ($djangoError)';
            }
            _ref.read(upgradeDetailsProvider.notifier).state = details;
            _ref.read(currentUserNotifierProvider.notifier).removeUser();
            _ref.read(authLocalRepositoryProvider).clearToken();
            _navigateToLogin();
            break;
          case 500:
            errorMessage = 'خطای داخلی سرور. لطفا بعدا امتحان کنید.';
            if (djangoError != null) {
              errorMessage += ' ($djangoError)';
            }
            break;
          default:
            if (e.type == DioExceptionType.connectionTimeout) {
              errorMessage =
                  'خطا در برقراری ارتباط با سرور. لطفا اتصال اینترنت خود را بررسی کنید.';
            } else if (e.type == DioExceptionType.receiveTimeout) {
              errorMessage = 'سرور پاسخ نداد. لطفا دوباره امتحان کنید.';
            } else {
              errorMessage = 'یک خطا در برقراری ارتباط با سرور رخ داده است.';
            }
            if (djangoError != null) {
              errorMessage += ' ($djangoError)';
            }
        }

        print('Error: $status - ${e.message} - Django Error: $djangoError');

        handler.next(DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error: errorMessage,
        ));
      },
    ));
  }

  // Helper method to extract Django error messages from response data
  String? _extractDjangoError(dynamic data) {
    if (data == null) return null;

    // Handle common DRF error formats
    if (data is Map<String, dynamic>) {
      // Check for 'detail' field
      if (data.containsKey('detail') && data['detail'] is String) {
        return data['detail'];
      }
      // Check for 'non_field_errors'
      if (data.containsKey('non_field_errors') &&
          data['non_field_errors'] is List) {
        return data['non_field_errors'].join(', ');
      }
      // Check for field-specific errors (e.g., {'username': ['This field is required.']})
      final errors = data.entries
          .where((entry) => entry.value is List || entry.value is String)
          .map((entry) {
        if (entry.value is List) {
          return entry.value.join(', ');
        }
        return entry.value.toString();
      }).toList();
      if (errors.isNotEmpty) {
        return errors.join(', ');
      }
    } else if (data is List && data.isNotEmpty) {
      // Handle list of errors (e.g., ['Error message'])
      return data.join(', ');
    } else if (data is String) {
      // Handle plain string errors
      return data;
    }

    return null;
  }

  Future<T> request<T>({
    required String path,
    required String method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    T Function(dynamic)? responseConverter,
  }) async {
    final response = await _dio.request(
      path,
      options: Options(method: method),
      queryParameters: queryParameters,
      data: data,
    );
    return responseConverter != null
        ? responseConverter(response.data)
        : response.data as T;
  }

  Future<T> multipartRequest<T>({
    required String path,
    required String method,
    required Map<String, String> fields,
    required List<MultipartFile> files,
    T Function(dynamic)? responseConverter,
    void Function(double)? onSendProgress,
  }) async {
    final formData = FormData.fromMap({
      ...fields,
      'file': files,
    });
    final response = await _dio.request(
      path,
      options: Options(method: method),
      data: formData,
      onSendProgress: (sent, total) {
        if (total > 0 && onSendProgress != null) {
          onSendProgress(sent / total);
        }
      },
    );
    return responseConverter != null
        ? responseConverter(response.data)
        : response.data as T;
  }

  Future<String> login(String username, String password) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    return await request<String>(
      path: '/token/',
      method: 'POST',
      data: {
        'username': username,
        'password': password,
        'version': version,
      },
      responseConverter: (data) => data['access'] as String,
    );
  }

  Future<UserModel> getCurrentUserData() async {
    return await request<UserModel>(
      path: '/auth/',
      method: 'GET',
      responseConverter: (data) =>
          UserModel.fromMap(data as Map<String, dynamic>),
    );
  }

  void _navigateToLogin() {
    final navigatorKey = _ref.read(navigatorKeyProvider);
    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }
}

final apiServiceProvider = Provider<ApiService>((ref) => ApiService(ref));
final navigatorKeyProvider =
    Provider<GlobalKey<NavigatorState>>((ref) => GlobalKey<NavigatorState>());
