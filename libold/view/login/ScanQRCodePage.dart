// ignore_for_file: unused_catch_clause, avoid_print

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/view/login/LoginScreen.dart';
import 'package:petty_cash/view/login/SystemURLPage.dart';
import 'package:petty_cash/view/login/common/CommonAppBar.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view_model/Authentication/AuthVM.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRCodePage extends StatefulWidget {
  static const String id = "scan_qr_page";

  const ScanQRCodePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQRCodePageState();
}

AuthVM authVM = AuthVM();

class _ScanQRCodePageState extends State<ScanQRCodePage> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    //initializing the provider in init state any function can run if needed before the page is rendered
    authVM = Provider.of(context, listen: false);
    authVM.isdisable = true;
    authVM.isQrCodeResume = false;
    super.initState();
    Global.tempAuthKey = '';
    Global.tempAuthId = '';
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            CommonAppBar(context, 1),
            SizedBox(
                height: AppHeight(250),
                width: AppWidth(414),
                child: _buildQrView(context)),
            Container(
                margin: EdgeInsets.only(
                    left: AppWidth(45),
                    right: AppWidth(45),
                    top: AppHeight(15)),
                child: Column(
                  children: [
                    CommonTextView(
                      label: 'scanYourErpQrCode',
                      fontFamily: 'Bold',
                      fontSize: context.resources.dimension.appBigText,
                      color: context.resources.color.colorBlack,
                      margin: EdgeInsets.only(bottom: AppHeight(25)),
                    ),
                    CommonTextView(
                      label: 'theQuickest',
                      margin: EdgeInsets.only(bottom: AppHeight(45)),
                      fontFamily: 'Bold',
                      fontSize: context.resources.dimension.appMediumText,
                      textAlign: TextAlign.center,
                      // onTap: () {},
                    ),
                    Visibility(
                      visible: false,
                      child: CommonTextView(
                        label: 'howDoIFind',
                        fontSize: context.resources.dimension.appBigText,
                        color: context.resources.color.themeColor,
                        fontFamily: 'Bold',
                        onTap: () {
                          Navigator.pushNamed(context, SystemUrl.Id);
                        },
                      ),
                    ),
                    SizedBox(height: AppHeight(100)),
                    CommonTextView(
                      label: 'whichMethod',
                      fontSize: context.resources.dimension.appBigText,
                      color: context.resources.color.themeColor,
                      fontFamily: 'Bold',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )),
          ],
        ),
        bottomNavigationBar: Container(
          height: 40,
          color: context.resources.color.themeColor,
          child: Row(
            children: [
              Expanded(
                  child: InkWell(
                      onTap: () async {
                        await controller?.toggleFlash();
                        setState(() {});
                      },
                      child: FutureBuilder(
                        future: controller?.getFlashStatus(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return Icon(
                              (snapshot.data! as bool)
                                  ? Icons.flash_off
                                  : Icons.flash_on,
                              color: context.resources.color.colorWhite,
                              size: 25,
                            );
                          }
                          return Icon(
                            Icons.flash_on,
                            color: context.resources.color.colorWhite,
                            size: 25,
                          );
                        },
                      ))),
              Expanded(
                  child: InkWell(
                      onTap: () async {
                        await controller?.flipCamera();
                        setState(() {});
                      },
                      child: FutureBuilder(
                        future: controller?.getCameraInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return Icon(
                              (describeEnum(snapshot.data!) == 'front')
                                  ? Icons.flip_camera_android
                                  : Icons.camera,
                              color: context.resources.color.colorWhite,
                              size: 25,
                            );
                          }
                          return Icon(
                            Icons.flip_camera_android,
                            color: context.resources.color.colorWhite,
                            size: 25,
                          );
                        },
                      ))),
              Expanded(
                  child: InkWell(
                      onTap: () async {
                        await controller?.pauseCamera();
                        setState(() {});
                      },
                      child: Icon(
                        Icons.pause,
                        color: context.resources.color.colorWhite,
                        size: 25,
                      ))),
              Expanded(
                  child: InkWell(
                      onTap: () async {
                        await controller?.resumeCamera();
                        setState(() {});
                      },
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: context.resources.color.colorWhite,
                        size: 25,
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = AppHeight(215);
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          overlayColor: const Color(0x70FFFFFF),
          borderColor: context.resources.color.colorWhite,
          borderRadius: 5,
          borderLength: 20,
          borderWidth: 8,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  // bool isNeedCall = false;

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      try {
        if (scanData.code != null && scanData.code!.isNotEmpty) {
          if (!authVM.isQrCodeResume) {
            authVM.isQrCodeResume = true;
            // callNextPage(scanData.code!.split('-')[2]);
            authVM.validate(context, scanData.code!.split('-')[1],
                scanData.code!.split('-')[0], scanData.code!.split('-')[2]);
          }
        }
        // if (AppUtils.isValidated(context, scanData.code!.split('-')[1],
        //     scanData.code!.split('-')[0])) {
        //   if (!isNeedCall) {
        //     isNeedCall = true;
        //     // callNextPage(scanData.code!.split('-')[2]);
        //     authVM.validate(context, scanData.code!.split('-')[1], scanData.code!.split('-')[0], scanData.code!.split('-')[2]);
        //   }
        // }
      } on Exception catch (c) {
        print('error');
      }
    });
  }

  void callNextPage(String baseUrl) async {
    // DataPreferences.saveData('base_url', baseUrl);
    ApiUrl.baseUrl = baseUrl;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()))
        .then((value) {
      // isNeedCall = false;
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
