// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/view/login/CompanyIdActivationPage.dart';
import 'package:petty_cash/view/login/common/CommonAppBar.dart';
import 'package:petty_cash/view/widget/animated_button.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view_model/Authentication/AuthVM.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ActivateQRCode extends StatefulWidget {
  static const String id = "activate_qr_code";

  const ActivateQRCode({Key? key}) : super(key: key);

  @override
  _ActivateQRCodeState createState() => _ActivateQRCodeState();
}

AuthVM getQr = AuthVM();

class _ActivateQRCodeState extends State<ActivateQRCode> {
  @override
  void initState() {
    getQr = Provider.of(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.resources.color.colorWhite,
      appBar: CommonAppBar(context, 1),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Consumer<AuthVM>(builder: (context, qrProvider, widget) {
            return Container(
              margin: EdgeInsets.only(
                top: AppHeight(25),
                left: AppWidth(40),
                right: AppWidth(40),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextView(
                    label: 'activateWithQRCode'.tr(),
                    fontSize: context.resources.dimension.appExtraBigText,
                    fontFamily: 'Black',
                    margin: EdgeInsets.only(bottom: AppHeight(10)),
                  ),
                  CommonTextView(
                    label: qrProvider.baseUrl,
                    fontSize: context.resources.dimension.appBigText,
                    fontFamily: 'Regular',
                    margin: EdgeInsets.only(bottom: AppHeight(75)),
                  ),
                  Center(
                    child: QrImageView(
                      data: qrProvider.getQrData(),
                      version: QrVersions.auto,
                      size: 215,
                      backgroundColor: context.resources.color.colorWhite,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        right: AppWidth(50), left: AppWidth(50)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonTextView(
                          label: Global.empData!.id.toString(),
                          fontSize: 15.0,
                          color: Colors.black.withOpacity(0.5),
                          fontFamily: 'Bold',
                        ),
                        CommonTextView(
                          label: Global.empData!.key.toString(),
                          fontSize: 15.0,
                          color: Colors.black.withOpacity(0.5),
                          fontFamily: 'Bold',
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: AppHeight(65),
                        bottom: AppHeight(85),
                      ),
                      child: AnimatedButton(
                        text: 'activate'.tr(),
                        onPressed: () {
                          qrProvider.callQRActivateCodeApi(context);
                        },
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
                        Navigator.pushNamed(
                            context, CompanyIdActivationPage.id);
                      },
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
