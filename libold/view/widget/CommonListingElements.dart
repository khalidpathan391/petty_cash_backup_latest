import 'package:flutter/material.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';

class MyHeaderData extends StatelessWidget {
  final bool isDropdown;
  final bool isSearch;
  final bool isIcon;
  final IconData iconData;
  final String title;
  final Color textColor;
  final Color iconColor;
  final VoidCallback? onIconTap;
  final int flex;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isTextField;
  final TextEditingController? controller;
  final Function(String)? onChange;
  final bool isIconCount;
  final String iconCount;
  final IconData dropIcon;
  final dynamic myDecoration;
  final bool isToolTip;
  final TextInputType keyboardType;

  const MyHeaderData({
    super.key,
    this.isDropdown = false,
    this.isSearch = false,
    this.isIcon = false,
    this.isTextField = false,
    this.iconData = Icons.add,
    this.onIconTap,
    required this.title,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.flex = 1,
    this.onTap,
    this.onLongPress,
    this.controller,
    this.onChange,
    this.isIconCount = false,
    this.iconCount = '0',
    this.dropIcon = Icons.arrow_drop_down,
    this.myDecoration,
    this.isToolTip = true,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: isDropdown
          ? InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonTextView(
                    label: title,
                    isToolTip: isToolTip,
                    color: textColor,
                    maxLine: 1,
                    overFlow: TextOverflow.ellipsis,
                    fontSize: context.resources.dimension.appMediumText,
                  ),
                  isDropdown
                      ? Icon(
                          dropIcon,
                          color: iconColor,
                        )
                      : const SizedBox(),
                ],
              ),
            )
          : isIcon
              ? GestureDetector(
                  onTap: onIconTap,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        iconData,
                        color: iconColor,
                      ),
                      if (isIconCount)
                        Positioned(
                          top: 0,
                          right: 2,
                          child: CommonTextView(
                            isToolTip: isToolTip,
                            label: iconCount,
                            height: 15,
                            width: 15,
                            alignment: Alignment.center,
                            color: context.resources.color.themeColor,
                            fontSize:
                                context.resources.dimension.appExtraSmallText,
                            myDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                              color: Colors.white,
                            ),
                          ),
                        )
                    ],
                  ),
                )
              : isTextField
                  ? CommonTextFormField(
                      label: title,
                      isBorderSideNone: true,
                      controller: controller,
                      onChanged: onChange,
                      keyboardType: keyboardType,
                    )
                  : isSearch
                      ? GestureDetector(
                          onTap: onTap,
                          onLongPress: onLongPress,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: myDecoration,
                            child: Row(
                              children: [
                                Expanded(
                                  child: CommonTextView(
                                    label: title,
                                    isToolTip: isToolTip,
                                    color: textColor,
                                    maxLine: 1,
                                    overFlow: TextOverflow.ellipsis,
                                    alignment: Alignment.center,
                                    fontSize: context
                                        .resources.dimension.appMediumText,
                                  ),
                                ),
                                RotatedBox(
                                  quarterTurns: 1,
                                  child: Icon(
                                    Icons.search,
                                    size: 15,
                                    color: iconColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : CommonTextView(
                          label: title,
                          isToolTip: isToolTip,
                          color: textColor,
                          maxLine: 1,
                          overFlow: TextOverflow.ellipsis,
                          alignment: Alignment.center,
                          fontSize: context.resources.dimension.appMediumText,
                          onTap: onTap,
                          onLongPress: onLongPress,
                          myDecoration: myDecoration,
                        ),
    );
  }
}

class MyDataRows {
  final String title;
  final String value;
  const MyDataRows({required this.title, required this.value});
}

class MyListRows extends StatelessWidget {
  final String title;
  final String value;
  final bool isTextField;
  final TextEditingController? controller;
  final Function(String)? onChange;
  final bool isSelectable;
  final bool isDate;
  final VoidCallback? getDateTime;
  final VoidCallback? onTap;
  final int flex1;
  final int flex2;
  final bool isSelect2;
  final bool isIcon;
  final IconData myIcon;
  final Alignment alignmentText1;
  final String iconCount;
  final dynamic myDecoration;
  final TextInputType keyboardType;
  final Color iconColor;
  final double iconSize;
  final bool isSearchIcon;
  final int iconTurns;
  final bool isToolTip;
  final bool isCustomChild;
  final Widget customChild;

  const MyListRows({
    super.key,
    required this.title,
    required this.value,
    this.isTextField = false,
    this.controller,
    this.onChange,
    this.isSelectable = false,
    this.isDate = false,
    this.getDateTime,
    this.flex1 = 1,
    this.flex2 = 3,
    this.onTap,
    this.isSelect2 = true, //for the right value
    this.isIcon = false,
    this.myIcon = Icons.attachment_outlined,
    this.alignmentText1 = Alignment.centerLeft,
    this.iconCount = '',
    this.myDecoration,
    this.keyboardType = TextInputType.text,
    this.iconColor = Colors.black,
    this.iconSize = 15,
    this.isSearchIcon = false,
    this.iconTurns = 0,
    this.isToolTip = true,
    this.isCustomChild = false,
    this.customChild = const SizedBox(),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.black),
        ),
      ),
      height: AppHeight(30),
      child: Row(
        children: [
          Expanded(
              flex: flex1,
              child: CommonTextView(
                label: title,
                isToolTip: isToolTip,
                alignment: alignmentText1,
                color: Colors.white,
                overFlow: TextOverflow.ellipsis,
                maxLine: 1,
                isSelectable: isSelectable,
                fontSize: context.resources.dimension.appMediumText,
                padding: const EdgeInsets.only(right: 2, left: 5),
                myDecoration: BoxDecoration(
                  color: context.resources.color.themeColor,
                ),
              )),
          const RightBorder(),
          Expanded(
            flex: flex2,
            child: isCustomChild
                ? customChild
                : isTextField
                    ? CommonTextFormField(
                        label: value,
                        isBorderSideNone: true,
                        controller: controller,
                        onChanged: onChange,
                        keyboardType: keyboardType,
                      )
                    : isDate
                        ? CommonTextView(
                            label: value,
                            maxLine: 1,
                            isToolTip: isToolTip,
                            fontSize: context.resources.dimension.appMediumText,
                            padding: const EdgeInsets.only(left: 2),
                            onTap: getDateTime,
                          )
                        : isIcon
                            ? GestureDetector(
                                onTap: onTap,
                                child: Container(
                                  height: AppHeight(30),
                                  decoration: myDecoration,
                                  child: iconCount.isNotEmpty
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            CommonTextView(
                                              label: iconCount,
                                              isToolTip: isToolTip,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2),
                                            ),
                                            RotatedBox(
                                              quarterTurns: iconTurns,
                                              child: Icon(
                                                myIcon,
                                                color: iconColor,
                                                size: iconSize,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Center(
                                          child: RotatedBox(
                                            quarterTurns: iconTurns,
                                            child: Icon(
                                              myIcon,
                                              color: iconColor,
                                              size: iconSize,
                                            ),
                                          ),
                                        ),
                                ),
                              )
                            : GestureDetector(
                                onTap: onTap,
                                child: Container(
                                  decoration: myDecoration,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CommonTextView(
                                          label: value,
                                          isSelectable: isSelect2,
                                          maxLine: 1,
                                          height: AppHeight(30),
                                          alignment: Alignment.centerLeft,
                                          fontSize: context.resources.dimension
                                              .appMediumText,
                                          padding:
                                              const EdgeInsets.only(left: 2),
                                          isToolTip: isToolTip,
                                        ),
                                      ),
                                      if (isSearchIcon)
                                        RotatedBox(
                                            quarterTurns: iconTurns,
                                            child: Icon(
                                              myIcon,
                                              size: iconSize,
                                            )),
                                    ],
                                  ),
                                ),
                              ),
          ),
        ],
      ),
    );
  }
}

class RightBorder extends StatelessWidget {
  const RightBorder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppHeight(30),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(width: 1.0, color: Colors.black),
        ),
      ),
    );
  }
}

class SingleTitleCentered extends StatelessWidget {
  final String title;
  final Color textColor;
  final double fontSize;
  final TextAlign textAlign;
  final int maxLines;
  final TextOverflow overflow;
  final VoidCallback? onTap;
  final BoxDecoration myDecoration;

  const SingleTitleCentered({
    Key? key,
    required this.title,
    this.textColor = Colors.white,
    this.fontSize = 15.0,
    this.textAlign = TextAlign.center,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.onTap,
    required this.myDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.black),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          decoration: myDecoration,
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
            ),
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          ),
        ),
      ),
    );
  }
}
