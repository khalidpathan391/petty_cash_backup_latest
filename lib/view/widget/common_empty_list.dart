// ignore_for_file: unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/view/widget/common_text.dart';

class EmptyListWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const EmptyListWidget({
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: SvgPicture.asset(
            'assets/images/notification_watermark.svg',
            height: 209,
          )),
          CommonTextView(
            label: 'No Data Found',
            fontSize: context.resources.dimension.appMediumText,
            margin: const EdgeInsets.only(
              top: 26,
              bottom: 126,
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonTextView(
                  label: 'Reload this Page',
                  fontSize: context.resources.dimension.appBigText,
                  fontFamily: 'Bold',
                  color: context.resources.color.themeColor,
                  margin: const EdgeInsets.only(
                    right: 5,
                    left: 0,
                  ),
                ),
                Icon(
                  Icons.refresh,
                  size: 20,
                  color: context.resources.color.themeColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
