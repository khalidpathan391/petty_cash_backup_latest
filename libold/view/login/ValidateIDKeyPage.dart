// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/login/LoginScreen.dart';
import 'package:petty_cash/view/widget/common_button.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';

class ValidateIDKeyPage extends StatefulWidget {
  static const String id = "validate_id_key_page";

  const ValidateIDKeyPage({super.key});

  @override
  _ValidateIDKeyPageState createState() => _ValidateIDKeyPageState();
}

class _ValidateIDKeyPageState extends State<ValidateIDKeyPage> {
  @override
  void initState() {
    super.initState();
  }

  var myAuthIdController = TextEditingController();
  var myKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black.withOpacity(0.7),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.help,
              color: Colors.black.withOpacity(0.7),
            ),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              top: context.resources.dimension.smallMargin,
              left: context.resources.dimension.bigMargin,
              right: context.resources.dimension.bigMargin,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextView(
                  label: 'companyIdActivation'.tr(),
                  fontSize: 30,
                  fontFamily: 'Bold',
                  color: Colors.black,
                  onTap: () {},
                ),
                const SizedBox(height: 10.0),
                CommonTextView(
                  label: 'inTheERP'.tr(),
                  fontSize: 15.0,
                  fontFamily: 'Regular',
                  color: Colors.black,
                  onTap: () {},
                ),
                const SizedBox(height: 5.0),
                Align(
                  alignment: Alignment.topCenter,
                  child: CommonTextView(
                    label: 'or'.tr().toUpperCase(),
                    fontSize: 15.0,
                    color: Colors.blueAccent,
                    fontFamily: 'Bold',
                    textAlign: TextAlign.center,
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 10.0),
                CommonTextView(
                  label: 'generateQrCode'.tr(),
                  fontSize: 15.0,
                  fontFamily: 'Bold',
                  textAlign: TextAlign.center,
                  onTap: () {},
                ),
                const SizedBox(height: 10.0),
                CommonTextView(
                  label: 'youCanEnter'.tr(),
                  fontSize: 15.0,
                  fontFamily: 'Regular',
                  color: Colors.black,
                  onTap: () {},
                ),
                const SizedBox(height: 5.0),
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/sendan_logo.png',
                    height: 60,
                    width: 105,
                  ),
                ),
                CommonTextFormField(
                  label: 'enterUserName'.tr(),
                  controller: myAuthIdController,
                  keyboardType: TextInputType.number,
                  height: 45.0,
                ),
                CommonTextFormField(
                  label: 'enterPassword'.tr(),
                  controller: myKeyController,
                  allCaps: true,
                  height: 45.0,
                ),
                CommonButton(
                  text: 'generateQr'.tr(),
                  onPressed: () {
                    String id = myAuthIdController.text.toString().trim();
                    String key = myKeyController.text.toString().trim();
                    if (AppUtils.isValidated(context, id, key)) {
                      Navigator.pushNamed(context, LoginScreen.id);
                    }
                  },
                  buttonWidth: ButtonWidth.WRAP,
                  fontSize: 18.0,
                  font: 'Bold',
                  margin: const EdgeInsets.only(left: 3.0, right: 3.0),
                ),
                const SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CommonTextView(
                    label: 'tryAnother'.tr(),
                    padding: const EdgeInsets.all(8.0),
                    fontSize: 15.0,
                    color: Colors.blueAccent,
                    fontFamily: 'Bold',
                    textAlign: TextAlign.center,
                    onTap: () {},
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
/*Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonTextFormField(
              label: 'enterAuthId'.tr(),
              controller: myAuthIdController,
              keyboardType: TextInputType.number,
            ),
            CommonTextFormField(
              label: 'enterKey'.tr(),
              controller: myKeyController,
              allCaps: true,
            ),
            CommonButton(
              text: 'validate'.tr(),
              onPressed: () {
                String id = myAuthIdController.text.toString().trim();
                String key = myKeyController.text.toString().trim();
                if (AppUtils.isValidated(context, id, key)) {
                  Navigator.pushNamed(context, LoginScreen.id);
                }
              },
              buttonWidth: ButtonWidth.WRAP,
              color: context.resources.color.colorGreen,
              // Optional: Customize button color
              fontSize: 18.0, // Optional: Customize font size
            ),
            CommonButton(
              text: 'Scan',
              onPressed: () {
                Navigator.pushNamed(context, ScanQRCodePage.id);
                // if (context.locale.languageCode == 'en') {
                //   context.setLocale(const Locale('ar', 'SA'));
                // } else {
                //   context.setLocale(const Locale('en', 'US'));
                // }
              },
              buttonWidth: ButtonWidth.WRAP,
              color: context.resources.color.colorGreen,
              // Optional: Customize button color
              fontSize: 18.0, // Optional: Customize font size
            ),
            CustomButtonWithContainer(
              onTap: () {
                print('Button tapped!');
              },
              color: primaryColor!,
              icon: Icons.add,
              child: Text(
                'Add Item', // Text to be displayed
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      )*/
}
