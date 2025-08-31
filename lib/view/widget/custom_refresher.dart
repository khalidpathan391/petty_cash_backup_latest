import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:petty_cash/resources/app_extension_context.dart';

import 'package:petty_cash/view_model/home_module_vm/dashboard_vm.dart';

import 'package:provider/provider.dart';

import 'common_text.dart';

class CustomRefresher extends StatelessWidget {
  const CustomRefresher({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          backgroundColor: context.resources.color.themeColor.withOpacity(.5),
          valueColor:
              AlwaysStoppedAnimation<Color>(context.resources.color.themeColor),
          minHeight: 2,
        ),
        SizedBox(
          height: 40,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // RotatingSyncIcon(),
                    CommonTextView(
                      label: 'Sync in Process'.tr(),
                      fontSize: context.resources.dimension.appBigText,
                      fontWeight: FontWeight.bold,
                      margin: const EdgeInsets.only(
                        left: 5,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Consumer<DashboardVm>(
                  builder: (context, homeProvider, widget) {
                    return GestureDetector(
                      onTap: () {
                        //homeProvider.isLoading = false;
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: context.resources.color.themeColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 6,
          margin: const EdgeInsets.only(right: 6, left: 6),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: context.resources.color.colorLightGrey,
                // Adjust the color as needed
                width: 1, // Adjust the width as needed
              ),
            ),
          ),
        ),
      ],
    );
  }
}
