// ignore_for_file: avoid_print, unused_import

import 'dart:convert';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/widget/common_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? type;
  final String? typeIcon;
  final bool isSpace;
  final bool filter;
  final bool settings;
  final bool multiFilter;
  final bool refresh;
  final VoidCallback? myFilter;
  final VoidCallback? mySettings;
  final VoidCallback? myMultiFilter;
  final VoidCallback? myRefresh;
  final VoidCallback? save;
  final VoidCallback? submitOrApproval;
  final VoidCallback? list;
  final VoidCallback? openNew;
  final Color bgColor;
  final bool isTransaction;
  final bool isSave;
  final bool isSubmit;
  final bool isList;
  final bool isAdd;
  final bool isTransactionBack;
  final VoidCallback? onTap; // Added this

  const CustomAppBar({
    super.key,
    this.isSpace = false,
    this.type = 'default',
    this.typeIcon,
    this.filter = false,
    this.settings = false,
    this.multiFilter = false,
    this.refresh = false,
    this.myFilter,
    this.myMultiFilter,
    this.myRefresh,
    this.mySettings,
    this.bgColor = Colors.white,
    this.isTransaction = false,
    this.save,
    this.submitOrApproval,
    this.list,
    this.openNew,
    this.isSave = true,
    this.isSubmit = true,
    this.isList = true,
    this.isAdd = true,
    this.isTransactionBack = false,
    this.onTap, // Added this
  });

  @override
  Widget build(BuildContext context) {
    //making the icon string data into image
    String imagePath = '';
    Uint8List? bytes;
    try {
      bytes = base64Decode(typeIcon.toString().split(',').last);
    } catch (e) {
      imagePath = '${ApiUrl.baseUrl}$typeIcon';
      print(e.toString());
    }
    // the less of the one will be the diameter of the circular avatar to keep its size dynamic
    double minDimension =
        AppHeight(34) < AppWidth(34) ? AppHeight(34) : AppWidth(34);
    return GestureDetector(
      onTap: onTap,
      child: SafeArea(
        child: Container(
          height: AppHeight(80),
          padding: EdgeInsets.only(right: AppWidth(16), left: AppWidth(16)),
          color: bgColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              type == 'default'
                  ? GestureDetector(
                      onTap: () {
                        // HomeScreenState.openDrawer();
                      },
                      child: SizedBox(
                        height: AppHeight(34),
                        width: AppWidth(34),
                        child: CircleAvatar(
                          //make it radius by dividing by 2
                          radius: minDimension / 2,
                          backgroundColor: Colors.grey.withOpacity(.5),
                          backgroundImage: Global.empData!.media == 1
                              ? NetworkImage(ApiUrl.baseUrl! +
                                  Global.empData!.fileName.toString())
                              : null,
                          child: Global.empData!.media == 1
                              ? null
                              : Text(
                                  Global.empData!.fileName.toString(),
                                  style: TextStyle(
                                      color:
                                          context.resources.color.themeColor),
                                ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              type == 'default'
                  ? Padding(
                      padding: EdgeInsets.only(
                          left: Global.isArabic ? 0 : AppWidth(10),
                          right: Global.isArabic ? AppWidth(10) : 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextView(
                            width: AppWidth(218),
                            label: AppUtils.showGoodMessage(),
                            fontSize: context
                                .resources.dimension.appBigText, //big Text
                            // fontWeight: FontWeight.bold,
                            // margin: EdgeInsets.only(bottom: AppHeight(2)),
                          ),
                          SizedBox(
                            width: isSpace ? AppWidth(335) : AppWidth(221),
                            child: CommonTextView(
                              label:
                                  '${Global.empData!.empName}-${Global.empData!.empCode}',
                              fontSize: appTextSize(13), //medium text
                              // fontWeight: FontWeight.bold,
                              maxLine: 1,
                              overFlow: TextOverflow.ellipsis,
                              padding: EdgeInsets.only(
                                top: AppHeight(2),
                                right: isSpace ? 0 : AppWidth(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              type != 'default'
                  ? isTransactionBack
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                            size: 22,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            // HomeScreenState.openDrawer();
                          },
                          child: SvgPicture.asset(
                            'assets/images/erp_app_icon/hamburger_button.svg',
                            height: AppHeight(20),
                          ),
                        )
                  : const SizedBox(),
              type != 'default'
                  ? Container(
                      height: AppHeight(34),
                      width: AppWidth(34),
                      margin: EdgeInsets.only(
                          left: Global.isArabic ? 0 : AppWidth(10),
                          right: Global.isArabic ? AppWidth(10) : 0),
                      child: (bytes != null && bytes.isNotEmpty)
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppHeight(34) * .1),
                              child: Image.memory(
                                bytes,
                                fit: BoxFit.cover,
                              ),
                            )
                          : imagePath.isNotEmpty
                              ? SvgPicture.network(
                                  imagePath,
                                  width: 8,
                                  height: 8,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.photo,
                                  size: 40,
                                ),
                    )
                  : const SizedBox(),
              type != 'default'
                  ? CommonTextView(
                      padding: EdgeInsets.only(
                          left: Global.isArabic ? 0 : AppWidth(10),
                          right: Global.isArabic ? AppWidth(10) : 0,
                          bottom: AppHeight(10)),
                      width: AppWidth(198),
                      label: type!,
                      alignment: Global.isArabic
                          ? Alignment.bottomRight
                          : Alignment.bottomLeft,
                      fontSize:
                          context.resources.dimension.appBigText, //big Text
                      // fontWeight: FontWeight.bold,
                      // margin: EdgeInsets.only(bottom: AppHeight(2)),
                    )
                  : const SizedBox(),
              isTransaction
                  ? SizedBox(
                      width: AppWidth(111),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          isSave
                              ? MyIcons(
                                  margin: true,
                                  svgIcon:
                                      'assets/images/TransactionAppBar/save.svg',
                                  onTap: save,
                                  isIconColor: true,
                                )
                              : const SizedBox(),
                          isSubmit
                              ? MyIcons(
                                  margin: true,
                                  svgIcon:
                                      'assets/images/TransactionAppBar/submit.svg',
                                  onTap: submitOrApproval,
                                  isIconColor: true,
                                )
                              : const SizedBox(),
                          isList
                              ? MyIcons(
                                  margin: true,
                                  svgIcon:
                                      'assets/images/TransactionAppBar/list.svg',
                                  onTap: list,
                                  isIconColor: true,
                                )
                              : const SizedBox(),
                          isAdd
                              ? MyIcons(
                                  svgIcon:
                                      'assets/images/TransactionAppBar/add.svg',
                                  onTap: openNew,
                                  isIconColor: true,
                                )
                              : const SizedBox(),
                        ],
                      ),
                    )
                  : isSpace
                      ? const SizedBox()
                      : SizedBox(
                          width: AppWidth(111),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              filter
                                  ? MyIcons(
                                      margin: true,
                                      svgIcon:
                                          'assets/images/erp_app_icon/filter.svg',
                                      onTap: myFilter,
                                    )
                                  : const SizedBox(),
                              settings
                                  ? MyIcons(
                                      margin: true,
                                      svgIcon:
                                          'assets/images/erp_app_icon/settings.svg',
                                      onTap: mySettings,
                                    )
                                  : const SizedBox(),
                              multiFilter
                                  ? MyIcons(
                                      margin: true,
                                      svgIcon:
                                          'assets/images/erp_app_icon/multi_filter.svg',
                                      onTap: myMultiFilter,
                                    )
                                  : const SizedBox(),
                              refresh
                                  ? MyIcons(
                                      svgIcon:
                                          'assets/images/erp_app_icon/refresh.svg',
                                      onTap: myRefresh,
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MyIcons extends StatelessWidget {
  final String? svgIcon;
  final VoidCallback? onTap;
  final bool margin;
  final Color iconColor;
  final bool isIconColor;

  const MyIcons({
    super.key,
    this.svgIcon,
    this.onTap,
    this.margin = false,
    this.iconColor = Colors.black,
    this.isIconColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: AppHeight(24),
        width: AppWidth(24),
        decoration: DottedDecoration(
          shape: Shape.box,
          color: context.resources.color.defaultMediumGrey,
          strokeWidth: 0.5,
          dash: const [1, 1],
          borderRadius: BorderRadius.circular(AppHeight(24) * .1),
        ),
        alignment: Alignment.center,
        margin: margin
            ? EdgeInsets.only(
                right: Global.isArabic ? 0 : AppWidth(5),
                left: Global.isArabic ? AppWidth(5) : 0,
              )
            : null,
        child: SvgPicture.asset(
          svgIcon!,
          height: 13, //AppHeight(13)
          color:
              isIconColor ? iconColor : context.resources.color.defaultBlueGrey,
        ),
        // Icon(icon,size:18,color: context.resources.color.defaultBlueGrey,),
      ),
    );
  }
}
