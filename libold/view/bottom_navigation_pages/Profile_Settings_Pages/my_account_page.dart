// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last, avoid_print, prefer_final_fields, unused_element, unused_field, use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/widget/common_text.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccount extends StatefulWidget {
  static const String id = "account_details";
  const MyAccount({super.key});

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  // New fields to display
  final List<String> _additionalFields = [
    'Company ',
    'FireBase Token',
    'Employee ',
    'Division ',
    'Department ',
    'Project ',
  ];
  final LocalAuthentication auth = LocalAuthentication();
  bool hasCancelledBiometric = false;
  bool _isBiometricEnabled = false;
  Map<String, bool> _fieldVisibility = {};
  Future<void> _loadBiometricStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBiometricEnabled = prefs.getBool('isBiometricEnabled') ?? false;
    });
  }

  Future<bool> _checkBiometricAvailability() async {
    if (hasCancelledBiometric) return false;

    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (canCheckBiometrics) {
        bool authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to view sensitive data.',
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );

        if (authenticated) {
          AppUtils.showToastGreenBg(
              context, "Biometric authentication successful.");
          return true; // Indicate success
        } else {
          AppUtils.showToastRedBg(context, "Biometric authentication failed.");
          return false; // Indicate failure
        }
      } else {
        AppUtils.showToastRedBg(
            context, "Biometric authentication not available on this device.");
        return false; // Indicate failure
      }
    } catch (e) {
      print("Error during biometric check: $e");
      AppUtils.showToastRedBg(
          context, "Error during biometric authentication.");
      return false; // Indicate failure
    }
  }

  bool _showQr = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricStatus();

    _fieldVisibility = {
      'Company ': true,
      'FireBase Token': false,
      'Employee ': false,
      'Division ': true,
      'Department ': true,
      'Project ': true,
    };
  }

  @override
  Widget build(BuildContext context) {
    double bigText = context.resources.dimension.appBigText;
    Color themeColor = context.resources.color.themeColor;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: themeColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: CommonTextView(
          label: 'Account Details',
          color: Colors.white,
          fontFamily: 'Bold',
          fontSize: bigText + 4,
        ),
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              ClipPath(
                clipper: CurveClipper(),
                child: Container(
                  width: double.infinity,
                  height: 120,
                  color: themeColor,
                ),
              ),
              Positioned(
                top: 30,
                child: InkWell(
                  onTap: () {
                    if (Global.empData!.fileName != null &&
                        Global.empData!.fileName!.isNotEmpty) {
                      _openImageDialog();
                    } else {
                      AppUtils.showToastRedBg(context, "Image Is Not Availble");
                    }
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: Global.empData!.media == 1
                        ? NetworkImage(ApiUrl.baseUrl! +
                            Global.empData!.fileName.toString())
                        : null,
                    child: Global.empData!.media != 1
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                    backgroundColor: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          CommonTextView(
            label: Global.empData!.empName.toString(),
            fontSize: bigText + 6,
            fontFamily: 'Bold',
            color: Colors.black87,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _showQr ? _buildQrSection() : Container(),
          Expanded(
            child: ListView.builder(
              itemCount: _additionalFields.length + 1, // Adjust item count
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    leading: Icon(Icons.qr_code, color: themeColor),
                    title: Text(
                      _showQr ? 'Hide QR' : 'Show QR',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Regular',
                        color: Colors.black87,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _showQr = !_showQr;
                      });
                    },
                  );
                } else {
                  int additionalIndex = index - 1;
                  String fieldTitle = _additionalFields[additionalIndex];

                  String? value;
                  switch (fieldTitle) {
                    case 'Company ':
                      value =
                          '${Global.empData?.companyId ?? ''} - ${Global.empData?.companyName ?? ''}';
                      //Global.empData?.companyId.toString();
                      break;

                    case 'FireBase Token':
                      value = (Global.firebaseToken != null &&
                              Global.firebaseToken!.isNotEmpty)
                          ? 'Token available'
                          : 'Token not available';
                      break;
                    case 'Employee ':
                      value =
                          '${Global.empData?.empId ?? ''} - ${Global.empData?.empCode ?? ''}';
                      // Global.empData?.empCode;
                      break;
                    case 'Division ':
                      value =
                          '${Global.empData?.divisionCode ?? ''} - ${Global.empData?.divisionDesc ?? ''}';
                      break;

                    case 'Department ':
                      value =
                          '${Global.empData?.deptCode ?? ''} - ${Global.empData?.deptDesc ?? ''}';
                      break;

                    case 'Project ':
                      value =
                          '${Global.empData?.projCode ?? ''} - ${Global.empData?.projDesc ?? ''}';
                      break;

                    default:
                      value = '';
                  }

                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '$fieldTitle: ',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Bold', // Bold for field names
                                    color: Colors.black87,
                                  ),
                                ),
                                TextSpan(
                                  text: _fieldVisibility[fieldTitle]!
                                      ? value
                                      : "****",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Regular',
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _fieldVisibility[fieldTitle]!
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () async {
                            bool authenticated =
                                await _checkBiometricAvailability();
                            if (authenticated) {
                              setState(() {
                                _fieldVisibility[fieldTitle] =
                                    !_fieldVisibility[fieldTitle]!;
                              });
                            } else {
                              AppUtils.showToastRedBg(
                                  context, "Unable to toggle visibility.");
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      print('Tapped on: $fieldTitle');
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrSection() {
    return Column(
      children: [
        CommonTextView(
          label: ApiUrl.baseUrl!,
          fontFamily: 'Bold',
        ),
        QrImageView(
          data:
              '${Global.empData!.key}-${Global.empData!.id}-${ApiUrl.baseUrl}',
          version: QrVersions.auto,
          size: 150,
          errorCorrectionLevel: QrErrorCorrectLevel.H,
          gapless: false,
          embeddedImage:
              const AssetImage('assets/images/sendan_logo_white_bg.jpg'),
          embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(0, 35)),
          backgroundColor: Colors.white,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonTextView(
              label: Global.empData!.key.toString(),
              fontFamily: 'Bold',
            ),
            const SizedBox(width: 10),
            CommonTextView(
              label: Global.empData!.id.toString(),
              fontFamily: 'Bold',
            ),
          ],
        ),
      ],
    );
  }

  void _openImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Get the image URL from your data
        String imageUrl = ApiUrl.baseUrl! + Global.empData!.fileName.toString();

        return Dialog(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: InteractiveViewer(
                  panEnabled: true, // Enables panning
                  boundaryMargin: const EdgeInsets.all(20),
                  minScale: 0.5, // Minimum zoom scale
                  maxScale: 4.0, // Maximum zoom scale
                  child: Global.empData!.media == 1
                      ? Image.file(
                          File(Global.empData!.fileName.toString()),
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )),
            ),
          ),
        );
      },
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
