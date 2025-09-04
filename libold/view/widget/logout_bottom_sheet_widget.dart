// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/custom_button.dart';
import 'package:petty_cash/view/widget/gradient_button.dart';
import 'package:petty_cash/view_model/Authentication/AuthVM.dart';

class LogoutBottomSheetWidget extends StatefulWidget {
  const LogoutBottomSheetWidget({super.key});

  @override
  State<LogoutBottomSheetWidget> createState() =>
      LogoutBottomSheetWidgetState();
}

class LogoutBottomSheetWidgetState extends State<LogoutBottomSheetWidget> {
  AuthVM lVM = AuthVM();
  //
  Map language = {};
  double dW = 0.0;
  double dH = 0.0;
  double tS = 0.0;
  ThemeData get theme => Theme.of(context);

  bool isLoading = false;
  bool isValid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;
    tS = MediaQuery.of(context).textScaleFactor;
    final themeColor = context.resources.color.themeColor;
    return Padding(
      padding: EdgeInsets.all(dW * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonTextView(
            label: 'Are you sure you want to log out?',
            fontSize: context.resources.dimension.appBigText,
            color: Colors.black,
            textAlign: TextAlign.center,
          ),
          CommonTextView(
            padding: EdgeInsets.only(top: dW * 0.05, bottom: dW * 0.1),
            label: 'You can always access your content by signing back in.',
            fontSize: context.resources.dimension.appMediumText,
            color: Colors.grey,
            textAlign: TextAlign.center,
          ),
          GradientButton(
            elevation: isValid ? 2 : 0,
            onPressed: isValid
                ? () {
                    Navigator.pop(context);
                  }
                : () {
                    lVM.logout(context);
                  },
            buttonText: 'Log out',
          ),
          CustomTextButton(
            elevation: isValid ? 2 : 0,
            onPressed: isValid
                ? () {
                    Navigator.pop(context);
                  }
                : () {},
            buttonText: 'Cancel',
          ),
        ],
      ),
    );
  }
}
