// ignore_for_file: file_names

import 'dart:io';

import 'package:petty_cash/data/models/custom/upload_progress.dart';

abstract class BaseApiService {
  Future<dynamic> getApiResponse(String url);

  Future<dynamic> postApiResponse(String url, dynamic data);

  Future<dynamic> postApiMultiLanguageResponse(String url, dynamic data);

  Future<dynamic> postApiResponseWithFile(File file, String url, dynamic data,
      {String key = 'file'});

  Future<dynamic> postApiResponseWithFileDio(String? key2, File? file2,
      {required String baseUrl,
      required String url,
      dynamic formData,
      File? file,
      required String key,
      required Function(UploadProgress) onProgress,
      dynamic cancelToken});

  Future<dynamic> postApiResponseWithListFile(
      List<String> allImages, String url, dynamic data);

  Future<dynamic> postApiResponseWithListFileAll(
      String? key3, File? file3, String? key2, File? file2,
      {required String key,
      required String baseUrl,
      required String url,
      required List<String> allData,
      dynamic formData,
      required Function(UploadProgress) onProgress,
      dynamic cancelToken});
}
