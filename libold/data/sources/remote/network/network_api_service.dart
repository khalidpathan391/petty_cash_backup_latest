// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:petty_cash/data/models/custom/upload_progress.dart';
import 'package:petty_cash/data/sources/remote/app_exception.dart';
import 'package:petty_cash/data/sources/remote/network/base_api_service.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/utils/app_utils.dart';

import 'package:path/path.dart';
import 'package:async/async.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future getApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw FetchDataException(AppUtils.timeOut);
        },
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException(AppUtils.noInternet);
    }
    return responseJson;
  }

  @override
  Future postApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      http.Response response = await http
          .post(Uri.parse(url), body: getAllDynamicData(data))
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw FetchDataException(AppUtils.timeOut);
        },
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException(AppUtils.noInternet);
    }
    return responseJson;
  }

  @override
  Future postApiMultiLanguageResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      http.Response response = await http
          .post(Uri.parse(url), body: getAllDynamicData(data))
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw FetchDataException(AppUtils.timeOut);
        },
      );
      responseJson = returnMultiLanguageResponse(response);
    } on SocketException {
      throw FetchDataException(AppUtils.noInternet);
    }
    return responseJson;
  }

  Map<String, String> getHeaderForToken() {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer YOUR_TOKEN_HERE',
    };
    return headers;
  }

  @override
  Future postApiResponseWithFile(File file, String url, dynamic data,
      {String key = 'file'}) async {
    dynamic responseJson;
    try {
      //the url for request
      var request = http.MultipartRequest('POST', Uri.parse(url));
      //check if file not empty
      if (file.path.isNotEmpty) {
        var stream =
            // ignore: deprecated_member_use
            http.ByteStream(DelegatingStream.typed(file.openRead()));
        var length = await file.length();
        //do multi part and add
        //key: file
        var multipartFile =
            http.MultipartFile(key, stream, length, //dynamic key default file
                filename: basename(file.path));
        request.files.add(multipartFile);
      }
      //check if data is not empty and add
      if (data != null) {
        request.fields.addAll(getAllStaticData(data));
      }
      //hit the api and get response
      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: 90));
      http.Response res = await http.Response.fromStream(response);
      responseJson = returnResponse(res);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  @override
  Future postApiResponseWithFileDio(String? key2, File? file2,
      {required String baseUrl,
      required String url,
      dynamic formData,
      File? file,
      String key = 'file',
      required Function(UploadProgress) onProgress,
      dynamic cancelToken}) async {
    dynamic responseJson;
    var dio = Dio(getRequestApiTimeOut(baseUrl));
    int totalBytes = 0;
    try {
      // adding image or data
      if (file!.path.isNotEmpty) {
        String imgName = file.path.split('/').last;
        totalBytes += file.lengthSync(); //adding the size of files
        var image = await MultipartFile.fromFile(file.path, filename: imgName);
        formData.files.add(MapEntry(key, image));
        // var image = MapEntry(key, await MultipartFile.fromFile(file.path, filename: imgName));
        // formData.files.add(image);
      }
      if (file2!.path.isNotEmpty) {
        String imgName2 = file2.path.split('/').last;
        totalBytes += file2.lengthSync(); //adding the size of files
        var image2 =
            await MultipartFile.fromFile(file2.path, filename: imgName2);
        formData.files.add(MapEntry(key2!, image2));
        // var image = MapEntry(key2, await MultipartFile.fromFile(file2.path, filename: imgName));
        // formData.files.add(image);
      }
      var response = await dio.post(
        url,
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: (int sent, int total) {
          double progress = sent / total;
          onProgress(UploadProgress(progress, sent,
              totalBytes)); // Update progress //send data showing how much is uploaded
        },
      );
      //not handling any error here
      responseJson = response.data;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        //user cancelled
        // print("Request canceled");
        return 1;
      } else {
        if (e.response!.statusCode! == 500) {
          throw FetchDataException(
              'Status Code :${e.response!.statusCode!}!\nError occurred while communication with server with status code : ${e.message}');
        }
      }
    }
    return responseJson;
  }

  @override
  Future postApiResponseWithListFile(
      List<String> allImages, String url, dynamic data) async {
    dynamic responseJson;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      for (int i = 0; i < allImages.length; i++) {
        var stream = http.ByteStream(
            // ignore: deprecated_member_use
            DelegatingStream.typed(File(allImages[i]).openRead()));
        var length = await File(allImages[i]).length();
        //key: img1[]
        var multipartFile = http.MultipartFile('img1[]', stream, length,
            filename: basename(File(allImages[i]).path));
        request.files.add(multipartFile);
      }
      if (data != null) {
        request.fields.addAll(getAllStaticData(data));
      }
      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: 30));
      http.Response res = await http.Response.fromStream(response);

      responseJson = returnResponse(res);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  @override
  Future postApiResponseWithListFileAll(
      String? key3, File? file3, String? key2, File? file2,
      {required key,
      required String baseUrl,
      required String url,
      required List<String> allData,
      dynamic formData,
      required Function(UploadProgress) onProgress,
      dynamic cancelToken}) async {
    dynamic responseJson;
    var dio = Dio(getRequestApiTimeOut(baseUrl));
    int totalBytes = 0;
    try {
      //adding image or data file3
      if (file3!.path.isNotEmpty) {
        String imgName3 = file3.path.split('/').last;
        totalBytes += file3.lengthSync(); //adding the size of files
        var image3 =
            await MultipartFile.fromFile(file3.path, filename: imgName3);
        formData.files.add(MapEntry(key3!, image3));
        // var image = MapEntry(key2, await MultipartFile.fromFile(file2.path, filename: imgName));
        // formData.files.add(image);
      }
      //adding image or data
      if (file2!.path.isNotEmpty) {
        String imgName2 = file2.path.split('/').last;
        totalBytes += file2.lengthSync(); //adding the size of files
        var image2 =
            await MultipartFile.fromFile(file2.path, filename: imgName2);
        formData.files.add(MapEntry(key2!, image2));
        // var image = MapEntry(key2, await MultipartFile.fromFile(file2.path, filename: imgName));
        // formData.files.add(image);
      }
      for (int i = 0; i < allData.length; i++) {
        String imgName = allData[i].split('/').last;
        totalBytes += File(allData[i]).lengthSync(); //adding the size of files
        var image = MapEntry(
            key, await MultipartFile.fromFile(allData[i], filename: imgName));
        formData.files.add(image);
      }
      var response = await dio.post(
        url, data: formData,
        /*
          //inbuilt dio function to show how much data has been uploaded
          // use properly by using while calling the api add
          final ValueNotifier<UploadProgress> _progress = ValueNotifier<UploadProgress>(UploadProgress(0, 0, 0,));//read the change in value of progress
          final CancelToken cancelToken = CancelToken();//for cancel token
          // onProgress: (progress){_progress.value = progress;}//update the changes in value
          //and lastly make ui to display it like below example or any custom
          ValueListenableBuilder<UploadProgress>(
            valueListenable: _progress,
            builder: (context, value, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...value.progress != 1 ? [
                    LinearProgressIndicator(
                      value: value.progress,
                      backgroundColor: context.resources.color.themeColor.withOpacity(.5),
                      valueColor: AlwaysStoppedAnimation<Color>(context.resources.color.themeColor),
                      minHeight: AppHeight(2),
                    ),
                    CommonTextView(label:'${AppUtils.formatBytes(value.sentBytes)} / ${AppUtils.formatBytes(value.totalBytes)}',
                      padding: EdgeInsets.only(top: AppHeight(10)),),
                    CommonTextView(label:'Uploading : ${(value.progress * 100).toStringAsFixed(0)}%',
                      padding: EdgeInsets.symmetric(vertical: AppHeight(10)),),
                  ]:[
                    LinearProgressIndicator(
                      backgroundColor: context.resources.color.themeColor.withOpacity(.5),
                      valueColor: AlwaysStoppedAnimation<Color>(context.resources.color.themeColor),
                      minHeight: AppHeight(2),
                    ),
                    CommonTextView(label: 'Syncing Data ...',padding: EdgeInsets.symmetric(vertical: AppHeight(10)),),
                  ],
                ],
              );
            },
          )
        */
        onSendProgress: (int sent, int total) {
          double progress = sent / total;
          onProgress(UploadProgress(progress, sent,
              totalBytes)); // Update progress //send data showing how much is uploaded
        },
        cancelToken: cancelToken, //to manually cancel request
      );
      //not handling any error here
      responseJson = response.data;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        //user cancelled
        // print("Request canceled");
        return 1;
      } else {
        //other error
      }
    }
    // catch (error){
    //   throw FetchDataException('Error occurred while communication with server with status code : ${responseJson.statusCode}');
    // }
    return responseJson;
  }

  //setting sending and response timeout
  BaseOptions getRequestApiTimeOut(String baseUrl) {
    return BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      //sending data server connection check timeout
      connectTimeout: const Duration(seconds: 60), // 60 seconds
      //after sending response time
      receiveTimeout: const Duration(seconds: 60), // 60 seconds
    );
  }

  dynamic returnResponse(dynamic response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communication with server with status code : ${response.statusCode}');
    }
  }

  dynamic returnMultiLanguageResponse(dynamic response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(utf8.decode(response.bodyBytes));
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(utf8.decode(response.bodyBytes));
        return responseJson;
      case 400:
        throw BadRequestException(response.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communication with server with status code : ${response.statusCode}');
    }
  }

  Map getAllDynamicData(dynamic data) {
    data.addAll({
      'device_type':
          Platform.isIOS ? Global.deviceTypeIos : Global.deviceTypeAndroid,
      'device_id': Global.deviceId,
      'device_model': Global.deviceModel,
      'device_version': Global.deviceVersion,
      'device_token': Global.firebaseToken.toString(),
    });
    return data;
  }

  Map<String, String> getAllStaticData(dynamic data) {
    data.addAll({
      'device_type':
          Platform.isIOS ? Global.deviceTypeIos : Global.deviceTypeAndroid,
      'device_id': Global.deviceId,
      'device_model': Global.deviceModel,
      'device_version': Global.deviceVersion,
      'device_token': Global.firebaseToken,
    });
    return data;
  }
/*@override
    Future deleteApiResponseWithData(dynamic data, String url) async {
      dynamic responseJson;
      try {
        Response response = await http.delete(Uri.parse(url),
            body: data,
            // headers: {"X-API-KEY": "taibah123456"}
            ).timeout(const Duration(seconds: 30));
        responseJson = returnResponse(response);
      } on SocketException {
        throw FetchDataException("No Internet Connection");
      }
      return responseJson;
    }*/
}
