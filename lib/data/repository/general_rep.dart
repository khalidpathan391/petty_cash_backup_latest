// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:developer';
import 'dart:io';

import 'package:petty_cash/data/models/custom/upload_progress.dart';
import 'package:petty_cash/data/sources/remote/network/base_api_service.dart';
import 'package:petty_cash/data/sources/remote/network/network_api_service.dart';
import 'package:petty_cash/utils/app_utils.dart';

class GeneralRepository {
  final BaseApiService _apiServices = NetworkApiService();

  Future<dynamic> getApi(String url) async {
    AppUtils.errorMessage = '';
    try {
      dynamic response = await _apiServices.getApiResponse(url);
      if (response['error_code'] == 100) {
        AppUtils.errorMessage = response['error_description'].toString();
      }
      return response;
    } catch (error) {
      AppUtils.errorMessage = error.toString();
      rethrow;
    }
  }

  Future<dynamic> postApi(String url, dynamic data) async {
    AppUtils.errorMessage = '';
    log("hiiii" + data.toString());
    // try {
    dynamic response = await _apiServices.postApiResponse(url, data);
    if (response['error_code'] == 100) {
      AppUtils.errorMessage = response['error_description'].toString();
    }
    return response;
    // } catch (error) {
    //   AppUtils.errorMessage = error.toString();
    //   rethrow;
    // }
  }

  Future<dynamic> postApiMultiLanguage(String url, dynamic data) async {
    AppUtils.errorMessage = '';
    try {
      dynamic response =
          await _apiServices.postApiMultiLanguageResponse(url, data);
      if (response['error_code'] == 100) {
        AppUtils.errorMessage = response['error_description'].toString();
      }
      return response;
    } catch (error) {
      AppUtils.errorMessage = error.toString();
      rethrow;
    }
  }

  Future<dynamic> postApiWithFile(String url, dynamic data, File file,
      {String key = 'file'}) async {
    AppUtils.errorMessage = '';
    try {
      dynamic response =
          await _apiServices.postApiResponseWithFile(file, url, data, key: key);
      if (response['error_code'] == 100) {
        AppUtils.errorMessage = response['error_description'].toString();
      }
      return response;
    } catch (error) {
      AppUtils.errorMessage = error.toString();
      rethrow;
    }
  }

  Future<dynamic> postApiWithFileDio(String? key2, File? file2,
      {required String baseUrl,
      required String url,
      dynamic formData,
      File? file,
      String key = 'file',
      required Function(UploadProgress) onProgress,
      dynamic cancelToken}) async {
    AppUtils.errorMessage = '';
    try {
      dynamic response = await _apiServices.postApiResponseWithFileDio(
          key2, file2,
          baseUrl: baseUrl,
          url: url,
          formData: formData,
          file: file,
          key: key,
          onProgress: onProgress,
          cancelToken: cancelToken);
      if (response == 1) {
        //when cancelled by user
        return response; //i.e. 1
      } else {
        if (response['error_code'] == 100) {
          AppUtils.errorMessage = response['error_description'].toString();
        }
        return response;
      }
    } catch (error) {
      AppUtils.errorMessage = error.toString();
      rethrow;
    }
  }

  Future<dynamic> postApiWithListFile(
      String url, dynamic data, List<String> allImages) async {
    AppUtils.errorMessage = '';
    try {
      dynamic response =
          await _apiServices.postApiResponseWithListFile(allImages, url, data);
      if (response['error_code'] == 100) {
        AppUtils.errorMessage = response['error_description'].toString();
      }
      return response;
    } catch (error) {
      AppUtils.errorMessage = error.toString();
      rethrow;
    }
  }

  Future<dynamic> postApiWithListFileAll(
      String? key3, File? file3, String? key2, File? file2,
      {required String fileParam,
      required String baseUrl,
      required String url,
      required List<String> allData,
      dynamic formData,
      required Function(UploadProgress) onProgress,
      dynamic cancelToken}) async {
    //only send the url no need baseurl for this function
    AppUtils.errorMessage = '';
    try {
      dynamic response = await _apiServices.postApiResponseWithListFileAll(
          key3, file3, key2, file2,
          key: fileParam,
          baseUrl: baseUrl,
          url: url,
          allData: allData,
          formData: formData,
          onProgress: onProgress,
          cancelToken: cancelToken);
      if (response == 1) {
        //when cancelled by user
        return response; //i.e. 1
      } else {
        if (response['error_code'] == 100) {
          AppUtils.errorMessage = response['error_description'].toString();
        }
        return response;
      }
    } catch (error) {
      AppUtils.errorMessage = error.toString();
      rethrow;
    }
  }
}
