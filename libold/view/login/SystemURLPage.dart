import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/view/login/common/CommonAppBar.dart';
import 'package:petty_cash/view/widget/common_text.dart';

class SystemUrl extends StatefulWidget {
  static const Id = 'system_url';
  const SystemUrl({super.key});

  @override
  State<SystemUrl> createState() => _SystemUrlState();
}

class _SystemUrlState extends State<SystemUrl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.resources.color.colorWhite,
      appBar: CommonAppBar(context, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonTextView(
            label: 'System URL'.tr(),
            fontSize: context.resources.dimension.appExtraBigText,
            fontFamily: 'Bold',
            margin: EdgeInsets.only(
                left: AppWidth(35), bottom: AppHeight(20), top: AppHeight(25)),
            onTap: () {},
          ),
          Image(
            image: const AssetImage('assets/images/systemurlbg.png'),
            width: MediaQuery.of(context).size.width,
            height: AppHeight(310),
          ),
          Center(
            child: CommonTextView(
              label: 'tryAnother'.tr(),
              padding: const EdgeInsets.all(8.0),
              fontSize: context.resources.dimension.appBigText,
              color: context.resources.color.themeColor,
              fontFamily: 'Bold',
              margin: EdgeInsets.only(top: AppHeight(200)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
