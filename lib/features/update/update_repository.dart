// author: juraj.suchan@gmail.com

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../core/json_utils.dart';
import 'app_release.dart';

class UpdateRepository {
  UpdateRepository(this._dio);

  final Dio _dio;

  Future<AppRelease?> latest() async {
    try {
      final response = await _dio.get<Object?>(
        'https://api.github.com/repos/${Constants.githubRepo}/releases/latest',
      );
      final data = asMap(response.data);
      return data == null ? null : AppRelease.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }
}

final updateRepositoryProvider = Provider<UpdateRepository>(
  (ref) => UpdateRepository(
    Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: const {
          'Accept': 'application/vnd.github+json',
          'X-GitHub-Api-Version': '2022-11-28',
        },
      ),
    ),
  ),
);
