// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/login/CompanyIdActivationPage.dart';
import 'package:petty_cash/view/login/ScanQRCodeORGenerate.dart';
import 'package:petty_cash/view/login/common/CommonAppBar.dart';
import 'package:petty_cash/view/widget/common_button.dart';
import 'package:petty_cash/view/widget/common_text.dart';

class ChooseLoginTypePage extends StatefulWidget {
  static const String id = "choose_login_screen";

  const ChooseLoginTypePage({Key? key}) : super(key: key);

  @override
  _ChooseLoginTypePageState createState() => _ChooseLoginTypePageState();
}

class _ChooseLoginTypePageState extends State<ChooseLoginTypePage> {
  @override
  void initState() {
    super.initState();
  }

  // TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (doPop) {
        AppUtils.popDialog(context, false,
            content: "Are you sure you want to exit or not?",
            title: "Confirmation!",
            isExit: true);
      },
      child: Scaffold(
        backgroundColor: context.resources.color.colorWhite,
        appBar: CommonAppBar(context, 0),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(
                left: AppWidth(45), right: AppWidth(45), top: AppHeight(80)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonTextView(
                        label: 'appName'.tr(),
                        padding: EdgeInsets.only(
                            bottom: AppHeight(45), right: AppWidth(13)),
                        fontSize: context.resources.dimension.appExtraBigText,
                        onTap: () {},
                        fontWeight: FontWeight.bold,
                      ),
                      Container(
                          padding: EdgeInsets.only(bottom: AppHeight(45)),
                          child: SvgPicture.asset(
                              'assets/images/horizontal_logo.svg'))
                    ],
                  ),
                  CommonTextView(
                    label: 'toGet'.tr(),
                    margin: EdgeInsets.only(bottom: AppHeight(45)),
                    fontSize: context.resources.dimension.appBigText,
                    textAlign: TextAlign.center,
                  ),
                  CommonButton(
                    text: 'qrCodeActivation'.tr(),
                    onPressed: () {
                      Navigator.pushNamed(context, ScanQRCodeORGenerate.id);
                    },
                    buttonWidth: ButtonWidth.MACH,
                    fontSize: context.resources.dimension.appBigText,
                    font: 'Bold',
                    svgIconPath: 'assets/images/erp_app_icon/qr.svg',
                    iconSize: AppHeight(18),
                    svgBgColor: context.resources.color.colorWhite,
                    color: context.resources.color.themeColor,
                    margin: EdgeInsets.only(bottom: AppHeight(12)),
                  ),
                  CommonButton(
                    text: 'companyIdActivation'.tr(),
                    onPressed: () {
                      Navigator.pushNamed(context, CompanyIdActivationPage.id);
                    },
                    buttonWidth: ButtonWidth.MACH,
                    fontSize: context.resources.dimension.appBigText,
                    font: 'Bold',
                    iconSize: AppHeight(18),
                    svgIconPath: 'assets/images/erp_app_icon/business_card.svg',
                    svgBgColor: context.resources.color.colorWhite,
                    color: Colors.grey,
                    textColor: Colors.black,
                  ),
                  // Center(
                  //   child: Container(
                  //     margin: EdgeInsets.only(top: AppHeight(227)),
                  //     child: CommonTextView(
                  //       label: 'whichMethod'.tr(),
                  //       fontSize: context.resources.dimension.appBigText,
                  //       fontFamily: 'Bold',
                  //       color: context.resources.color.themeColor,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
