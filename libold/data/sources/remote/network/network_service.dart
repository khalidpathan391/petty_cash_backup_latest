import 'dart:async';
import 'package:dio/dio.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/utils/app_utils.dart';

class NetworkService {
  final Dio _dio = Dio();

  // Constructor to set up base options for Dio
  NetworkService() {
    _dio.options = BaseOptions(
      baseUrl: ApiUrl.baseUrl ?? '',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      // headers: {
      //   'Content-Type': 'application/json',
      //   'Accept': 'application/json',
      // },
    );
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Get your token here, possibly from shared preferences, secure storage, or your auth service
        String? token = _getBearerToken();
        if (token != null) {
          options.headers['Authorization'] =
              'Bearer $token'; // Add Bearer token to headers
        }
        return handler.next(options); // Proceed with the request
      },
    ));
  }

  // Example function to retrieve the bearer token
  String? _getBearerToken() {
    // Retrieve the token from secure storage or a similar mechanism
    // For example, you can use `SharedPreferences` or `FlutterSecureStorage`
    return "your_bearer_token_here"; // Replace with actual logic to retrieve the token
  }

  // Method for GET requests
  Future<Response?> getRequest(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    try {
      Response response =
          await _dio.get(endpoint, queryParameters: queryParams);
      return response;
    } catch (e) {
      print('GET request error: $e');
      return null;
    }
  }

  // Method for POST requests
  Future<dynamic> postRequest(
      String endpoint, Map<String, dynamic> data) async {
    AppUtils.apiErrorMessage = '';
    try {
      Response response = await _dio.post(endpoint, data: data);
      if (response.statusCode == 200) {
        return response.data; // Return response.data for a successful response
      } else {
        AppUtils.apiErrorMessage =
            'Error: ${response.statusCode} ${response.statusMessage}';
        return null;
      }
    } catch (e) {
      print('POST request error: $e');
      return null;
    }
  }

  Future<dynamic> postDataWithFile(
      String endpoint,
      Map<String, dynamic> fields,
      String key1,
      MultipartFile? profileImageFile,
      String key2,
      MultipartFile? resumeFile,
      void Function(int sentBytes, int totalBytes) onProgress) async {
    try {
      // Prepare form data by combining fields and files (only if files exist)
      FormData formData = FormData.fromMap({
        ...fields, // Add form fields
        if (profileImageFile != null) key1: profileImageFile else key1: '',
        if (resumeFile != null) key2: resumeFile else key2: '',
      });
      // Send the form data to the endpoint
      Response response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: (int sentBytes, int totalBytes) {
          // Call the provided callback with progress information
          onProgress(sentBytes, totalBytes);
        },
      );
      if (response.statusCode == 200) {
        return response.data; // Return response data on success
      } else {
        AppUtils.apiErrorMessage =
            'Error: ${response.statusCode} ${response.statusMessage}';
        return null;
      }
    } catch (e) {
      print('File upload error: $e');
      return null;
    }
  }

  // Example for a PUT request with FormData (e.g., updating a profile picture)
  Future<Response?> putWithFormData(String endpoint, FormData formData) async {
    try {
      Response response = await _dio.put(endpoint, data: formData);
      return response;
    } catch (e) {
      print('PUT request error: $e');
      return null;
    }
  }

  // Handle file selection and creation of MultipartFile
  Future<MultipartFile> createMultipartFile(
      String filePath, String fieldName) async {
    return await MultipartFile.fromFile(filePath, filename: fieldName);
  }
}

/*void uploadFiles() async {
  NetworkService networkService = NetworkService();

  // Define form fields
  Map<String, dynamic> fields = {
    'username': 'JohnDoe',
    'email': 'john.doe@example.com',
  };
  List<String> imageList = ['/path/to/file1.jpg','/path/to/file1.jpg','/path/to/file1.jpg']
  // Create MultipartFile objects
  MultipartFile file1 = await networkService.createMultipartFile('/path/to/file1.jpg', 'file1.jpg');
  MultipartFile file2 = await networkService.createMultipartFile('/path/to/file2.jpg', 'file2.jpg');

  // Upload files
  Response? response = await networkService.uploadFile('upload-endpoint', fields, [file1, file2]);

  if (response != null && response.statusCode == 200) {
    print('Upload successful: ${response.data}');
  } else {
    print('Upload failed.');
  }
}*/

/*void uploadFiles() async {
  NetworkService networkService = NetworkService();

  // Define form fields
  Map<String, dynamic> fields = {
    'username': 'JohnDoe',
    'email': 'john.doe@example.com',
  };

  // List of image paths
  List<String> imageList = ['/path/to/file1.jpg', '/path/to/file2.jpg', '/path/to/file3.jpg'];

  // Convert image paths to MultipartFile objects
  List<MultipartFile> multipartFiles = [];
  for (String imagePath in imageList) {
    MultipartFile file = await networkService.createMultipartFile(imagePath, imagePath.split('/').last);
    multipartFiles.add(file);
  }

  // Upload files
  Response? response = await networkService.uploadFile('upload-endpoint', fields, multipartFiles);

  if (response != null && response.statusCode == 200) {
    print('Upload successful: ${response.data}');
  } else {
    print('Upload failed.');
  }
}*/
