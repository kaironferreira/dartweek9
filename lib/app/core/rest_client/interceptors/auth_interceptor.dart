import 'dart:developer';

import 'package:delivery_app/app/core/excepetions/expire_token_exception.dart';
import 'package:delivery_app/app/core/global/global_context.dart';
import 'package:delivery_app/app/core/rest_client/custom_dio.dart';
import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final CustomDio dio;
  AuthInterceptor(this.dio);
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    options.headers['Authorization'] = 'Bearer $accessToken';
    handler.next(options);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        if (err.requestOptions.path != '/auth/refresh') {
          await _refreshToken(err);
          await _retryRequest(err, handler);
        } else {
          GlobalContext.instance.loginExpired();
        }
      } catch (e) {
        GlobalContext.instance.loginExpired();
      }
    } else {
      handler.next(err);
    }
  }

  Future<void> _refreshToken(DioError err) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');
      if (refreshToken == null) {
        return;
      }

      final resultRefresh = await dio
          .auth()
          .put('/auth/refresh', data: {'refresh_token': refreshToken});

      prefs.setString('accessToken', resultRefresh.data['access_token']);
      prefs.setString('refreshToken', resultRefresh.data['refresh_token']);
    } on DioError catch (e, s) {
      log('Erro ao realizar refresh token', error: e, stackTrace: s);
      throw ExpireTokenException();
    }
  }

  Future<void> _retryRequest(
      DioError err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    final result = await dio.request(
      requestOptions.path,
      options: Options(
          headers: requestOptions.headers, method: requestOptions.method),
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );

    handler.resolve(Response(
      requestOptions: requestOptions,
      data: result.data,
      statusCode: result.statusCode,
      statusMessage: result.statusMessage,
    ));
  }
}
