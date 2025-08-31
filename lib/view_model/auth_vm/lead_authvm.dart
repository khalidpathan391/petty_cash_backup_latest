// ignore_for_file: use_build_context_synchronously, unused_element, unused_field
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:petty_cash/data/repository/general_rep.dart';

import 'package:petty_cash/utils/app_utils.dart';

class LeadAuthVm extends ChangeNotifier {
  final GeneralRepository _repository = GeneralRepository();

  // Controllers for form fields

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool rememberMe = false;
  bool isdisable = false;
  String? profileImageUrl;
  String? uploadedFileUrl;

  File? profileImage;
  File? uploadedFile;

  // Toggle "Remember Me"
  void toggleRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  // File Picker Method
  Future<void> pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc'],
      );

      if (result != null) {
        uploadedFile = File(result.files.single.path!);
        notifyListeners();
      } else {
        AppUtils.showToastRedBg(context, "No file selected");
      }
    } catch (e) {
      AppUtils.showToastRedBg(context, "Error picking file: $e");
    }
  }

  void clearUploadedFile() {
    uploadedFile = null;
    uploadedFileUrl = null; // Clear the URL as well if needed
    notifyListeners();
  }

  // Image Picker Method
  Future<void> pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile =
          await picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
        notifyListeners();
      } else {
        AppUtils.showToastRedBg(context, "No image selected");
      }
    } catch (e) {
      AppUtils.showToastRedBg(context, "Error picking image: $e");
    }
  }

  void removeProfileImage() {
    profileImage = null;
    notifyListeners();
  }

  // Common validation for phone numbers

  // Location Logic

  // Validation for login fields
  Future<bool> validateLoginFields(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      AppUtils.showToastRedBg(context, "All fields are required");
      return false;
    }

    String? phoneError = validatePhoneNumber(emailController.text);
    if (phoneError != null) {
      AppUtils.showToastRedBg(context, phoneError);
      return false;
    }

    if (passwordController.text.length != 6) {
      AppUtils.showToastRedBg(context, "Password must be exactly 6 digits");
      return false;
    }

    return true;
  }

  // validate Phone Number
  String? validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('+966')) {
      phoneNumber = phoneNumber.replaceFirst('+966', '').trim();
    }
    if (phoneNumber.length != 9) {
      return "Enter a valid phone number (9 digits)";
    }
    return null;
  }

// Validation for signup fields
  // Future<bool> validateSignupFields(BuildContext context) async {
  //   if (idController.text.isEmpty ||
  //       nameController.text.isEmpty ||
  //       phoneController.text.isEmpty ||
  //       passwordController.text.isEmpty) {
  //     AppUtils.showToastRedBg(context, "All fields are required");
  //     return false;
  //   }

  //   if (idController.text.length != 10) {
  //     AppUtils.showToastRedBg(
  //         context, "Please enter a valid Iqama/National ID");
  //     return false;
  //   }

  //   if (nameController.text.length < 4) {
  //     AppUtils.showToastRedBg(context, "Full Name is required");
  //     return false;
  //   }

  //   String? phoneError = validatePhoneNumber(phoneController.text);
  //   if (phoneError != null) {
  //     AppUtils.showToastRedBg(context, phoneError);
  //     return false;
  //   }

  //   if (passwordController.text.length != 6) {
  //     AppUtils.showToastRedBg(context, "Password must be exactly 6 digits");
  //     return false;
  //   }

  //   return true;
  // }

//

// Register Detail mandatory
  // Future<bool> checkMandatoryFields(BuildContext context) async {
  //   if (nationalityController.text.trim().isEmpty) {
  //     AppUtils.showToastRedBg(context, "Nationality is required.");
  //     return false;
  //   }

  //   if (jobTitleController.text.trim().isEmpty) {
  //     AppUtils.showToastRedBg(context, "Job Title is required.");
  //     return false;
  //   }

  //   if (locationController.text.trim().isEmpty) {
  //     AppUtils.showToastRedBg(context, "Location is required.");
  //     return false;
  //   }
  //   if (dateController.text.trim().isEmpty) {
  //     AppUtils.showToastRedBg(context, "Location is required.");
  //     return false;
  //   }

  //   // if (profileImage == null) {
  //   //   AppUtils.showToastRedBg(context, "Profile image is required.");
  //   //   return false;
  //   // }

  //   return true;
  // }

// Login User
  // Map<String, String> getLoginFormData() {
  //   return {
  //     "mobile_no": phoneController.text,
  //     "password": passwordController.text,
  //   };
  // }

  // Future<void> loginUser(BuildContext context) async {
  //   bool isValid = await validateLoginFields(context);
  //   if (!isValid) return;

  //   isLoading = true;
  //   notifyListeners();

  //   try {
  //     final response = await _repository.postApi(
  //         ApiUrl.baseUrl + ApiUrl.login, getLoginFormData());
  //     UserDataMain userDataMain = UserDataMain.fromJson(response);

  //     if (userDataMain.errorCode == 200 || userDataMain.errorCode == 201) {
  //       saveUserData(userDataMain.userData!);
  //       AppUtils.showToastGreenBg(context, userDataMain.message.toString());
  //       String routeName = "base_class";
  //       if (userDataMain.userData!.activity == 3) {
  //         routeName = "detail_setup";
  //       }
  //       Navigator.pushNamedAndRemoveUntil(
  //         context,
  //         routeName,
  //         (route) => false,
  //         arguments: '',
  //       );
  //     } else {
  //       AppUtils.showToastRedBg(context, userDataMain.message.toString());
  //     }
  //   } catch (error) {
  //     AppUtils.showToastRedBg(context, error.toString());
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Register User
  // Prepare form data
  // Map<String, String> getFormData(String deviceToken) {
  //   return {
  //     "country_code": "+966",
  //     "mobile_no": phoneController.text,
  //     "password": passwordController.text,
  //     "iqama_no": idController.text,
  //     "user_name": nameController.text,
  //     "device_id": Global.deviceId,
  //     "device_type":
  //         Platform.isIOS ? Global.deviceTypeIos : Global.deviceTypeAndroid,
  //     "device_model": Global.deviceModel,
  //     "device_token": deviceToken,
  //   };
  // }

  // Future<void> onSubmit(BuildContext context) async {
  //   final token = await DataPreferences.getData('firebaseToken');
  //   final isValid = await validateSignupFields(context);
  //   if (!isValid) return;

  //   isLoading = true;
  //   notifyListeners();

  //   try {
  //     final response = await _repository.postApi(
  //       ApiUrl.baseUrl + ApiUrl.signUp,
  //       getFormData(token ?? ''),
  //     );

  //     final userDataMain = UserDataMain.fromJson(response);

  //     if (userDataMain.errorCode == 200 || userDataMain.errorCode == 201) {
  //       saveUserData(userDataMain.userData!);
  //       AppUtils.showToastGreenBg(
  //           context, userDataMain.message ?? "Signup successful");
  //       Navigator.pushNamedAndRemoveUntil(
  //         context,
  //         'detail_setup',
  //         (route) => false,
  //         arguments: '',
  //       );
  //     } else {
  //       AppUtils.showToastRedBg(
  //           context, userDataMain.message ?? "Something went wrong");
  //     }
  //   } catch (error) {
  //     AppUtils.showToastRedBg(context, error.toString());
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  String nationalityId = '';
  String jobId = '';

// submit profile page
  // Future<void> callSubmitProfileApi(
  //     BuildContext context, String imagePath, String filePath) async {
  //   // Check mandatory fields
  //   bool isValid = await checkMandatoryFields(context);
  //   if (!isValid) {
  //     return;
  //   }
  //   isLoading = true;
  //   Map<String, dynamic> fields = {
  //     'loc_address': fullAddress,
  //     'user_id': Global.userData!.userId.toString(),
  //     'nationality_id': nationalityId,
  //     'nationality': nationalityController.text.toString(),
  //     'job_title_id': jobId,
  //     'job_title': jobTitleController.text.toString(),
  //     'dob': dateController.text.toString(),
  //     'passport_no': passportController.text.toString(),
  //     'gender': selectedGender,
  //     'notes': quillNotesController.document.toPlainText(),
  //     'latitude': AppUtils.latitude.toString(),
  //     'longitude': AppUtils.longitude.toString(),
  //   };

  //   // Initialize an empty list to hold files
  //   // Function to check file size
  //   Future<bool> isFileSizeValid(String path) async {
  //     final file = File(path);
  //     final sizeInBytes = await file.length();
  //     const maxSizeInBytes = 2 * 1024 * 1024; // 2 MB
  //     return sizeInBytes <= maxSizeInBytes;
  //   }

  //   // Validate file size for imagePath
  //   MultipartFile? profileImageFile;
  //   if (imagePath.isNotEmpty) {
  //     profileImageFile = await Global.networkService!.createMultipartFile(
  //       imagePath,
  //       imagePath.split('/').last,
  //     );
  //   }

  //   // Validate file size for filePath
  //   MultipartFile? resumeFile;
  //   if (filePath.isNotEmpty) {
  //     final isValidSize = await isFileSizeValid(filePath);
  //     if (!isValidSize) {
  //       AppUtils.showToastRedBg(
  //           context, 'Document file size cannot exceed 2 MB');
  //       return;
  //     }
  //     resumeFile = await Global.networkService!.createMultipartFile(
  //       filePath,
  //       filePath.split('/').last,
  //     );
  //   }

  //   // Upload the file(s) (if any)
  //   var responseData = await Global.networkService!.postDataWithFile(
  //       ApiUrl.setProfile,
  //       fields,
  //       'profile_img',
  //       profileImageFile,
  //       'cv_url',
  //       resumeFile, (int sentBytes, int totalBytes) {
  //     double progress = (sentBytes / totalBytes) * 100;
  //     _setUploadPercentage(progress); // Update the upload percentage
  //   });

  //   // Handle the response
  //   if (responseData != null) {
  //     UserDataMain userDataMain = UserDataMain.fromJson(responseData);
  //     if (userDataMain.errorCode == 200) {
  //       saveUserData(userDataMain.userData!);
  //       AppUtils.showToastGreenBg(context, "Success");
  //       Navigator.pushNamedAndRemoveUntil(
  //         context,
  //         'base_class',
  //         (route) => false,
  //         arguments: '',
  //       );
  //     } else {
  //       AppUtils.showToastRedBg(context, "Error");
  //     }

  //     // UniversalInit.commonImageAttachment = null;
  //     // groupController.text = '';
  //   } else {
  //     AppUtils.showToastRedBg(context, 'API not responding');
  //   }
  //   isLoading = false;
  // }

  // double uploadPercentage = 0; // Add a field to track upload progress
  // // Update upload percentage and notify listeners
  // void _setUploadPercentage(double value) {
  //   uploadPercentage = value;
  //   notifyListeners();
  // }

  // common search

//   void callLocationSearch(BuildContext context, {required int type}) {
//     String url = '';
//     // Define the URL based on the type
//     switch (type) {
//       case 1:
//         url = ApiUrl.countryCommonSearch;
//         break;
//       case 2:
//         url = ApiUrl.getJobCategory;
//         break;
//       default:
//         throw ArgumentError('Invalid type passed to callLocationSearch');
//     }
//     // Navigate to the search screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CommonPaginationSearching(
//           url: ApiUrl.baseUrl + url,
//           requiredSearchList: [],
//           lookupCode: '',
//         ),
//       ),
//     ).then((value) {
//       // Check the returned value
//       if (value != null) {
//         SearchList data = value;
//         if (type == 1) {
//           nationalityId = data.ocNationalityId.toString();
//           nationalityController.text = data.ocNationality.toString();
//         }
//         if (type == 2) {
//           jobId = data.ocId.toString();
//           jobTitleController.text = data.ocDesc.toString();
//         }

// //
//       }
//       notifyListeners();
//     });
//   }

// SetProfile
  // void getProfile() {
  //   if (Global.userData != null) {
  //     if (Global.userData!.activity == 4) {
  //       locationController.text = Global.userData!.locAddress.toString();
  //       nationalityController.text = Global.userData!.nationality.toString();
  //       jobTitleController.text = Global.userData!.jobTitle.toString();
  //       dateController.text = Global.userData!.dob.toString();
  //       passportController.text = Global.userData!.passportNo.toString();
  //       selectedGender = Global.userData!.gender.toString();
  //       // ✅ Update Quill controller with user's notes
  //       final plainText = Global.userData!.notes ?? '';
  //       final doc = Document()..insert(0, plainText);
  //       quillNotesController = QuillController(
  //         document: doc,
  //         selection: const TextSelection.collapsed(offset: 0),
  //       );

  //       if (Global.userData!.profileImg != null &&
  //           Global.userData!.profileImg!.isNotEmpty) {
  //         final String fullProfileImageUrl =
  //             "${ApiUrl.baseUrl}${Global.userData!.profileImg!.replaceFirst('/', '')}";
  //         profileImageUrl = fullProfileImageUrl;
  //       }

  //       // Set CV URL
  //       if (Global.userData!.cvUrl != null &&
  //           Global.userData!.cvUrl!.isNotEmpty) {
  //         final String fullCvUrl =
  //             "${ApiUrl.baseUrl}${Global.userData!.cvUrl!.replaceFirst('/', '')}";
  //         uploadedFileUrl = fullCvUrl;
  //       }
  //     }
  //   }
  // }

  // Save user data
  // void saveUserData(UserData userData) async {
  //   await DataPreferences.saveEmpData(userData);
  //   Global.userData = await DataPreferences.loadEmpData();
  // }

  // Dispose controllers

  //

  // void saveRememberMeData() {
  //   DataPreferences.saveData('userName', phoneController.text.toString());
  //   DataPreferences.saveData('password', passwordController.text.toString());
  //   DataPreferences.saveDataBoolVal('isRemember', isRemember);
  //   phoneController.text = '';
  //   passwordController.text = '';
  // }

  // bool isRemember = false;

  // void setIsRemember(bool val) {
  //   isRemember = val;
  //   notifyListeners();
  // }

  // set it to false when u achieve what u want in the api
  // void setdisable(bool val) {
  //   isdisable = val;
  //   notifyListeners();
  // }

  // void setIsRememberValue() async {
  //   isRemember = (await DataPreferences.getBoolData('isRemember'))!;
  //   if (isRemember) {
  //     phoneController.text = (await DataPreferences.getData('userName'))!;
  //     passwordController.text = (await DataPreferences.getData('password'))!;

  //     setdisable(false);
  //   } else {
  //     setdisable(true);
  //   }
  // }

  resetController() {
    emailController.clear();
    passwordController.clear();
  }

  void resetForm() {
    profileImage = null;
    uploadedFile = null;

    notifyListeners();
  }

  // void logout(BuildContext context) async {
  //   DataPreferences.removeData("userData");
  //   Global.userData = null;
  //   passportController.clear();
  //   phoneController.clear();
  //   Navigator.pushNamedAndRemoveUntil(
  //       context, LoginScreen.id, (route) => false);
  // }

  @override
  void dispose() {
    emailController.dispose();

    passwordController.dispose();

    super.dispose();
  }

  bool isPassword = true;

  void setIsPassword() {
    isPassword = isPassword ? false : true;
    notifyListeners();
  }
}
