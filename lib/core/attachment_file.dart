// author: juraj.suchan@gmail.com

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mime/mime.dart';

Future<MultipartFile> attachmentFromPath(String path, {String? name}) {
  final fileName = name ?? path.split(Platform.pathSeparator).last;
  return MultipartFile.fromFile(
    path,
    filename: fileName,
    contentType: DioMediaType.parse(
      lookupMimeType(fileName) ?? 'application/octet-stream',
    ),
  );
}
