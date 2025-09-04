// ignore_for_file: file_names, unused_import, non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';

AppBar CommonAppBar(BuildContext context, int? type) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back_ios_rounded,
        color: context.resources.color.themeColor,
        size: 30,
      ),
      onPressed: () {
        if (type == 0) {
          AppUtils.popDialog(context, false,
              content: "Are you sure you want to exit or not?",
              title: "Confirmation!",
              isExit: true);
        } else {
          Navigator.pop(context);
        }
      },
    ),
    actions: const [
      // IconButton(
      //   icon: Icon(
      //     Icons.help,
      //     color: Colors.black.withOpacity(0.7),
      //     size: 20,
      //   ),
      //   onPressed: () {
      //    // Navigator.pushNamed(context, Settings.id).then((value) {});
      //   },
      // ),
      // TextButton(
      //     onPressed: (){},
      //     style: TextButton.styleFrom(foregroundColor: context.resources.color.colorBlack.withOpacity(.7),backgroundColor: context.resources.color.colorTransparent),
      //     child: Text('Help')
      // ),
    ],
  );
}
