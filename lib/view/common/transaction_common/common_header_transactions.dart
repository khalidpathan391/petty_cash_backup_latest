import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';

import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';
import 'package:petty_cash/view/widget/quill_text_field.dart';
import 'package:readmore/readmore.dart';

class TransactionHeaderRows extends StatelessWidget {
  final String transactionName;
  final bool isMandatory;
  final String transactionType;
  final dynamic transactionVal;
  final dynamic dTransactionVal;
  final QuillController controller;
  final VoidCallback? searchFunction;
  final VoidCallback? searchFunction2;
  final VoidCallback? iconFunction;
  final Function(String)? dropDownTap;
  final Function(String)? miniDropDownTap;
  final Function(String)? onManualChange;
  final VoidCallback? dateTap;
  final VoidCallback? mapTap;
  final List<String> dropList;
  final List<String> miniDropList;
  final TextEditingController? manualController;
  final bool isMiniDrop;
  final bool isIconLoad;
  final bool isHidden;
  final IconData dateIcon;
  final IconData customIcon;
  final IconData checkBoxIcon;
  final String manualHint;
  final Widget listChild;
  final dynamic myDecoration;
  final bool msDisable;
  final int msLength;
  final double? fontSize;
  final Widget customChild;
  final VoidCallback? buttonFunction;
  final TextInputType keyboardType;
  final Function(String)? onFieldSubmitted;

  const TransactionHeaderRows({
    super.key,
    required this.transactionName,
    this.isMandatory = false,
    required this.transactionType,
    this.transactionVal = '',
    this.dTransactionVal = '',
    required this.controller,
    this.searchFunction,
    this.searchFunction2,
    this.dropDownTap,
    this.miniDropDownTap,
    this.mapTap,
    required this.dropList,
    required this.miniDropList,
    this.onManualChange,
    this.dateTap,
    this.manualController,
    this.isMiniDrop = false,
    this.iconFunction,
    this.isIconLoad = false,
    this.isHidden = false,
    this.dateIcon = Icons.calendar_month_outlined,
    this.customIcon = Icons.check_box_outline_blank_outlined,
    this.checkBoxIcon = Icons.check_box_outline_blank_outlined,
    this.manualHint = 'Write Here',
    this.listChild = const SizedBox(),
    this.myDecoration,
    this.msDisable = false,
    this.msLength = 10,
    this.fontSize,
    this.customChild = const SizedBox(),
    this.buttonFunction,
    this.keyboardType = TextInputType.text,
    this.onFieldSubmitted,
  });

  // Function to build the styled text
  RichText buildTextWithAsterisk(String text, double myFontSize) {
    if (text.isNotEmpty && text.endsWith('*')) {
      // If the text ends with an asterisk, style the asterisk in red
      return RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            TextSpan(
              text: text.substring(
                  0, text.length - 1), // All text except the last character
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Regular',
                  fontSize: myFontSize), // Default style
            ),
            const TextSpan(
              text: '*',
              style: TextStyle(
                color: Colors.red,
              ),
            )
          ],
        ),
      );
    } else {
      // If the text does not end with an asterisk, display it normally
      return RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        text: TextSpan(
          text: text,
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Regular',
              fontSize: myFontSize), // Default style
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double myFontSize = fontSize ?? context.resources.dimension.appBigText;
    String dropdownValue = transactionVal.isNotEmpty ? transactionVal : 'None';
    return isHidden
        ? const SizedBox()
        : transactionType == 'list'
            ? listChild
            : transactionType == 'TextField'
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppWidth(15), vertical: AppHeight(10)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CommonTextView(
                              label: transactionName,
                              // alignment: Alignment.centerLeft,
                              overFlow: TextOverflow.ellipsis,
                              maxLine: 1,
                              margin: EdgeInsets.only(bottom: AppHeight(10)),
                            ),
                            CommonTextView(
                              label: isMandatory ? '*' : '',
                              color: Colors.red,
                            ),
                          ],
                        ),
                        QuillTextField(
                          controller: controller,
                        ),
                      ],
                    ),
                  )
                : transactionType == 'ReadOnlyBig'
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppWidth(15), vertical: AppHeight(10)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CommonTextView(
                                  label: transactionName,
                                  // alignment: Alignment.centerLeft,
                                  overFlow: TextOverflow.ellipsis,
                                  maxLine: 1,
                                  margin:
                                      EdgeInsets.only(bottom: AppHeight(10)),
                                ),
                                CommonTextView(
                                  label: isMandatory ? '*' : '',
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            GestureDetector(
                              // onTap: (){AppUtils.showToastRedBg(context, 'Read Only');},
                              child: Container(
                                height: transactionVal.isEmpty
                                    ? AppHeightP(40)
                                    : null,
                                width: AppWidthP(90),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(.1),
                                  border: Border.all(
                                      color: context.resources.color.themeColor
                                          .withOpacity(.5),
                                      width: .2),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppWidth(10),
                                    vertical: AppHeight(5)),
                                child: ReadMoreText(
                                  transactionVal,
                                  trimLines: 12,
                                  style: TextStyle(
                                      fontSize: appTextSize(19),
                                      fontFamily: 'Regular'),
                                  trimMode: TrimMode.Line,
                                  moreStyle: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontFamily: 'Bold',
                                    color: context.resources.color.themeColor,
                                  ),
                                  lessStyle: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontFamily: 'BoldItalic',
                                    fontWeight: FontWeight.bold,
                                    color: context.resources.color.themeColor,
                                  ),
                                  trimCollapsedText: 'Show More',
                                  trimExpandedText: ' Show Less',
                                ),
                                // CommonTextView(
                                //   label: transactionVal,
                                //   overFlow: TextOverflow.ellipsis,
                                // ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: AppHeight(40),
                        padding: EdgeInsets.symmetric(horizontal: AppWidth(15)),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 4,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: buildTextWithAsterisk(
                                            transactionName, myFontSize),
                                      ),
                                      // CommonTextView(
                                      //   label: transactionName,
                                      //   // alignment: Alignment.centerLeft,
                                      //   overFlow: TextOverflow.ellipsis,
                                      //   maxLine: 1,
                                      // ),
                                    ),
                                    CommonTextView(
                                      label: isMandatory ? '*' : '',
                                      color: Colors.red,
                                    ),
                                  ],
                                )),
                            Expanded(
                                flex: 6,
                                child: transactionType == 'search'
                                    ? Container(
                                        height: AppHeight(30),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          color: Colors.grey,
                                          width: .2,
                                        )),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: AppWidth(5)),
                                        child: GestureDetector(
                                          onTap: searchFunction,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: CommonTextView(
                                                  label: transactionVal
                                                          .toString()
                                                          .isNotEmpty
                                                      ? transactionVal
                                                          .toString()
                                                      : 'Select',
                                                  color: context.resources.color
                                                      .themeColor,
                                                  fontSize: myFontSize,
                                                  maxLine: 1,
                                                  overFlow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const RotatedBox(
                                                quarterTurns: 1,
                                                child: Icon(
                                                  Icons.search,
                                                  size: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : transactionType == 'Search2'
                                        ? Row(
                                            children: [
                                              Expanded(
                                                  flex: 6,
                                                  child: Container(
                                                    height: AppHeight(30),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                      color: Colors.grey,
                                                      width: .2,
                                                    )),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                AppWidth(5)),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: CommonTextView(
                                                            label: transactionVal
                                                                    .toString()
                                                                    .isNotEmpty
                                                                ? transactionVal
                                                                    .toString()
                                                                : 'Select',
                                                            color: context
                                                                .resources
                                                                .color
                                                                .themeColor,
                                                          ),
                                                        ),
                                                        const RotatedBox(
                                                          quarterTurns: 1,
                                                          child: Icon(
                                                            Icons.search,
                                                            size: 15,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              const Expanded(
                                                  flex: 4, child: SizedBox()),
                                            ],
                                          )
                                        : transactionType == 'dropdown'
                                            ? Row(
                                                children: [
                                                  Expanded(
                                                      flex: 6,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    AppWidth(
                                                                        5)),
                                                        height: AppHeight(30),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: .2),
                                                        ),
                                                        child: DropdownButton<
                                                            String>(
                                                          value: transactionVal
                                                                  .toString()
                                                                  .isNotEmpty
                                                              ? transactionVal
                                                                  .toString()
                                                              : dropdownValue,
                                                          icon:
                                                              const RotatedBox(
                                                                  quarterTurns:
                                                                      3,
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_back_ios_new_rounded,
                                                                    size: 15,
                                                                  )),
                                                          isExpanded: true,
                                                          // This will push the icon to the right end
                                                          // elevation: 16,
                                                          style: TextStyle(
                                                              color: context
                                                                  .resources
                                                                  .color
                                                                  .themeColor),
                                                          underline: Container(
                                                              height: 0),
                                                          onChanged: (String?
                                                              newValue) {},
                                                          items: dropList.map<
                                                              DropdownMenuItem<
                                                                  String>>((String
                                                              value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              onTap: () =>
                                                                  dropDownTap!(
                                                                      value),
                                                              child:
                                                                  Text(value),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      )),
                                                  const Expanded(
                                                      flex: 4,
                                                      child: SizedBox()),
                                                ],
                                              )
                                            : transactionType == 'd_search'
                                                ? Row(
                                                    children: [
                                                      Expanded(
                                                          flex: 4,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        AppWidth(
                                                                            5)),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right:
                                                                        AppWidth(
                                                                            5)),
                                                            height:
                                                                AppHeight(30),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: .2),
                                                            ),
                                                            child:
                                                                DropdownButton<
                                                                    String>(
                                                              value: transactionVal
                                                                      .toString()
                                                                      .isNotEmpty
                                                                  ? transactionVal
                                                                      .toString()
                                                                  : dropdownValue,
                                                              icon:
                                                                  const RotatedBox(
                                                                      quarterTurns:
                                                                          3,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .arrow_back_ios_new_rounded,
                                                                        size:
                                                                            15,
                                                                      )),
                                                              isExpanded: true,
                                                              // This will push the icon to the right end
                                                              // elevation: 16,
                                                              style: TextStyle(
                                                                  color: context
                                                                      .resources
                                                                      .color
                                                                      .themeColor),
                                                              underline:
                                                                  Container(
                                                                      height:
                                                                          0),
                                                              onChanged: (String?
                                                                  newValue) {},
                                                              items: miniDropList.map<
                                                                  DropdownMenuItem<
                                                                      String>>((String
                                                                  value) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  onTap: () =>
                                                                      miniDropDownTap!(
                                                                          value),
                                                                  child: Text(
                                                                    value,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ),
                                                          )),
                                                      Expanded(
                                                          flex: 6,
                                                          child:
                                                              GestureDetector(
                                                            onTap: isMiniDrop
                                                                ? searchFunction
                                                                : () {},
                                                            child: Container(
                                                              height:
                                                                  AppHeight(30),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                color:
                                                                    Colors.grey,
                                                                width: .2,
                                                              )),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          AppWidth(
                                                                              5)),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        CommonTextView(
                                                                      label: dTransactionVal !=
                                                                              null
                                                                          ? dTransactionVal
                                                                              .toString()
                                                                          : 'Select',
                                                                      color: context
                                                                          .resources
                                                                          .color
                                                                          .themeColor,
                                                                    ),
                                                                  ),
                                                                  const RotatedBox(
                                                                    quarterTurns:
                                                                        1,
                                                                    child: Icon(
                                                                      Icons
                                                                          .search,
                                                                      size: 15,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                    ],
                                                  )
                                                : transactionType == 'date'
                                                    ? Row(
                                                        children: [
                                                          Expanded(
                                                              flex: 6,
                                                              child: InkWell(
                                                                onTap: dateTap,
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          AppWidth(
                                                                              5)),
                                                                  height:
                                                                      AppHeight(
                                                                          25),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: context
                                                                            .resources
                                                                            .color
                                                                            .themeColor,
                                                                        width:
                                                                            .2),
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            CommonTextView(
                                                                          label: transactionVal.toString().isNotEmpty
                                                                              ? transactionVal.toString()
                                                                              : 'Select',
                                                                          color: context
                                                                              .resources
                                                                              .color
                                                                              .themeColor,
                                                                          overFlow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLine:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                      Icon(
                                                                        dateIcon,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )),
                                                          const Expanded(
                                                              flex: 4,
                                                              child:
                                                                  SizedBox()),
                                                        ],
                                                      )
                                                    : transactionType == 'date2'
                                                        ? Row(
                                                            children: [
                                                              Expanded(
                                                                  flex: 6,
                                                                  child:
                                                                      InkWell(
                                                                    onTap:
                                                                        dateTap,
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              AppWidth(5)),
                                                                      height:
                                                                          AppHeight(
                                                                              25),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                context.resources.color.themeColor,
                                                                            width: .2),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                CommonTextView(
                                                                              label: transactionVal.toString().isNotEmpty ? transactionVal.toString() : 'Select',
                                                                              color: context.resources.color.themeColor,
                                                                              overFlow: TextOverflow.ellipsis,
                                                                              maxLine: 1,
                                                                            ),
                                                                          ),
                                                                          Icon(
                                                                            dateIcon,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ],
                                                          )
                                                        : transactionType ==
                                                                'map'
                                                            ? GestureDetector(
                                                                onTap: mapTap,
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      AppHeight(
                                                                          30),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          border:
                                                                              Border.all(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: .2,
                                                                  )),
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          AppWidth(
                                                                              5)),
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            CommonTextView(
                                                                          label: transactionVal.toString().isNotEmpty
                                                                              ? transactionVal.toString()
                                                                              : 'Use My Current Location',
                                                                          color: context
                                                                              .resources
                                                                              .color
                                                                              .themeColor,
                                                                          maxLine:
                                                                              1,
                                                                          overFlow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                      const Icon(
                                                                        Icons
                                                                            .share_location,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            : transactionType ==
                                                                    'Icon'
                                                                ? Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: isIconLoad
                                                                        ? CircularProgressIndicator(
                                                                            color:
                                                                                context.resources.color.themeColor,
                                                                          )
                                                                        : GestureDetector(
                                                                            onTap:
                                                                                iconFunction,
                                                                            child:
                                                                                Icon(
                                                                              transactionVal.toString() == 'True' ? Icons.toggle_on : Icons.toggle_off_outlined,
                                                                              color: context.resources.color.themeColor,
                                                                              size: 40,
                                                                            ),
                                                                          ),
                                                                  )
                                                                : transactionType ==
                                                                        'readonly'
                                                                    ? Container(
                                                                        height:
                                                                            AppHeight(30),
                                                                        decoration: myDecoration ??
                                                                            BoxDecoration(
                                                                                border: Border.all(
                                                                                  color: Colors.grey,
                                                                                  width: .2,
                                                                                ),
                                                                                color: Colors.amber.withOpacity(.1)),
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: AppWidth(5)),
                                                                        child:
                                                                            CommonTextView(
                                                                          label: transactionVal.toString().isNotEmpty
                                                                              ? transactionVal.toString()
                                                                              : '',
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          color: context
                                                                              .resources
                                                                              .color
                                                                              .themeColor,
                                                                          maxLine:
                                                                              1,
                                                                          overFlow:
                                                                              TextOverflow.ellipsis,
                                                                          // isSelectable: true,
                                                                        ),
                                                                      )
                                                                    : transactionType ==
                                                                            'manual'
                                                                        ? Container(
                                                                            height:
                                                                                AppHeight(30),
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                              color: Colors.grey,
                                                                              width: .2,
                                                                            )),
                                                                            child:
                                                                                CommonTextFormField(
                                                                              label: transactionVal.toString().isNotEmpty ? transactionVal.toString() : manualHint,
                                                                              isBorderSideNone: true,
                                                                              keyboardType: keyboardType,
                                                                              textColor: context.resources.color.themeColor,
                                                                              controller: manualController,
                                                                              onChanged: onManualChange,
                                                                              onFieldSubmitted: onFieldSubmitted,
                                                                            ),
                                                                          )
                                                                        : transactionType ==
                                                                                'checkbox'
                                                                            ? Container(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: GestureDetector(
                                                                                  onTap: iconFunction,
                                                                                  child: Icon(
                                                                                    transactionVal.toString() == 'Yes' ? Icons.check_box : Icons.check_box_outline_blank,
                                                                                    color: context.resources.color.themeColor,
                                                                                    size: 25,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : transactionType == 'Checkbox'
                                                                                ? Container(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: GestureDetector(
                                                                                      onTap: iconFunction,
                                                                                      child: Icon(
                                                                                        checkBoxIcon,
                                                                                        color: context.resources.color.themeColor,
                                                                                        size: 25,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                : transactionType == 'checkbox3'
                                                                                    ? Container(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        child: GestureDetector(
                                                                                          onTap: iconFunction,
                                                                                          child: Icon(
                                                                                            transactionVal.toString() == '1' ? Icons.check_box : Icons.check_box_outline_blank,
                                                                                            color: context.resources.color.themeColor,
                                                                                            size: 25,
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    : transactionType == 'checkbox0'
                                                                                        ? Container(
                                                                                            alignment: Alignment.centerLeft,
                                                                                            child: Icon(
                                                                                              transactionVal.toString() == '1' || transactionVal.toString() == 'Yes' || transactionVal.toString() == 'true' ? Icons.check_box : Icons.check_box_outline_blank,
                                                                                              color: Colors.grey,
                                                                                              size: 25,
                                                                                            ),
                                                                                          )
                                                                                        : transactionType == 'radio0'
                                                                                            ? Container(
                                                                                                alignment: Alignment.centerLeft,
                                                                                                child: Icon(
                                                                                                  transactionVal.toString() == '1' || transactionVal.toString() == 'Yes' || transactionVal.toString() == 'true' ? Icons.radio_button_checked : Icons.radio_button_off,
                                                                                                  color: Colors.grey,
                                                                                                  size: 25,
                                                                                                ),
                                                                                              )
                                                                                            : transactionType == 'radio'
                                                                                                ? Container(
                                                                                                    alignment: Alignment.centerLeft,
                                                                                                    child: GestureDetector(
                                                                                                      onTap: iconFunction,
                                                                                                      child: Icon(
                                                                                                        transactionVal.toString() == '1' || transactionVal.toString() == 'Yes' || transactionVal.toString() == 'true' ? Icons.radio_button_checked : Icons.radio_button_off,
                                                                                                        color: context.resources.color.themeColor,
                                                                                                        size: 25,
                                                                                                      ),
                                                                                                    ),
                                                                                                  )
                                                                                                : transactionType == 'customIcon'
                                                                                                    ? Container(
                                                                                                        alignment: Alignment.centerLeft,
                                                                                                        child: GestureDetector(
                                                                                                          onTap: iconFunction,
                                                                                                          child: Icon(
                                                                                                            customIcon,
                                                                                                            color: context.resources.color.themeColor,
                                                                                                            size: 25,
                                                                                                          ),
                                                                                                        ),
                                                                                                      )
                                                                                                    : transactionType == 'search_manual'
                                                                                                        ? Container(
                                                                                                            height: AppHeight(30),
                                                                                                            decoration: BoxDecoration(
                                                                                                              border: Border.all(
                                                                                                                color: Colors.grey,
                                                                                                                width: .2,
                                                                                                              ),
                                                                                                              color: msDisable ? Colors.amber.withOpacity(0.1) : Colors.white,
                                                                                                            ),
                                                                                                            child: Row(
                                                                                                              children: [
                                                                                                                Expanded(
                                                                                                                  child: Container(
                                                                                                                    height: AppHeight(30),
                                                                                                                    decoration: BoxDecoration(
                                                                                                                        color: Colors.amber.withOpacity(.1),
                                                                                                                        border: const Border(
                                                                                                                            right: BorderSide(
                                                                                                                          color: Colors.grey,
                                                                                                                          width: .2,
                                                                                                                        ))),
                                                                                                                    padding: EdgeInsets.symmetric(horizontal: AppWidth(5)),
                                                                                                                    child: Row(
                                                                                                                      children: [
                                                                                                                        Expanded(
                                                                                                                          child: CommonTextView(
                                                                                                                            label: transactionVal.toString().isNotEmpty ? transactionVal.toString() : 'Select',
                                                                                                                            color: context.resources.color.themeColor,
                                                                                                                            maxLine: 1,
                                                                                                                            alignment: Alignment.center,
                                                                                                                            onTap: !msDisable ? searchFunction : () {},
                                                                                                                            overFlow: TextOverflow.ellipsis,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        if (!msDisable)
                                                                                                                          const RotatedBox(
                                                                                                                            quarterTurns: 1,
                                                                                                                            child: Icon(
                                                                                                                              Icons.search,
                                                                                                                              size: 15,
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Expanded(
                                                                                                                  flex: 2,
                                                                                                                  child: !msDisable
                                                                                                                      ? CommonTextFormField(
                                                                                                                          label: dTransactionVal.toString().isNotEmpty ? dTransactionVal.toString() : manualHint,
                                                                                                                          isBorderSideNone: true,
                                                                                                                          textColor: context.resources.color.themeColor,
                                                                                                                          controller: manualController,
                                                                                                                          keyboardType: keyboardType,
                                                                                                                          maxLength: msLength,
                                                                                                                          enabled: transactionVal.toString().isNotEmpty,
                                                                                                                          //if empty -> cannot change the text
                                                                                                                          onChanged: onManualChange,
                                                                                                                        )
                                                                                                                      : CommonTextView(
                                                                                                                          label: dTransactionVal.toString().isNotEmpty ? dTransactionVal.toString() : '',
                                                                                                                          alignment: Alignment.centerLeft,
                                                                                                                          color: context.resources.color.themeColor,
                                                                                                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                                                                                                          maxLine: 1,
                                                                                                                          overFlow: TextOverflow.ellipsis,
                                                                                                                          // isSelectable: true,
                                                                                                                        ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          )
                                                                                                        : transactionType == 'search3'
                                                                                                            ? Container(
                                                                                                                //2 search
                                                                                                                height: AppHeight(30),
                                                                                                                decoration: BoxDecoration(
                                                                                                                    border: Border.all(
                                                                                                                  color: Colors.grey,
                                                                                                                  width: .2,
                                                                                                                )),
                                                                                                                child: Row(
                                                                                                                  children: [
                                                                                                                    Expanded(
                                                                                                                      child: Container(
                                                                                                                        height: AppHeight(30),
                                                                                                                        decoration: BoxDecoration(
                                                                                                                            color: Colors.amber.withOpacity(.1),
                                                                                                                            border: const Border(
                                                                                                                                right: BorderSide(
                                                                                                                              color: Colors.grey,
                                                                                                                              width: .2,
                                                                                                                            ))),
                                                                                                                        padding: EdgeInsets.symmetric(horizontal: AppWidth(5)),
                                                                                                                        child: Row(
                                                                                                                          children: [
                                                                                                                            Expanded(
                                                                                                                              child: CommonTextView(
                                                                                                                                label: transactionVal.toString().isNotEmpty ? transactionVal.toString() : 'Select',
                                                                                                                                color: context.resources.color.themeColor,
                                                                                                                                maxLine: 1,
                                                                                                                                alignment: Alignment.center,
                                                                                                                                onTap: !msDisable ? searchFunction : () {},
                                                                                                                                overFlow: TextOverflow.ellipsis,
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            if (!msDisable)
                                                                                                                              const RotatedBox(
                                                                                                                                quarterTurns: 1,
                                                                                                                                child: Icon(
                                                                                                                                  Icons.search,
                                                                                                                                  size: 15,
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                          ],
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Expanded(
                                                                                                                      flex: 2,
                                                                                                                      child: Row(
                                                                                                                        children: [
                                                                                                                          Expanded(
                                                                                                                            child: CommonTextView(
                                                                                                                              label: dTransactionVal.toString().isNotEmpty ? dTransactionVal.toString() : 'Select',
                                                                                                                              color: context.resources.color.themeColor,
                                                                                                                              maxLine: 1,
                                                                                                                              alignment: Alignment.center,
                                                                                                                              onTap: transactionVal.toString().isNotEmpty ? searchFunction2 : () {},
                                                                                                                              overFlow: TextOverflow.ellipsis,
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          if (transactionVal.toString().isNotEmpty)
                                                                                                                            const RotatedBox(
                                                                                                                              quarterTurns: 1,
                                                                                                                              child: Icon(
                                                                                                                                Icons.search,
                                                                                                                                size: 15,
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                      // CommonTextFormField(
                                                                                                                      //   label: dTransactionVal.toString().isNotEmpty ?
                                                                                                                      //   dTransactionVal.toString() : manualHint,
                                                                                                                      //   isBorderSideNone: true,
                                                                                                                      //   textColor: context.resources.color.themeColor,
                                                                                                                      //   controller: manualController,
                                                                                                                      //   maxLength: msLength,
                                                                                                                      //   enabled: transactionVal.toString().isNotEmpty,//if empty -> cannot change the text
                                                                                                                      //   onChanged: onManualChange,
                                                                                                                      // ),
                                                                                                                    ),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              )
                                                                                                            : transactionType == 'custom'
                                                                                                                ? customChild
                                                                                                                : transactionType == 'button'
                                                                                                                    ? SizedBox(
                                                                                                                        height: AppHeight(30),
                                                                                                                        child: ElevatedButton(
                                                                                                                          onPressed: buttonFunction,
                                                                                                                          style: ButtonStyle(
                                                                                                                            backgroundColor: MaterialStateProperty.all<Color>(context.resources.color.themeColor),
                                                                                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                                                              RoundedRectangleBorder(
                                                                                                                                borderRadius: BorderRadius.circular(3.0),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            elevation: MaterialStateProperty.all<double?>(0),
                                                                                                                          ),
                                                                                                                          child: CommonTextView(
                                                                                                                            label: transactionVal.toString().isNotEmpty ? transactionVal.toString() : 'Select',
                                                                                                                            color: Colors.white,
                                                                                                                            fontWeight: FontWeight.bold,
                                                                                                                            fontSize: myFontSize,
                                                                                                                            maxLine: 1,
                                                                                                                            overFlow: TextOverflow.ellipsis,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      )
                                                                                                                    : CommonTextView(
                                                                                                                        label: 'In Development',
                                                                                                                        padding: EdgeInsets.symmetric(horizontal: AppWidth(5)),
                                                                                                                      )),
                          ],
                        ),
                      );
  }
}

class TransactionStart extends StatelessWidget {
  final String label;
  final String labelVal;
  final bool isCalendar;
  final String label2;
  final Color label2Color;
  final Function? tap1;

  const TransactionStart({
    required this.label,
    this.isCalendar = false,
    required this.labelVal,
    required this.label2,
    this.label2Color = Colors.black,
    this.tap1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppHeight(10)),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonTextView(
                  label: label,
                  maxLine: 1,
                  overFlow: TextOverflow.ellipsis,
                ),
                InkWell(
                  onTap: () => tap1?.call(),
                  child: Row(
                    children: [
                      CommonTextView(
                        label: labelVal,
                        color: context.resources.color.themeColor,
                        margin: EdgeInsets.symmetric(horizontal: AppWidth(5)),
                        maxLine: 1,
                        overFlow: TextOverflow.ellipsis,
                      ),
                      isCalendar
                          ? SvgPicture.asset(
                              'assets/images/erp_app_icon/calendar.svg',
                              height: AppHeight(13),
                              color: context.resources.color.defaultBlueGrey,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 3,
              child: CommonTextView(
                label: label2,
                alignment: Alignment.centerRight,
                color: label2Color,
                maxLine: 1,
                overFlow: TextOverflow.ellipsis,
              )),
        ],
      ),
    );
  }
}
