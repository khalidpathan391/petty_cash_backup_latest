// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/base/BaseGestureTouchSafeArea.dart';
import 'package:petty_cash/view/login/ScanQRCodePage.dart';
import 'package:petty_cash/view/login/SystemURLPage.dart';
import 'package:petty_cash/view/login/common/CommonAppBar.dart';
import 'package:petty_cash/view/widget/common_button.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';
import 'package:petty_cash/view_model/Authentication/AuthVM.dart';
import 'package:provider/provider.dart';

class CompanyIdActivationPage extends StatefulWidget {
  static const String id = 'id_activation';

  CompanyIdActivationPage({super.key});

  @override
  State<CompanyIdActivationPage> createState() =>
      _CompanyIdActivationPageState();
}

AuthVM authVM = AuthVM();

class _CompanyIdActivationPageState extends State<CompanyIdActivationPage> {
  var idController = TextEditingController();
  var keyController = TextEditingController();
  var urlController = TextEditingController();
  var portController = TextEditingController();

  @override
  void initState() {
    //initializing the provider in init state any function can run if needed before the page is rendered
    authVM = Provider.of(context, listen: false);
    super.initState();
    authVM.isdisable = true;
    Global.tempAuthKey = '';
    Global.tempAuthId = '';
    urlController.clear();
    portController.clear();
    idController.addListener(() {
      _updateButtonState();
    });
    keyController.addListener(() {
      _updateButtonState();
    });
    urlController.addListener(() {
      _updateButtonState();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    idController.dispose();
    keyController.dispose();
    urlController.dispose();
  }

  void _updateButtonState() {
    if (idController.text.isNotEmpty &&
        keyController.text.isNotEmpty &&
        urlController.text.isNotEmpty) {
      authVM.setdisable(false);
    } else {
      authVM.setdisable(true);
    }
  }

  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _updateButtonState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.resources.color.colorWhite,
      appBar: CommonAppBar(context, 1),
      body: BaseGestureTouchSafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                right: AppWidth(30), left: AppWidth(30), top: AppHeight(25)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CommonTextView(
                    label: 'Company ID Activation'.tr(),
                    fontSize: context.resources.dimension.appExtraBigText,
                    fontFamily: 'Black',
                    onTap: () {},
                    margin: EdgeInsets.only(bottom: AppHeight(10)),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  height: AppHeight(80),
                  child: CommonTextView(
                    label: 'inTheERP'.tr(),
                    fontSize: context.resources.dimension.appMediumText,
                    fontFamily: 'Black',
                    // textAlign: TextAlign.center,
                  ),
                ),
                CommonTextFormField(
                  label: 'Activation ID'.tr(),
                  controller: idController,
                  keyboardType: TextInputType.number,
                  margin: EdgeInsets.only(
                      right: AppWidth(10),
                      left: AppWidth(10),
                      bottom: AppHeight(10)),
                  // onChanged: (value) => viewModel.updateUsername(value),
                ),
                CommonTextFormField(
                  label: 'Activation Key'.tr(),
                  controller: keyController,
                  allCaps: true,
                  isBorderUnderLine: false,
                  margin: EdgeInsets.only(
                      right: AppWidth(10),
                      left: AppWidth(10),
                      bottom: AppHeight(10)),
                ),
                Container(
                  margin: EdgeInsets.only(
                      right: AppWidth(10),
                      left: AppWidth(10),
                      bottom: AppHeight(45)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: context.resources.color.themeColor.withOpacity(.3),
                      width: 1,
                    ),
                  ),
                  child: CommonTextFormField(
                    controller: urlController,
                    label: 'e.g.: https://xyz.com.sa:8080',
                    // '_________________________________',
                    isBorderSideNone: true,
                    keyboardType: TextInputType.url,
                  ),
                  /*Row(
                    children: [
                      CommonTextView(
                        label: ' https://',
                        color: context.resources.color.colorGrey,
                        fontSize: context.resources.dimension.appMediumText,
                        margin: EdgeInsets.only(
                            right: Global.isArabic ? AppWidth(5) : 0,
                            left: Global.isArabic ? 0 : AppWidth(5)),
                      ),
                      Expanded(
                        flex: 2,
                        child: CommonTextFormField(
                          controller: urlController,
                          label: '_____________________',
                          isBorderSideNone: true,
                          keyboardType: TextInputType.url,
                        ),
                      ),
                      CommonTextView(
                        label: '.com.sa:',
                        color: context.resources.color.colorGrey,
                        fontSize: context.resources.dimension.appMediumText,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: context.resources.color.themeColor
                                  .withOpacity(.3),
                              width: 1,
                            ),
                          ),
                          child: CommonTextFormField(
                            controller: portController,
                            label: '8080',
                            isBorderSideNone: true,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            counterText: '',
                            isBorderUnderLine: false,
                          ),
                        ),
                      ),
                    ],
                  ),*/
                ),
                Consumer<AuthVM>(builder: (context, qrMaker, widget) {
                  return CommonButton(
                      text: 'Validate',
                      margin: EdgeInsets.only(
                          right: AppWidth(10),
                          left: AppWidth(10),
                          bottom: AppHeight(10)),
                      disable: qrMaker.isdisable ? true : false,
                      onPressed: () {
                        String authId = idController.text
                            .toString()
                            .trim()
                            .replaceAll(' ', '');
                        String authKey = keyController.text
                            .toString()
                            .trim()
                            .replaceAll(' ', '');
                        String url = urlController.text + '/';
                        // portController.text.toString().isEmpty
                        //     ? 'https://${urlController.text.toString().trim()}.com.sa/'
                        //     : 'https://${urlController.text.toString().trim()}.com.sa:${portController.text}/';
                        if (!AppUtils.validateURL(url)) {
                          qrMaker.setContainerFalse(context);
                          AppUtils.showToastRedBg(
                              context, 'plzEnterValidUrl'.tr());
                        } else {
                          if (urlController.text
                                      .toString()
                                      .trim()
                                      .replaceAll(' ', '') ==
                                  'erp.sendan' &&
                              portController.text.isEmpty) {
                            AppUtils.showToastRedBg(
                                context, 'Please enter 8080 in url port');
                          } else {
                            qrMaker.validate(context, authId, authKey, url);
                          }
                        }
                      });
                }),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, SystemUrl.Id);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: AppHeight(100), top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonTextView(
                          label: 'How do I find Company URL'.tr(),
                          fontSize: context.resources.dimension.appBigText,
                          color: context.resources.color.themeColor,
                          fontFamily: 'Bold',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset(
                          'assets/images/erp_app_icon/info.svg',
                          height: AppHeight(15),
                          width: AppWidth(15),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: CommonTextView(
                    label: 'tryAnother'.tr(),
                    fontSize: context.resources.dimension.appBigText,
                    color: context.resources.color.themeColor,
                    fontFamily: 'Bold',
                    onTap: () {
                      Navigator.pushNamed(context, ScanQRCodePage.id);
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
