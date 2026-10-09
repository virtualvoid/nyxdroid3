// author: juraj.suchan@gmail.com

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../auth/auth_store.dart';
import '../constants.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient(this._auth, {Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: Constants.apiUrl,
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 30),

              validateStatus: (_) => true,
            ),
          ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['User-Agent'] =
              'nyxdroid2; ${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
          final nick = _auth.nick;
          final token = _auth.token;
          if (nick != null &&
              nick.isNotEmpty &&
              token != null &&
              token.isNotEmpty) {
            options.headers['Authorization-Context'] =
                '${Constants.index} ${nick.toUpperCase()}';
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  final AuthStore _auth;
  final Dio _dio;

  void Function(ApiException e)? onApiError;

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _send('GET', path, query: query);

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? query,
    Object? data,
  }) => _send('POST', path, query: query, data: data);

  Future<dynamic> form(String path, Map<String, String> fields) => _send(
    'POST',
    path,
    data: fields,
    contentType: Headers.formUrlEncodedContentType,
  );

  Future<dynamic> formList(String path, String field, List<Object> values) =>
      _send(
        'POST',
        path,
        data: {field: values},
        contentType: Headers.formUrlEncodedContentType,
        listFormat: ListFormat.multi,
      );

  Future<dynamic> delete(String path) => _send('DELETE', path);

  Future<dynamic> multipart(String path, FormData data) =>
      _send('PUT', path, data: data);

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, dynamic>? query,
    Object? data,
    String? contentType,
    ListFormat? listFormat,
  }) async {
    final Response<dynamic> res;
    try {
      res = await _dio.request<dynamic>(
        path,
        data: data,
        queryParameters: query,
        options: Options(
          method: method,
          contentType: contentType,
          listFormat: listFormat,
          responseType: ResponseType.plain,
        ),
      );
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Sieťová chyba');
    }

    final code = res.statusCode ?? 0;
    final body = _decode(res.data);
    if (code == 200 || code == 204) {
      return body;
    }

    final err = body is Map
        ? ApiException(
            (body['message'] ?? body['error'] ?? 'Chyba').toString(),
            statusCode: code,
            code: body['code']?.toString(),
          )
        : ApiException('HTTP $code', statusCode: code);
    onApiError?.call(err);
    throw err;
  }

  dynamic _decode(dynamic raw) {
    if (raw is! String || raw.trim().isEmpty) return null;
    try {
      return jsonDecode(raw);
    } on FormatException {
      return null;
    }
  }
}
