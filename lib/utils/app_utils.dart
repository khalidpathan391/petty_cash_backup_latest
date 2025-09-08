// ignore_for_file: deprecated_export_use

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petty_cash/data/models/custom/upload_progress.dart';
import 'package:petty_cash/data/sources/local/shared_preference.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/view/base/BaseGestureTouchSafeArea.dart';
import 'package:petty_cash/view/common/CustomLoaders/custom_refresh.dart';
import 'package:petty_cash/view/common/expandable_fab.dart';
import 'package:petty_cash/view/widget/CustomTranslatePopUp.dart';
import 'package:petty_cash/view/widget/common_button.dart';
import 'package:petty_cash/view/widget/common_text.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';

class AppUtils {
  static double latitude = 0.0;
  static double longitude = 0.0;

  BuildContext? context;
  static String imagePath = '';

  static String apiErrorMessage = '';
  DialogClickListener? listener;
  int? type;
  dynamic provider;
  AppUtils(this.context);
  AppUtils.withListener(this.listener, this.provider, {this.type = 0});
  static void getDeviceDetails() async {
    String deviceName = "";
    String deviceVersion = "";
    String identifier = "";
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.id;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor.toString();
      } else if (Platform.isWindows) {
        var data = await deviceInfoPlugin.windowsInfo;
        deviceName = data.computerName;
        deviceVersion = data.majorVersion.toString();
        identifier = data.deviceId.toString();
      } else if (Platform.isMacOS) {
        var data = await deviceInfoPlugin.macOsInfo;
        deviceName = data.computerName;
        deviceVersion = data.majorVersion.toString();
        identifier = data.systemGUID.toString();
      } else if (Platform.isLinux) {
        var data = await deviceInfoPlugin.linuxInfo;
        deviceName = data.name;
        deviceVersion = data.version.toString();
        identifier = data.id.toString();
      } else if (kIsWeb) {
        var data = await deviceInfoPlugin.webBrowserInfo;
        deviceName = data.browserName.name;
        deviceVersion = data.appVersion.toString();
        identifier = 'NotFound'; //UUID for iOS
      }
      Global.deviceId = identifier;
      Global.deviceModel = deviceName;
      Global.deviceVersion = deviceVersion;
    } on PlatformException {
      // print('Failed to get platform version');
    }
  }

  void confirmationYesNoDialog(BuildContext context, String title, String msg,
      {String? rejectText, String? acceptText}) {
    Color myColor = context.resources.color.themeColor;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0), // Set the corner radius
          ),
          title: CommonTextView(
            label: title,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          content: CommonTextView(
            label: msg,
            fontSize: 15,
            color: Colors.black,
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 20.0, vertical: 10.0), // Adjust content padding
          actionsPadding: const EdgeInsets.only(
              right: 10.0, bottom: 10.0), // Adjust actions padding
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CommonButton(
                  text: rejectText ?? 'no'.tr(),
                  textColor: Colors.white,
                  color: context.resources.color.secondaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                    listener!.clickOnNo(type!, provider);
                  },
                  fontSize: 15,
                ),
                const SizedBox(
                  width: 10,
                ),
                CommonButton(
                  text: acceptText ?? 'yes'.tr(),
                  textColor: Colors.white,
                  color: context.resources.color.themeColor,
                  onPressed: () {
                    Navigator.pop(context);
                    listener!.clickOnYes(type!, provider);
                  },
                  fontSize: 15,
                ),
              ],
            ),
          ],
        );
      },
    ).then((value) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        AppUtils.changeStatusBarColor(myColor);
      });
    });
  }

  static void showPhotoDialog(
      BuildContext context, String name, String imageUrl,
      {bool isOnline = true}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CommonTextView(
                label: name,
                fontSize: context.resources.dimension.appBigText,
                color: context.resources.color.themeColor,
                textAlign: TextAlign.center,
                overFlow: TextOverflow.ellipsis,
                maxLine: 3,
                width: AppWidth(200),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  size: 18,
                  color: context.resources.color.themeColor,
                ),
              ),
            ],
          ),
          content: InteractiveViewer(
            maxScale: 10,
            child: isOnline
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit
                        .cover, // Ensure the image covers the entire container
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : Image.file(
                    // Display the image using the File widget
                    File(imageUrl),
                    fit: BoxFit.cover,
                  ),
          ),
          actions: null,
        );
      },
    );
  }

  static void customLoader(BuildContext context, {bool isDefault = true}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (didPop) {
                return;
              }
            },
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              title: null,
              content: CustomLoader(
                isDefault: isDefault,
              ),
              actions: const [],
            ));
      },
    );
  }

  static void showSubmit(
    BuildContext context, {
    Function(String)? onSubmit,
    Function(String)? onChange,
    required TextEditingController controller,
    String label = 'Comment',
    CancelToken? cancelToken, //not used
  }) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        //To make stateless widget state full
        return StatefulBuilder(
            builder: (BuildContext ctx1, StateSetter myState) {
          final picker = ImagePicker();
          return PopScope(
            canPop: true,
            onPopInvoked: (didPop) {
              if (didPop) {
                return;
              }
            },
            child: BaseGestureTouchSafeArea(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(4.0), // Set the corner radius
                ),
                title: Row(
                  children: [
                    CommonTextView(
                      label: label,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    // Expanded(child: child),
                    //Manage the file
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //view file
                          if (imagePath.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                List<String> parts = imagePath.split('.');
                                String extension = parts.last
                                    .toLowerCase(); // Return the last part as lowercase
                                if (extension == 'jpg' ||
                                    extension == 'jpeg' ||
                                    extension == 'png') {
                                  AppUtils.showPhotoDialog(
                                      context, 'Selected Image', imagePath,
                                      isOnline: false);
                                } else {
                                  AppUtils.showToastRedBg(
                                      context, 'file not supported');
                                }
                              },
                              child: const Icon(Icons.remove_red_eye),
                            ),
                          const SizedBox(
                            width: 4,
                          ),
                          //picking file
                          GestureDetector(
                            onTap: imagePath.isNotEmpty
                                ? () {
                                    AppUtils.showToastRedBg(
                                        context, 'One Attachment Only');
                                  }
                                : () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext ctx3) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              //Camera
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.camera,
                                                  size: 30,
                                                ),
                                                title: CommonTextView(
                                                  label: 'Camera',
                                                  fontSize: context
                                                          .resources
                                                          .dimension
                                                          .appBigText +
                                                      3,
                                                  fontFamily: 'Bold',
                                                ),
                                                onTap: () {
                                                  picker
                                                      .pickImage(
                                                          source: ImageSource
                                                              .camera)
                                                      .then((value) {
                                                    if (value != null) {
                                                      imagePath = value.path;
                                                      myState(() {});
                                                    } else {
                                                      AppUtils.showToastRedBg(
                                                          context,
                                                          'No Item Selected');
                                                    }
                                                  }).onError(
                                                          (error, stackTrace) {
                                                    AppUtils.showToastRedBg(
                                                        context,
                                                        'error:$error');
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),

                                              //Gallery
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.photo,
                                                  size: 30,
                                                ),
                                                title: CommonTextView(
                                                  label: 'Gallery',
                                                  fontSize: context
                                                          .resources
                                                          .dimension
                                                          .appBigText +
                                                      3,
                                                  fontFamily: 'Bold',
                                                ),
                                                onTap: () {
                                                  picker
                                                      .pickImage(
                                                          source: ImageSource
                                                              .gallery)
                                                      .then((value) {
                                                    if (value != null) {
                                                      imagePath = value.path;
                                                      myState(() {});
                                                    } else {
                                                      AppUtils.showToastRedBg(
                                                          context,
                                                          'No Item Selected');
                                                    }
                                                  }).onError(
                                                          (error, stackTrace) {
                                                    AppUtils.showToastRedBg(
                                                        context,
                                                        'error:$error');
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),

                                              //All Files
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.insert_drive_file,
                                                  size: 30,
                                                ),
                                                title: CommonTextView(
                                                  label: 'All Files',
                                                  fontSize: context
                                                          .resources
                                                          .dimension
                                                          .appBigText +
                                                      3,
                                                  fontFamily: 'Bold',
                                                ),
                                                onTap: () {
                                                  //File picker
                                                  FilePicker.platform
                                                      .pickFiles()
                                                      .then((value) {
                                                    if (value != null) {
                                                      imagePath = value
                                                          .files.single.path!;
                                                      myState(() {});
                                                    } else {
                                                      AppUtils.showToastRedBg(
                                                          context,
                                                          'No Item Selected');
                                                    }
                                                  }).onError(
                                                          (error, stackTrace) {
                                                    AppUtils.showToastRedBg(
                                                        context,
                                                        'error:$error');
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                            child: Transform.rotate(
                                angle: -45,
                                child: const Icon(Icons.attachment_outlined)),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          //delete file
                          if (imagePath.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                imagePath = '';
                                myState(() {});
                              },
                              child: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                            ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: context.resources.color.themeColor,
                      ),
                    ),
                  ],
                ),
                content: CommonTextFormField(
                  label: 'Type your remarks here',
                  height: AppHeightP(25),
                  width: AppWidthP(75),
                  maxLines: 100,
                  keyboardType: TextInputType.multiline,
                  controller: controller,
                  onChanged: onChange,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0), // Adjust content padding
                actionsPadding: const EdgeInsets.only(
                    right: 10.0, bottom: 10.0), // Adjust actions padding
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CommonButton(
                        text: 'Close'.tr(),
                        textColor: Colors.white,
                        color: context.resources.color.secondaryColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        fontSize: 15,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CommonButton(
                        text: 'Submit'.tr(),
                        textColor: Colors.white,
                        color: context.resources.color.themeColor,
                        onPressed: () {
                          Navigator.pop(context);
                          onSubmit!(imagePath);
                        },
                        fontSize: 15,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  /// Show common toast
  /// */
  static void showToastRedBg(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    showToast(message,
        context: context,
        axis: Axis.horizontal,
        alignment: Alignment.center,
        duration: duration,
        backgroundColor: context.resources.color.colorRed,
        textStyle: TextStyle(
            fontFamily: 'Bold',
            fontSize: context.resources.dimension.appMediumText,
            color: context.resources.color.colorWhite),
        // textPadding:
        // EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        // borderRadius: BorderRadius.vertical(
        //     top: Radius.elliptical(5.0, 10.0),
        //     bottom: Radius.elliptical(5.0, 10.0)),
        textAlign: TextAlign.justify,
        position: StyledToastPosition.top);
  }

  static void showToastGreenBg(BuildContext context, String message) {
    showToast(message,
        context: context,
        axis: Axis.horizontal,
        alignment: Alignment.center,
        duration: const Duration(seconds: 3),
        backgroundColor: context.resources.color.colorGreen,
        textStyle: TextStyle(
            fontFamily: 'Bold',
            fontSize: context.resources.dimension.appMediumText,
            color: context.resources.color.colorWhite),
        // textPadding:
        // EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        // borderRadius: BorderRadius.vertical(
        //     top: Radius.elliptical(5.0, 10.0),
        //     bottom: Radius.elliptical(5.0, 10.0)),
        textAlign: TextAlign.justify,
        position: StyledToastPosition.top);
  }

  //Color(0x33607D8B) = Colors.blueGrey.withOpacity(.2)
  static void showToastAnyBg(
    BuildContext context,
    String message, {
    Color color = const Color(0x33607D8B),
    Color textColor = Colors.black,
  }) {
    showToast(message,
        context: context,
        axis: Axis.horizontal,
        alignment: Alignment.center,
        duration: const Duration(seconds: 3),
        backgroundColor: color,
        textStyle: TextStyle(
            fontFamily: 'Bold',
            fontSize: context.resources.dimension.appMediumText,
            color: textColor),
        // textPadding:
        // EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        // borderRadius: BorderRadius.vertical(
        //     top: Radius.elliptical(5.0, 10.0),
        //     bottom: Radius.elliptical(5.0, 10.0)),
        textAlign: TextAlign.justify,
        position: StyledToastPosition.top);
  }

  Widget getCommonErrorWidget(VoidCallback? onTryAgain, String? myError) {
    IconData iconData = Icons.error_outline;
    if (errorMessage == noInternet) {
      iconData = Icons.wifi_off_outlined;
    } else if (errorMessage == noDataFound) {
      // iconData = Icons.error_outline;
    } else if (errorMessage == timeOut) {
      iconData = Icons.timer_off_outlined;
    } else if (myError!.isNotEmpty) {
      errorMessage = myError;
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 100,
              color: context!.resources.color.themeColor,
            ),
            const SizedBox(height: 16),
            // CommonTextViewView(
            //   label: errorMessage,
            //   textAlign: TextAlign.center,
            //   fontSize: 16.0,
            // ),
            // const SizedBox(height: 16),
            // CommonButton(
            //   text: 'tryAgain',
            //   margin: const EdgeInsets.only(left: 50, right: 50),
            //   onPressed: onTryAgain!,
            // ),
          ],
        ),
      ),
    );
  }

  static const String noInternet =
      'Please check your internet connection. No internet connection detected.';
  static const String timeOut = 'Server is unresponsive due to timeout.';
  static const String noDataFound = 'No data found.';
  static String errorMessage = '';

  static void yesNoDialog(BuildContext context, String title, String msg,
      {VoidCallback? onYes,
      VoidCallback? onNo,
      bool isImage = false,
      File? image,
      int isType = 0,
      String? text1,
      String? text2}) {
    Color myColor = context.resources.color.themeColor;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0), // Set the corner radius
          ),
          // title: CommonTextViewView(
          //   label: title,
          //   fontWeight: FontWeight.bold,
          //   fontSize: 18,
          // ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // CommonTextViewView(
              //   label: msg,
              //   fontSize: 15,
              //   padding: EdgeInsets.only(bottom: AppHeight(10)),
              //   color: Colors.black,
              // ),
              // if (isImage)
              //   Image.file(
              //     // Display the image using the File widget
              //     image ?? File(''),
              //     height: AppHeightP(50),
              //     fit: BoxFit.cover,
              //   ),
            ],
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          // Adjust content padding
          actionsPadding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
          // Adjust actions padding
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                isType == 1
                    ? const SizedBox()
                    : CommonButton(
                        text: text2 ?? 'no'.tr(),
                        textColor: Colors.white,
                        color: context.resources.color.secondaryColor,
                        onPressed: () {
                          Navigator.pop(context);
                          onNo!();
                        },
                        fontSize: 15,
                      ),
                const SizedBox(
                  width: 10,
                ),
                CommonButton(
                  text: text1 ?? 'yes'.tr(),
                  textColor: Colors.white,
                  color: context.resources.color.themeColor,
                  onPressed: () {
                    Navigator.pop(context);
                    onYes!();
                  },
                  fontSize: 15,
                ),
              ],
            ),
          ],
        );
      },
    ).then((value) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        AppUtils.changeStatusBarColor(myColor);
      });
    });
  }

  static void changeStatusBarColor(Color color) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: color,
      // Set status bar color
      systemNavigationBarColor: color,
      statusBarBrightness: Brightness.light,
      // Adjust status bar brightness if needed
      systemNavigationBarContrastEnforced: true,
      systemStatusBarContrastEnforced: true,
    ));
  }

  static List<Locale> getLangList() {
    return const [
      Locale('en', 'US'), // English
      Locale('ar', 'SA'), // Arabic
      Locale('hi', 'IN'), // Hindi
      Locale('ml', 'IN'), // Malayalam
      Locale('te', 'IN'), // Telugu
      Locale('ta', 'IN'), // Tamil
      Locale('kn', 'IN'), // Kannada
      Locale('ko', 'KR'), // Korean
      Locale('tl', 'PH'), // Tagalog
      Locale('bn', 'BD'), // Bengali
      Locale('ur', 'PK'), // Urdu (Pakistan)
    ];
  }

// Date Picker
  static Future<void> showDatePickerAndUpdate(
    BuildContext context,
    Function(String) updateDate, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    bool enforceAgeLimit = false, // Optional age limit
  }) async {
    DateTime now = DateTime.now();

    // If enforceAgeLimit is true, restrict selection between 18 to 60 years old
    DateTime minAllowedDate = enforceAgeLimit
        ? now.subtract(Duration(days: 60 * 365))
        : (firstDate ?? DateTime(2000));
    DateTime maxAllowedDate = enforceAgeLimit
        ? now.subtract(Duration(days: 18 * 365))
        : (lastDate ?? DateTime(2100));

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: enforceAgeLimit ? maxAllowedDate : (initialDate ?? now),
      // Default today if no age limit
      firstDate: minAllowedDate,
      lastDate: maxAllowedDate,
    );

    if (pickedDate != null) {
      final formattedDate =
          DateFormat('yyyy-MM-dd', 'en_US').format(pickedDate);
      updateDate(formattedDate);
    }
  }

  // Custom Date Picker with CommonButton and dd-MMM-yyyy format
  static Future<void> showCustomDatePickerAndUpdate(
    BuildContext context,
    Function(String) updateDate, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.resources.color.themeColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
              secondary: context.resources.color.themeColor,
              onSecondary: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: context.resources.color.themeColor,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: context.resources.color.themeColor,
              ),
            ),
            checkboxTheme: CheckboxThemeData(
              fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return context.resources.color.themeColor;
                }
                return Colors.transparent;
              }),
              checkColor: MaterialStateProperty.all(Colors.white),
              side: BorderSide(
                color: context.resources.color.themeColor,
                width: 2.0,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Format date as dd-MMM-yyyy (e.g., 07-Sep-2025)
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];

      final day = pickedDate.day.toString().padLeft(2, '0');
      final month = months[pickedDate.month - 1];
      final year = pickedDate.year;

      final formattedDate = '$day-$month-$year';
      updateDate(formattedDate);
    }
  }

// permission handler
  static Future<bool> requestPermissionAndGetLocation() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude = position.latitude;
      longitude = position.longitude;
      return true;
    }
    return false;
  }

  static String formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (math.log(bytes) / math.log(1024)).floor();
    return '${(bytes / math.pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }

  static void dioUploadLoader(
      BuildContext context,
      ValueNotifier<UploadProgress> progress,
      bool isApiLoading,
      CancelToken cancelToken) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          //diff name so no context clash
          return PopScope(
            canPop: !isApiLoading,
            child: AlertDialog(
              content: ValueListenableBuilder<UploadProgress>(
                valueListenable: progress,
                builder: (ctx2, value, child) {
                  //diff name so no context clash
                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...value.progress != 1
                            ? [
                                LinearProgressIndicator(
                                  value: value.progress,
                                  backgroundColor: context
                                      .resources.color.themeColor
                                      .withOpacity(.5),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      context.resources.color.themeColor),
                                  minHeight: 2,
                                ),
                                CommonTextView(
                                  label:
                                      '${AppUtils.formatBytes(value.sentBytes)} / ${AppUtils.formatBytes(value.totalBytes)}',
                                  padding: const EdgeInsets.only(top: 10),
                                ),
                                CommonTextView(
                                  label:
                                      'Uploading : ${(value.progress * 100).toStringAsFixed(0)}%',
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ]
                            : [
                                LinearProgressIndicator(
                                  backgroundColor: context
                                      .resources.color.themeColor
                                      .withOpacity(.5),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      context.resources.color.themeColor),
                                  minHeight: 2,
                                ),
                                const CommonTextView(
                                  label: 'Syncing Data ...',
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                ),
                              ],
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  //flag function
  /* static String convertUnicodeToFlag(String unicode) {
    // Split the string by Unicode escape sequences and convert each to a character
    List<int> codeUnits = [];
    unicode.split(RegExp(r'\\u[0-9A-Fa-f]{4}')).forEach((code) {
      if (code.isNotEmpty) {
        final int unicodePoint = int.parse(code, radix: 16);
        codeUnits.add(unicodePoint);
      }
    });
    return String.fromCharCodes(codeUnits);
  }*/

  static String convertUnicodeToFlag(String unicode) {
    // Match all Unicode escape sequences (e.g., \uD83C\uDDE6)
    final RegExp unicodeRegex = RegExp(r'\\u[0-9A-Fa-f]{4}');

    // Replace each match with its corresponding Unicode character
    return unicode.replaceAllMapped(unicodeRegex, (match) {
      int codePoint =
          int.parse(match.group(0)!.substring(2), radix: 16); // Skip '\\u'
      return String.fromCharCode(codePoint);
    });
  }

// Download storage
  static Future<bool> storagePermission() async {
    bool permissionStatus;
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      if (deviceInfo.version.sdkInt > 32) {
        permissionStatus = await Permission.photos.request().isGranted;
      } else {
        permissionStatus = await Permission.storage.request().isGranted;
      }
      return permissionStatus;
    } else {
      //for ios manage
      return false;
    }
  }

  static bool isValidated(BuildContext context, String id, String key) {
    AppUtils.getDeviceDetails();
    if (id == '') {
      AppUtils.showToastRedBg(context, 'plzEnterValidId'.tr());
      return false;
    } else if (key == '') {
      AppUtils.showToastRedBg(context, 'plzEnterValidKey'.tr());
      return false;
    }
    int finalS =
        int.parse(id) + int.parse(id.substring(id.length - 3)) * 3 + 121;
    try {
      final bytes = utf8.encode(finalS.toString());
      String base64Str = base64.encode(bytes);
      //String newStr = base64Str.replaceAll("[^A-Za-z]+", "");
      String newStr = base64Str.replaceAll(RegExp("[^A-Za-z]+"), "");
      String toUpperCase = newStr.toUpperCase();
      if (toUpperCase == key) {
        DataPreferences.saveData("auth_id", id);
        DataPreferences.saveData("auth_key", key);
        return true;
      } else {
        AppUtils.showToastRedBg(context, "Please enter valid id & key");
        return false;
      }
    } on Exception {
      // print('error');
    }
    return false;
  }

  static bool validateURL(String input) {
    final RegExp urlRegex = RegExp(
        '^(?:http|https)://[\\w.-]+(?:\\.[\\w\\.-]+)+(?:[\\w\\-\\._~:/?#[\\]@!\$&\'\\(\\)\\*\\+,;=.])*\$');
    return urlRegex.hasMatch(input);
  }

  static String showGoodMessage() {
    DateTime now = DateTime.now();
    int hour = now.hour;
    String greeting = '';
    if (hour < 12) {
      greeting = 'good_morning'.tr();
    } else if (hour < 18) {
      greeting = 'good_afternoon'.tr();
    } else {
      greeting = 'good_evening'.tr();
    }
    return greeting;
  }

  static Color generateSecondaryColorWithContrast(Color primaryColor) {
    // Convert primary color to HSL
    final hslPrimary = HSLColor.fromColor(primaryColor);

    // Calculate the complementary hue
    final double complementaryHue = (hslPrimary.hue + 180.0) % 360.0;

    // Determine the lightness for the secondary color to ensure contrast
    final double complementaryLightness =
        hslPrimary.lightness > 0.5 ? 0.2 : 0.8;

    // Create the complementary color with the complementary hue and adjusted lightness
    final hslComplementary = HSLColor.fromAHSL(
      hslPrimary.alpha,
      complementaryHue,
      hslPrimary.saturation,
      complementaryLightness,
    );

    // Convert back to RGB color
    return hslComplementary.toColor();
  }

  static floatMenuIcon(BuildContext context) {
    return Padding(
      padding:
          Global.isArabic ? const EdgeInsets.only(right: 20) : EdgeInsets.zero,
      child: ExpandableFab(
        distance: 110,
        firstWidget: const Icon(
          Icons.more_vert_rounded,
          color: Colors.white,
        ),
        firstWidgetBgColor: context.resources.color.themeColor,
        cancelWidget: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            Icons.close,
            color: Theme.of(context).primaryColor,
          ),
        ),
        children: [
          ActionButton(
            onPressed: () {
              // Navigator.pushNamed(context, Settings.id).then((value) {});
            },
            icon: Icon(
              Icons.settings,
              color: context.resources.color.themeColor,
            ),
          ),
          ActionButton(
            onPressed: () async {
              Clipboard.getData(Clipboard.kTextPlain).then((value) {
                if (value != null) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: context.resources.color.colorTransparent,
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                        heightFactor: 0.57,
                        child: StatefulBuilder(
                          builder: (BuildContext context, StateSetter myState) {
                            return ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                              child: TranslatePopUp(
                                initialText: value.text!,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else {
                  showToastRedBg(context, 'No item copied yet');
                }
              }).onError((error, stackTrace) {
                showToastRedBg(context, 'Error while copying from clipboard');
              });
              // Navigator.pushNamed(context, TranslatePopUp.id).then((value){});
            },
            icon: Icon(
              Icons.translate,
              color: context.resources.color.themeColor,
            ),
          ),
          ActionButton(
            onPressed: () {},
            icon: Icon(
              Icons.accessibility_new,
              color: context.resources.color.themeColor,
            ),
          ),
          // ActionButton(
          //   onPressed: () {
          //     Navigator.pushNamed(context, MicroSoftTranslator.id)
          //         .then((value) {});
          //   },
          //   icon: Icon(
          //     Icons.g_translate,
          //     color: context.resources.color.themeColor,
          //   ),
          // ),
          ActionButton(
            onPressed: () {
              // Navigator.pushNamed(context, CameraToText.id).then((value) {});
            },
            icon: Icon(
              Icons.enhance_photo_translate,
              color: context.resources.color.themeColor,
            ),
          ),
        ],
      ),
    );
  }

  static Future popDialog(
    BuildContext context,
    dynamic didPop, {
    String title = 'Are you sure?',
    String content = 'Do you want to exit without saving changes?',
    bool isCancel = false,
    dynamic cancelToken,
    bool isExit = false,
  }) async {
    // canPop: !isApiLoading,//must be false to work so if api loading true i will make it false for the popup to show
    // onPopInvoked: (didPop) => AppUtils.popFunction(context,didPop),//to call the function
    final navigator = Navigator.of(context);
    if (didPop) {
      return;
    }
    bool value = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: CommonTextView(
              label: title,
              alignment: Alignment.center,
              fontFamily: 'Bold',
              fontSize: context.resources.dimension.appBigText + 5,
            ),
            content: CommonTextView(
              label: content,
              fontSize: context.resources.dimension.appBigText,
              fontFamily: 'Bold',
              maxLine: 5,
              overFlow: TextOverflow.ellipsis,
              color: Colors.red,
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CommonButton(
                    onPressed: () => Navigator.pop(context,
                        false), //pop the dialog and send the value as false
                    text: 'No',
                    color: context.resources.color.themeColor.withOpacity(.5),
                    textColor: Colors.white,
                  ),
                  CommonButton(
                    onPressed: () => Navigator.pop(context,
                        true), //pop the dialog and send the value as true
                    text: 'Yes',
                    color: context.resources.color.themeColor,
                    textColor: Colors.white,
                  ),
                ],
              )
            ],
          ),
        ) ??
        false; // ?? means giving default value as false
    if (value) {
      isExit
          ? Platform.isIOS
              ? exit(0)
              : SystemNavigator.pop()
          : navigator.pop();
      if (isCancel) {
        cancelToken.cancel('Canceled');
      }
    } //if value is true then pop or else don't
  }
}

abstract class DialogClickListener {
  void clickOnYes(int type, dynamic provider);

  void clickOnNo(int type, dynamic provider);
}
