// ignore_for_file: prefer_is_empty, prefer_interpolation_to_compose_strings

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/base/BaseGestureTouchSafeArea.dart';
import 'package:petty_cash/view/login/common/CommonAppBar.dart';
import 'package:petty_cash/view/widget/animated_button.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';
import 'package:petty_cash/view_model/Authentication/AuthVM.dart';
import 'package:provider/provider.dart';

class ScanQRCodeORGenerate extends StatefulWidget {
  static const String id = "scan_qr_code_or_generate";

  const ScanQRCodeORGenerate({super.key});

  @override
  ScanQRCodeORGenerateState createState() => ScanQRCodeORGenerateState();
}

//For anything before starting the page in init state you can use this instance
AuthVM authVM = AuthVM();

class ScanQRCodeORGenerateState extends State<ScanQRCodeORGenerate> {
  var myUserIdController = TextEditingController();
  var myPasswordController = TextEditingController();
  var myUrlController = TextEditingController();
  var myPortController = TextEditingController();

  @override
  void initState() {
    //initializing the provider in init state any function can run if needed before the page is rendered
    authVM = Provider.of(context, listen: false);
    authVM.isdisable = true;
    super.initState();
    myUserIdController.addListener(() {
      _updateButtonState();
    });
    myPasswordController.addListener(() {
      _updateButtonState();
    });
    myUrlController.addListener(() {
      _updateButtonState();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myUserIdController.dispose();
    myPasswordController.dispose();
    myUrlController.dispose();
  }

  void _updateButtonState() {
    if (myUserIdController.text.isNotEmpty &&
        myPasswordController.text.isNotEmpty &&
        myUrlController.text.isNotEmpty) {
      authVM.setdisable(false);
    } else {
      authVM.setdisable(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.resources.color.colorWhite,
      appBar: CommonAppBar(context, 1),
      body: BaseGestureTouchSafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              top: AppHeight(20),
              left: AppWidth(30),
              right: AppWidth(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextView(
                  label: 'getQRCode'.tr(),
                  fontSize: context.resources.dimension.appExtraBigText,
                  fontFamily: 'Bold',
                  color: Colors.black,
                  margin: EdgeInsets.only(bottom: AppHeight(10)),
                ),
                CommonTextView(
                  label: 'inTheSelf'.tr(),
                  fontSize: context.resources.dimension.appMediumText,
                  fontFamily: 'Bold',
                  color: Colors.black,
                  margin: EdgeInsets.only(
                      left: Global.isArabic ? 0 : AppWidth(5),
                      right: Global.isArabic ? AppWidth(5) : 0,
                      bottom: AppHeight(10)),
                ),
                Container(
                    margin: EdgeInsets.only(bottom: AppHeight(10)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(
                        color:
                            context.resources.color.themeColor.withOpacity(0.2),
                        width: 0.9,
                      ),
                      color: Colors.white,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/placeholder.svg',
                      height: 208,
                    )),
                Center(
                  child: CommonTextView(
                    label: 'or'.tr().toUpperCase(),
                    fontSize: context.resources.dimension.appBigText,
                    color: context.resources.color.themeColor,
                    fontFamily: 'Bold',
                    margin: EdgeInsets.only(bottom: AppHeight(10)),
                  ),
                ),
                CommonTextView(
                  label: 'generateQrCode'.tr(),
                  fontSize: context.resources.dimension.appBigText,
                  fontFamily: 'Bold',
                  margin: EdgeInsets.only(bottom: AppHeight(10)),
                ),
                CommonTextView(
                  label: 'youCanEnter'.tr(),
                  fontSize: context.resources.dimension.appMediumText,
                  fontFamily: 'Bold',
                  color: Colors.black,
                  margin: EdgeInsets.only(bottom: AppHeight(40)),
                ),
                // Center(
                //   child: Image.asset(
                //     'assets/images/sendan_logo.png',
                //     height: 60,
                //     width: 105,
                //   ),
                // ),
                CommonTextFormField(
                  label: 'enterUserName'.tr(),
                  controller: myUserIdController,
                  keyboardType: TextInputType.emailAddress,
                  margin: EdgeInsets.only(bottom: AppHeight(10)),
                ),
                CommonTextFormField(
                  label: 'enterPassword'.tr(),
                  controller: myPasswordController,
                  obscureText: true,
                  suffixIcon: true,
                  margin: EdgeInsets.only(bottom: AppHeight(10)),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: AppHeight(40)),
                  padding: EdgeInsets.only(
                      left: Global.isArabic ? 0 : AppWidth(5),
                      right: Global.isArabic ? AppWidth(5) : 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: context.resources.color.themeColor.withOpacity(.3),
                      width: 1,
                    ),
                  ),
                  child: CommonTextFormField(
                    controller: myUrlController,
                    label: 'e.g.: https://xyz.com.sa:8080',
                    // '_________________________________',
                    isBorderSideNone: true,
                    keyboardType: TextInputType.url,
                  ),
                  // Row(
                  //   children: [
                  //     CommonTextView(
                  //       label: ' https://',
                  //       color: context.resources.color.colorGrey,
                  //       fontSize: context.resources.dimension.appMediumText,
                  //     ),
                  //     Expanded(
                  //       flex: 2,
                  //       child: CommonTextFormField(
                  //         controller: myUrlController,
                  //         label: '_________________________________',
                  //         isBorderSideNone: true,
                  //         keyboardType: TextInputType.url,
                  //       ),
                  //     ),
                  //     CommonTextView(
                  //       label: '.com.sa:',
                  //       color: context.resources.color.colorGrey,
                  //       fontSize: context.resources.dimension.appMediumText,
                  //     ),
                  //     Expanded(
                  //       child: CommonTextFormField(
                  //         controller: myPortController,
                  //         label: '8080',
                  //         isBorderSideNone: false,
                  //         keyboardType: TextInputType.number,
                  //         maxLength: 4,
                  //         counterText: '',
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ),
                Consumer<AuthVM>(builder: (context, qrmaker, widget) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: AppHeight(20)),
                      child: AnimatedButton(
                        text: 'generateQr'.tr(),
                        disable: qrmaker.isdisable ? true : false,
                        onPressed: () {
                          String userName =
                              myUserIdController.text.toString().trim();
                          String password =
                              myPasswordController.text.toString().trim();
                          String url = myUrlController.text + '/';
                          // myPortController.text.toString().isEmpty
                          //     ? 'https://${myUrlController.text.toString().trim()}.com.sa/'
                          //     : 'https://${myUrlController.text.toString().trim()}.com.sa:${myPortController.text}/';
                          if (password.length < 1) {
                            qrmaker.setContainerFalse(context);
                            AppUtils.showToastRedBg(
                                context, 'passwordLength'.tr());
                          } else if (!AppUtils.validateURL(url)) {
                            qrmaker.setContainerFalse(context);
                            AppUtils.showToastRedBg(
                                context, 'plzEnterValidUrl'.tr());
                          } else {
                            Map data = {
                              'emp_code': userName,
                              'password': password,
                              'base_url': url,
                              'mobile_id': Global.mobileId,
                              'firebase_id': Global.firebaseToken,
                            };
                            authVM.callGenerateQRCodeAPI(context, data);
                          }
                        },
                      ),
                    ),
                  );
                }),
                Center(
                  child: CommonTextView(
                    label: 'tryAnother'.tr(),
                    margin: EdgeInsets.only(bottom: AppHeight(20)),
                    fontSize: context.resources.dimension.appBigText,
                    color: context.resources.color.themeColor,
                    fontFamily: 'Bold',
                    textAlign: TextAlign.center,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
