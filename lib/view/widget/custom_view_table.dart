import 'package:flutter/material.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/view/widget/CommonListingElements.dart';
import 'package:petty_cash/view/widget/common_text.dart';

//Fix the textEditing controller by giving default value
class CustomViewOnlyTable extends StatelessWidget {
  final dynamic data;
  final bool isTitle;
  final String title;
  final bool isLess; //reduce list length by 1
  final bool isScrollable;
  final String header0;
  final bool isIconHeader0;
  final Function(int)? header0IconTap;
  final Function(int)? header0IconData;
  final Color header0IconColor;
  final bool ischildHeader0;
  final Widget Function(int)? headerChild;

  final String header1;
  final TextInputType header2KeyboardType;
  final bool isTextHeader1;
  final Function(int)? header1Controller;
  final Function(String, int)? header1TextOnChange;
  final bool isIconHeader1;
  final Function(int)? header1IconTap;
  final Function(int)? header1IconData;
  final Color header1IconColor;
  final bool isSearchHeader1;
  final Function(int)? header1Search;
  final dynamic header1Decoration;

  final String header2;
  final bool isTextHeader2;
  final Color header2TextColor;
  final Function(int)? header2Controller;
  final Function(String, int)? header2TextOnChange;
  final bool isIconHeader2;
  final Function(int)? header2IconTap;
  final Function(int)? header2IconData;
  final Color header2IconColor;
  final bool isSearchHeader2;
  final Function(int)? header2Search;
  final Function(int)? header2LongPress;
  final dynamic header2Decoration;
  final Function(int) onOpen;
  final Function(dynamic) getHeader1;
  final Function(dynamic) getHeader2;

  final bool isRow1;
  final bool isSelect2Row1;
  final String row1Title;
  final Function(dynamic) row1Label;
  final Function(int)? isTextRow1; //bool
  final Function(int)? row1Controller;
  final Function(String, int)? row1TextOnChange;
  final TextInputType row1KeyboardType;
  final dynamic row1Decoration;
  final bool isIconRow1;
  final Function(int)? row1Tap;
  final Function(int)? row1IconData;
  final int row1IconTurns;
  final Color row1IconColor;
  final double row1IconSize;
  final bool isRow1Search;

  final bool isRow2Header;
  final String row2Header;

  final bool isRow2;
  final bool isSelect2Row2;
  final String row2Title;
  final Function(dynamic)? row2Label;
  final bool isTextRow2;
  final Function(int)? row2Controller;
  final Function(String, int)? row2TextOnChange;
  final TextInputType row2KeyboardType;
  final dynamic row2Decoration;
  final bool isIconRow2;
  final Function(int)? row2Tap;
  final Function(int)? row2IconData;
  final int row2IconTurns;
  final Color row2IconColor;
  final double row2IconSize;
  final bool isRow2Search;

  final bool isRow3Header;
  final String row3Header;

  final bool isRow3;
  final bool isSelect2Row3;
  final String row3Title;
  final Function(dynamic)? row3Label;
  final bool isTextRow3;
  final Function(int)? row3Controller;
  final Function(String, int)? row3TextOnChange;
  final TextInputType row3KeyboardType;
  final dynamic row3Decoration;
  final bool isIconRow3;
  final Function(int)? row3Tap;
  final Function(int)? row3IconData;
  final int row3IconTurns;
  final Color row3IconColor;
  final double row3IconSize;
  final bool isRow3Search;

  final bool isRow4Header;
  final String row4Header;

  final bool isRow4;
  final bool isSelect2Row4;
  final String row4Title;
  final Function(dynamic)? row4Label;
  final bool isTextRow4;
  final Function(int)? row4Controller;
  final Function(String, int)? row4TextOnChange;
  final TextInputType row4KeyboardType;
  final dynamic row4Decoration;
  final bool isIconRow4;
  final Function(int)? row4Tap;
  final Function(int)? row4IconData;
  final int row4IconTurns;
  final Color row4IconColor;
  final double row4IconSize;
  final bool isRow4Search;

  final bool isRow5Header;
  final String row5Header;

  final bool isRow5;
  final bool isSelect2Row5;
  final String row5Title;
  final Function(dynamic)? row5Label;
  final bool isTextRow5;
  final Function(int)? row5Controller;
  final Function(String, int)? row5TextOnChange;
  final TextInputType row5KeyboardType;
  final dynamic Function(int)? row5Decoration;
  final bool isIconRow5;
  final Function(int)? row5Tap;
  final Function(int)? row5IconData;
  final int row5IconTurns;
  final Color row5IconColor;
  final double row5IconSize;
  final bool Function(int)? isRow5Search;

  final bool isRow6Header;
  final String row6Header;

  final bool isRow6;
  final bool isSelect2Row6;
  final String row6Title;
  final Function(dynamic)? row6Label;
  final bool isTextRow6;
  final Function(int)? row6Controller;
  final Function(String, int)? row6TextOnChange;
  final TextInputType row6KeyboardType;
  final dynamic row6Decoration;
  final bool isIconRow6;
  final Function(int)? row6Tap;
  final Function(int)? row6IconData;
  final int row6IconTurns;
  final Color row6IconColor;
  final double row6IconSize;
  final bool isRow6Search;

  final bool isRow7Header;
  final String row7Header;

  final bool isRow7;
  final bool isSelect2Row7;
  final String row7Title;
  final Function(dynamic)? row7Label;
  final bool Function(int)? isTextRow7;
  final Function(int)? row7Controller;
  final Function(String, int)? row7TextOnChange;
  final TextInputType row7KeyboardType;
  final dynamic row7Decoration;
  final bool isIconRow7;
  final Function(int)? row7Tap;
  final Function(int)? row7IconData;
  final int row7IconTurns;
  final Color row7IconColor;
  final double row7IconSize;
  final bool Function(int)? isRow7Search;

  final bool isRow8;
  final bool isSelect2Row8;
  final String row8Title;
  final Function(dynamic)? row8Label;
  final bool isTextRow8;
  final Function(int)? row8Controller;
  final Function(String, int)? row8TextOnChange;
  final TextInputType row8KeyboardType;
  final dynamic row8Decoration;
  final bool isIconRow8;
  final Function(int)? row8Tap;
  final Function(int)? row8IconData;
  final int row8IconTurns;
  final Color row8IconColor;
  final double row8IconSize;
  final bool isRow8Search;

  final bool isRow9;
  final bool isSelect2Row9;
  final String row9Title;
  final Function(dynamic)? row9Label;
  final bool isTextRow9;
  final Function(int)? row9Controller;
  final Function(String, int)? row9TextOnChange;
  final TextInputType row9KeyboardType;
  final dynamic row9Decoration;
  final bool isIconRow9;
  final Function(int)? row9Tap;
  final Function(int)? row9IconData;
  final int row9IconTurns;
  final Color row9IconColor;
  final double row9IconSize;
  final bool isRow9Search;

  final bool isRow10;
  final bool isSelect2Row10;
  final String row10Title;
  final Function(dynamic)? row10Label;
  final bool isTextRow10;
  final Function(int)? row10Controller;
  final Function(String, int)? row10TextOnChange;
  final TextInputType row10KeyboardType;
  final dynamic row10Decoration;
  final bool isIconRow10;
  final Function(int)? row10Tap;
  final Function(int)? row10IconData;
  final int row10IconTurns;
  final Color row10IconColor;
  final double row10IconSize;
  final bool isRow10Search;

  final bool isRow11;
  final bool isSelect2Row11;
  final String row11Title;
  final Function(dynamic)? row11Label;
  final bool isTextRow11;
  final Function(int)? row11Controller;
  final Function(String, int)? row11TextOnChange;
  final TextInputType row11KeyboardType;
  final dynamic row11Decoration;
  final bool isIconRow11;
  final Function(int)? row11Tap;
  final Function(int)? row11IconData;
  final int row11IconTurns;
  final Color row11IconColor;
  final double row11IconSize;
  final bool isRow11Search;

  final bool isRow12;
  final bool isSelect2Row12;
  final String row12Title;
  final Function(dynamic)? row12Label;
  final bool isTextRow12;
  final Function(int)? row12Controller;
  final Function(String, int)? row12TextOnChange;
  final TextInputType row12KeyboardType;
  final dynamic row12Decoration;
  final bool isIconRow12;
  final Function(int)? row12Tap;
  final Function(int)? row12IconData;
  final int row12IconTurns;
  final Color row12IconColor;
  final double row12IconSize;
  final bool isRow12Search;

  final bool isRow13;
  final bool isSelect2Row13;
  final String row13Title;
  final Function(dynamic)? row13Label;
  final bool isTextRow13;
  final Function(int)? row13Controller;
  final Function(String, int)? row13TextOnChange;
  final TextInputType row13KeyboardType;
  final dynamic row13Decoration;
  final bool isIconRow13;
  final Function(int)? row13Tap;
  final Function(int)? row13IconData;
  final int row13IconTurns;
  final Color row13IconColor;
  final double row13IconSize;
  final bool isRow13Search;

  final bool isRow14;
  final bool isSelect2Row14;
  final String row14Title;
  final Function(dynamic)? row14Label;
  final bool isTextRow14;
  final Function(int)? row14Controller;
  final Function(String, int)? row14TextOnChange;
  final TextInputType row14KeyboardType;
  final dynamic row14Decoration;
  final bool isIconRow14;
  final Function(int)? row14Tap;
  final Function(int)? row14IconData;
  final int row14IconTurns;
  final Color row14IconColor;
  final double row14IconSize;
  final bool isRow14Search;

  final bool isRow15;
  final bool isSelect2Row15;
  final String row15Title;
  final Function(dynamic)? row15Label;
  final bool isTextRow15;
  final Function(int)? row15Controller;
  final Function(String, int)? row15TextOnChange;
  final TextInputType row15KeyboardType;
  final dynamic row15Decoration;
  final bool isIconRow15;
  final Function(int)? row15Tap;
  final Function(int)? row15IconData;
  final int row15IconTurns;
  final Color row15IconColor;
  final double row15IconSize;
  final bool isRow15Search;

  const CustomViewOnlyTable({
    required this.data,
    this.isTitle = false,
    this.title = 'default0',
    this.isLess = false,
    this.isScrollable = true,
    this.header0 = '#',
    this.isIconHeader0 = false,
    this.header0IconTap,
    this.header0IconData,
    this.header0IconColor = Colors.black,
    required this.header1,
    this.isTextHeader1 = false,
    this.header1Controller,
    this.header1TextOnChange,
    this.isIconHeader1 = false,
    this.header1IconTap,
    this.header1IconData,
    this.header1IconColor = Colors.black,
    this.ischildHeader0 = false,
    this.headerChild,
    this.isSearchHeader1 = false,
    this.header1Search,
    this.header1Decoration,
    required this.header2,
    this.isTextHeader2 = false,
    this.header2TextColor = Colors.black,
    this.header2Controller,
    this.header2TextOnChange,
    this.isIconHeader2 = false,
    this.header2IconTap,
    this.header2IconData,
    this.header2IconColor = Colors.black,
    this.isSearchHeader2 = false,
    this.header2Search,
    this.header2LongPress,
    this.header2Decoration,
    required this.onOpen,
    required this.getHeader1,
    required this.getHeader2,
    this.isRow1 = true,
    this.isSelect2Row1 = true,
    this.row1Title = 'default1',
    required this.row1Label,
    this.isTextRow1,
    this.row1Controller,
    this.row1TextOnChange,
    this.row1KeyboardType = TextInputType.text,
    this.row1Decoration,
    this.isIconRow1 = false,
    this.row1Tap,
    this.row1IconData,
    this.row1IconTurns = 0,
    this.row1IconColor = Colors.black,
    this.row1IconSize = 15,
    this.isRow1Search = false,
    this.isRow2Header = false,
    this.row2Header = 'header2',
    this.isRow2 = false,
    this.isSelect2Row2 = true,
    this.row2Title = 'default2',
    this.row2Label,
    this.isTextRow2 = false,
    this.row2Controller,
    this.row2TextOnChange,
    this.row2KeyboardType = TextInputType.text,
    this.row2Decoration,
    this.isIconRow2 = false,
    this.row2Tap,
    this.row2IconData,
    this.row2IconTurns = 0,
    this.row2IconColor = Colors.black,
    this.row2IconSize = 15,
    this.isRow2Search = false,
    this.isRow3Header = false,
    this.row3Header = 'header3',
    this.isRow3 = false,
    this.isSelect2Row3 = true,
    this.row3Title = 'default3',
    this.row3Label,
    this.isTextRow3 = false,
    this.row3Controller,
    this.row3TextOnChange,
    this.row3KeyboardType = TextInputType.text,
    this.row3Decoration,
    this.isIconRow3 = false,
    this.row3Tap,
    this.row3IconData,
    this.row3IconTurns = 0,
    this.row3IconColor = Colors.black,
    this.row3IconSize = 15,
    this.isRow3Search = false,
    this.isRow4Header = false,
    this.row4Header = 'header4',
    this.isRow4 = false,
    this.isSelect2Row4 = true,
    this.row4Title = 'default4',
    this.row4Label,
    this.isTextRow4 = false,
    this.row4Controller,
    this.row4TextOnChange,
    this.row4KeyboardType = TextInputType.text,
    this.row4Decoration,
    this.isIconRow4 = false,
    this.row4Tap,
    this.row4IconData,
    this.row4IconTurns = 0,
    this.row4IconColor = Colors.black,
    this.row4IconSize = 15,
    this.isRow4Search = false,
    this.isRow5Header = false,
    this.row5Header = 'header5',
    this.isRow5 = false,
    this.isSelect2Row5 = true,
    this.row5Title = 'default5',
    this.row5Label,
    this.isTextRow5 = false,
    this.row5Controller,
    this.row5TextOnChange,
    this.row5KeyboardType = TextInputType.text,
    this.row5Decoration,
    this.isIconRow5 = false,
    this.row5Tap,
    this.row5IconData,
    this.row5IconTurns = 0,
    this.row5IconColor = Colors.black,
    this.row5IconSize = 15,
    this.isRow5Search,
    this.isRow6Header = false,
    this.row6Header = 'header6',
    this.isRow6 = false,
    this.isSelect2Row6 = true,
    this.row6Title = 'default6',
    this.row6Label,
    this.isTextRow6 = false,
    this.row6Controller,
    this.row6TextOnChange,
    this.row6KeyboardType = TextInputType.text,
    this.row6Decoration,
    this.isIconRow6 = false,
    this.row6Tap,
    this.row6IconData,
    this.row6IconTurns = 0,
    this.row6IconColor = Colors.black,
    this.row6IconSize = 15,
    this.isRow6Search = false,
    this.isRow7Header = false,
    this.row7Header = 'header7',
    this.isRow7 = false,
    this.isSelect2Row7 = true,
    this.row7Title = 'default7',
    this.row7Label,
    this.isTextRow7,
    this.row7Controller,
    this.row7TextOnChange,
    this.row7KeyboardType = TextInputType.text,
    this.row7Decoration,
    this.isIconRow7 = false,
    this.row7Tap,
    this.row7IconData,
    this.row7IconTurns = 0,
    this.row7IconColor = Colors.black,
    this.row7IconSize = 15,
    this.isRow7Search,
    this.isRow8 = false,
    this.isSelect2Row8 = true,
    this.row8Title = 'default7',
    this.row8Label,
    this.isTextRow8 = false,
    this.row8Controller,
    this.row8TextOnChange,
    this.row8KeyboardType = TextInputType.text,
    this.row8Decoration,
    this.isIconRow8 = false,
    this.row8Tap,
    this.row8IconData,
    this.row8IconTurns = 0,
    this.row8IconColor = Colors.black,
    this.row8IconSize = 15,
    this.isRow8Search = false,
    this.isRow9 = false,
    this.isSelect2Row9 = true,
    this.row9Title = 'default7',
    this.row9Label,
    this.isTextRow9 = false,
    this.row9Controller,
    this.row9TextOnChange,
    this.row9KeyboardType = TextInputType.text,
    this.row9Decoration,
    this.isIconRow9 = false,
    this.row9Tap,
    this.row9IconData,
    this.row9IconTurns = 0,
    this.row9IconColor = Colors.black,
    this.row9IconSize = 15,
    this.isRow9Search = false,
    this.isRow10 = false,
    this.isSelect2Row10 = true,
    this.row10Title = 'default7',
    this.row10Label,
    this.isTextRow10 = false,
    this.row10Controller,
    this.row10TextOnChange,
    this.row10KeyboardType = TextInputType.text,
    this.row10Decoration,
    this.isIconRow10 = false,
    this.row10Tap,
    this.row10IconData,
    this.row10IconTurns = 0,
    this.row10IconColor = Colors.black,
    this.row10IconSize = 15,
    this.isRow10Search = false,
    this.isRow11 = false,
    this.isSelect2Row11 = true,
    this.row11Title = 'default7',
    this.row11Label,
    this.isTextRow11 = false,
    this.row11Controller,
    this.row11TextOnChange,
    this.row11KeyboardType = TextInputType.text,
    this.row11Decoration,
    this.isIconRow11 = false,
    this.row11Tap,
    this.row11IconData,
    this.row11IconTurns = 0,
    this.row11IconColor = Colors.black,
    this.row11IconSize = 15,
    this.isRow11Search = false,
    this.isRow12 = false,
    this.isSelect2Row12 = true,
    this.row12Title = 'default7',
    this.row12Label,
    this.isTextRow12 = false,
    this.row12Controller,
    this.row12TextOnChange,
    this.row12KeyboardType = TextInputType.text,
    this.row12Decoration,
    this.isIconRow12 = false,
    this.row12Tap,
    this.row12IconData,
    this.row12IconTurns = 0,
    this.row12IconColor = Colors.black,
    this.row12IconSize = 15,
    this.isRow12Search = false,
    this.isRow13 = false,
    this.isSelect2Row13 = true,
    this.row13Title = 'default7',
    this.row13Label,
    this.isTextRow13 = false,
    this.row13Controller,
    this.row13TextOnChange,
    this.row13KeyboardType = TextInputType.text,
    this.row13Decoration,
    this.isIconRow13 = false,
    this.row13Tap,
    this.row13IconData,
    this.row13IconTurns = 0,
    this.row13IconColor = Colors.black,
    this.row13IconSize = 15,
    this.isRow13Search = false,
    this.isRow14 = false,
    this.isSelect2Row14 = true,
    this.row14Title = 'default7',
    this.row14Label,
    this.isTextRow14 = false,
    this.row14Controller,
    this.row14TextOnChange,
    this.row14KeyboardType = TextInputType.text,
    this.row14Decoration,
    this.isIconRow14 = false,
    this.row14Tap,
    this.row14IconData,
    this.row14IconTurns = 0,
    this.row14IconColor = Colors.black,
    this.row14IconSize = 15,
    this.isRow14Search = false,
    this.isRow15 = false,
    this.isSelect2Row15 = true,
    this.row15Title = 'default7',
    this.row15Label,
    this.isTextRow15 = false,
    this.row15Controller,
    this.row15TextOnChange,
    this.row15KeyboardType = TextInputType.text,
    this.row15Decoration,
    this.isIconRow15 = false,
    this.row15Tap,
    this.row15IconData,
    this.row15IconTurns = 0,
    this.row15IconColor = Colors.black,
    this.row15IconSize = 15,
    this.isRow15Search = false,
    super.key,
    this.header2KeyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: isLess ? data.length - 1 : data.length,
      shrinkWrap: true,
      physics: isScrollable
          ? null
          : const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
      padding: EdgeInsets.symmetric(horizontal: AppWidth(10)),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: AppHeight(10)),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            children: [
              //Title
              isTitle
                  ? Container(
                      height: AppHeight(30),
                      decoration: BoxDecoration(
                        color: context.resources.color.themeColor,
                        border: const Border(
                          bottom: BorderSide(width: 1.0, color: Colors.black),
                        ),
                      ),
                      child: CommonTextView(
                        label: title,
                        color: Colors.white,
                        alignment: Alignment.center,
                        fontFamily: 'Italic',
                      ),
                    )
                  : const SizedBox(),

              //Header
              Container(
                height: AppHeight(30),
                decoration: BoxDecoration(
                  color: context.resources.color.themeColor,
                  border: const Border(
                    bottom: BorderSide(width: 1.0, color: Colors.black),
                  ),
                ),
                child: Row(
                  children: [
                    MyHeaderData(
                      title: header0,
                      flex: 1,
                      isIcon: isIconHeader0,
                      onIconTap: () => header0IconTap!(index),
                      iconData: header0IconData == null
                          ? Icons.add
                          : header0IconData!(index),
                      iconColor: header0IconColor,
                    ),
                    const RightBorder(),
                    MyHeaderData(
                      title: header1,
                      flex: 2,
                    ),
                    const RightBorder(),
                    MyHeaderData(
                      title: header2,
                      flex: ischildHeader0 ? 2 : 3,
                      isDropdown: true,
                      onTap: () => onOpen(index),
                      dropIcon: data![index].isOpen!
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                    ),
                    if (ischildHeader0) const RightBorder(),
                    if (ischildHeader0) headerChild!(index),
                  ],
                ),
              ),

              //Header Row
              SizedBox(
                height: AppHeight(30),
                child: Row(
                  children: [
                    MyHeaderData(
                      title: '${index + 1}',
                      textColor: Colors.black,
                      flex: 1,
                      myDecoration:
                          BoxDecoration(color: Colors.amber.withOpacity(.1)),
                    ),
                    const RightBorder(),
                    MyHeaderData(
                      title: getHeader1(data[index]),
                      textColor: Colors.black,
                      flex: 2,
                      isTextField: isTextHeader1,
                      controller: header1Controller == null
                          ? TextEditingController()
                          : header1Controller!(index),
                      onChange: (val) => header1TextOnChange!(val, index),
                      isIcon: isIconHeader1,
                      onIconTap: () => header1IconTap!(index),
                      iconData: header1IconData == null
                          ? Icons.add
                          : header1IconData!(index),
                      iconColor: header1IconColor,
                      isSearch: isSearchHeader1,
                      onTap: header1Search == null
                          ? () {}
                          : () => header1Search!(index),
                      myDecoration: header1Decoration ??
                          BoxDecoration(color: Colors.amber.withOpacity(.1)),
                    ),
                    const RightBorder(),
                    MyHeaderData(
                      title: getHeader2(data[index]),
                      textColor: header2TextColor,
                      flex: 3,
                      isTextField: isTextHeader2,
                      controller: header2Controller == null
                          ? TextEditingController()
                          : header2Controller!(index),
                      keyboardType: header2KeyboardType,
                      onChange: (val) => header2TextOnChange!(val, index),
                      isIcon: isIconHeader2,
                      onIconTap: () => header2IconTap!(index),
                      iconData: header2IconData == null
                          ? Icons.add
                          : header2IconData!(index),
                      iconColor: header2IconColor,
                      isSearch: isSearchHeader2,
                      onTap: () => header2Search!(index),
                      onLongPress: () => header2LongPress?.call(index),
                      myDecoration: header2Decoration ??
                          BoxDecoration(color: Colors.amber.withOpacity(.1)),
                    ),
                  ],
                ),
              ),

              //Other Rows
              if (data![index].isOpen!)
                Column(
                  children: [
                    isRow1
                        ? MyListRows(
                            title: row1Title,
                            value: row1Label(data[index]),
                            isTextField:
                                isTextRow1 == null ? false : isTextRow1!(index),
                            controller: row1Controller == null
                                ? TextEditingController()
                                : row1Controller!(index),
                            onChange: (val) => row1TextOnChange!(val, index),
                            keyboardType: row1KeyboardType,
                            isIcon: isIconRow1,
                            onTap:
                                row1Tap == null ? () {} : () => row1Tap!(index),
                            myIcon: row1IconData == null
                                ? Icons.search
                                : row1IconData!(index),
                            iconColor: row1IconColor,
                            iconSize: row1IconSize,
                            isSearchIcon: isRow1Search,
                            myDecoration: row1Decoration ??
                                BoxDecoration(
                                    color: Colors.amber.withOpacity(.1)),
                            iconTurns: row1IconTurns,
                            isSelectable: true,
                            isSelect2: isSelect2Row1,
                            flex1: 2,
                            flex2: 4,
                          )
                        : const SizedBox(),
                    isRow2Header
                        ? Container(
                            height: AppHeight(30),
                            decoration: BoxDecoration(
                              color: context.resources.color.themeColor,
                              border: const Border(
                                top:
                                    BorderSide(width: 1.0, color: Colors.black),
                              ),
                            ),
                            child: CommonTextView(
                              label: row2Header,
                              color: Colors.white,
                              alignment: Alignment.center,
                              fontFamily: 'Italic',
                            ),
                          )
                        : const SizedBox(),
                    isRow2
                        ? MyListRows(
                            title: row2Title,
                            isSelect2: isSelect2Row2,
                            value: row2Label!(data[index]),
                            isSelectable: true,
                            flex1: 2,
                            flex2: 4,
                            isTextField: isTextRow2,
                            controller: row2Controller == null
                                ? TextEditingController()
                                : row2Controller!(index),
                            onChange: (val) => row2TextOnChange!(val, index),
                            keyboardType: row2KeyboardType,
                            isIcon: isIconRow2,
                            onTap: () => row2Tap!(index),
                            myIcon: row2IconData == null
                                ? Icons.search
                                : row2IconData!(index),
                            iconColor: row2IconColor,
                            iconSize: row2IconSize,
                            isSearchIcon: isRow2Search,
                            myDecoration: row2Decoration ??
                                BoxDecoration(
                                    color: Colors.amber.withOpacity(.1)),
                            iconTurns: row2IconTurns,
                          )
                        : const SizedBox(),
                    isRow3Header
                        ? Container(
                            height: AppHeight(30),
                            decoration: BoxDecoration(
                              color: context.resources.color.themeColor,
                              border: const Border(
                                top:
                                    BorderSide(width: 1.0, color: Colors.black),
                              ),
                            ),
                            child: CommonTextView(
                              label: row3Header,
                              color: Colors.white,
                              alignment: Alignment.center,
                              fontFamily: 'Italic',
                            ),
                          )
                        : const SizedBox(),
                    isRow3
                        ? MyListRows(
                            title: row3Title,
                            isSelect2: isSelect2Row3,
                            value: row3Label!(data[index]),
                            isSelectable: true,
                            flex1: 2,
                            flex2: 4,
                            isTextField: isTextRow3,
                            controller: row3Controller == null
                                ? TextEditingController()
                                : row3Controller!(index),
                            onChange: (val) => row3TextOnChange!(val, index),
                            keyboardType: row3KeyboardType,
                            isIcon: isIconRow3,
                            onTap: () => row3Tap!(index),
                            myIcon: row3IconData == null
                                ? Icons.search
                                : row3IconData!(index),
                            iconColor: row3IconColor,
                            iconSize: row3IconSize,
                            isSearchIcon: isRow3Search,
                            myDecoration: row3Decoration ??
                                BoxDecoration(
                                    color: Colors.amber.withOpacity(.1)),
                            iconTurns: row3IconTurns,
                          )
                        : const SizedBox(),
                    isRow4Header
                        ? Container(
                            height: AppHeight(30),
                            decoration: BoxDecoration(
                              color: context.resources.color.themeColor,
                              border: const Border(
                                top:
                                    BorderSide(width: 1.0, color: Colors.black),
                              ),
                            ),
                            child: CommonTextView(
                              label: row4Header,
                              color: Colors.white,
                              alignment: Alignment.center,
                              fontFamily: 'Italic',
                            ),
                          )
                        : const SizedBox(),
                    isRow4
                        ? MyListRows(
                            title: row4Title,
                            isSelect2: isSelect2Row4,
                            value: row4Label!(data[index]),
                            isSelectable: true,
                            flex1: 2,
                            flex2: 4,
                            isTextField: isTextRow4,
                            controller: row4Controller == null
                                ? TextEditingController()
                                : row4Controller!(index),
                            onChange: (val) => row4TextOnChange!(val, index),
                            keyboardType: row4KeyboardType,
                            isIcon: isIconRow4,
                            onTap: () => row4Tap!(index),
                            myIcon: row4IconData == null
                                ? Icons.search
                                : row4IconData!(index),
                            iconColor: row4IconColor,
                            iconSize: row4IconSize,
                            isSearchIcon: isRow4Search,
                            myDecoration: row4Decoration ??
                                BoxDecoration(
                                    color: Colors.amber.withOpacity(.1)),
                            iconTurns: row4IconTurns,
                          )
                        : const SizedBox(),
                    isRow5Header
                        ? Container(
                            height: AppHeight(30),
                            decoration: BoxDecoration(
                              color: context.resources.color.themeColor,
                              border: const Border(
                                top:
                                    BorderSide(width: 1.0, color: Colors.black),
                              ),
                            ),
                            child: CommonTextView(
                              label: row5Header,
                              color: Colors.white,
                              alignment: Alignment.center,
                              fontFamily: 'Italic',
                            ),
                          )
                        : const SizedBox(),
                    isRow5
                        ? MyListRows(
                            title: row5Title,
                            isSelect2: isSelect2Row5,
                            value: row5Label!(data[index]),
                            isSelectable: true,
                            flex1: 2,
                            flex2: 4,
                            isTextField: isTextRow5,
                            controller: row5Controller == null
                                ? TextEditingController()
                                : row5Controller!(index),
                            onChange: (val) => row5TextOnChange!(val, index),
                            keyboardType: row5KeyboardType,
                            isIcon: isIconRow5,
                            onTap: () => row5Tap!(index),
                            myIcon: row5IconData == null
                                ? Icons.search
                                : row5IconData!(index),
                            iconColor: row5IconColor,
                            iconSize: row5IconSize,
                            isSearchIcon: isRow5Search == null
                                ? false
                                : isRow5Search!(index),
                            myDecoration: row5Decoration == null
                                ? BoxDecoration(
                                    color: Colors.amber.withOpacity(.1))
                                : row5Decoration!(index),
                            iconTurns: row5IconTurns,
                          )
                        : const SizedBox(),
                    isRow6Header
                        ? Container(
                            height: AppHeight(30),
                            decoration: BoxDecoration(
                              color: context.resources.color.themeColor,
                              border: const Border(
                                top:
                                    BorderSide(width: 1.0, color: Colors.black),
                              ),
                            ),
                            child: CommonTextView(
                              label: row6Header,
                              color: Colors.white,
                              alignment: Alignment.center,
                              fontFamily: 'Italic',
                            ),
                          )
                        : const SizedBox(),
                    isRow6
                        ? MyListRows(
                            title: row6Title,
                            isSelect2: isSelect2Row6,
                            value: row6Label!(data[index]),
                            isSelectable: true,
                            flex1: 2,
                            flex2: 4,
                            isTextField: isTextRow6,
                            controller: row6Controller == null
                                ? TextEditingController()
                                : row6Controller!(index),
                            onChange: (val) => row6TextOnChange!(val, index),
                            keyboardType: row6KeyboardType,
                            isIcon: isIconRow6,
                            onTap: () => row6Tap!(index),
                            myIcon: row6IconData == null
                                ? Icons.search
                                : row6IconData!(index),
                            iconColor: row6IconColor,
                            iconSize: row6IconSize,
                            isSearchIcon: isRow6Search,
                            myDecoration: row6Decoration ??
                                BoxDecoration(
                                    color: Colors.amber.withOpacity(.1)),
                            iconTurns: row6IconTurns,
                          )
                        : const SizedBox(),
                    isRow7Header
                        ? Container(
                            height: AppHeight(30),
                            decoration: BoxDecoration(
                              color: context.resources.color.themeColor,
                              border: const Border(
                                top:
                                    BorderSide(width: 1.0, color: Colors.black),
                              ),
                            ),
                            child: CommonTextView(
                              label: row7Header,
                              color: Colors.white,
                              alignment: Alignment.center,
                              fontFamily: 'Italic',
                            ),
                          )
                        : const SizedBox(),
                    isRow7
                        ? MyListRows(
                            title: row7Title,
                            isSelect2: isSelect2Row7,
                            value: row7Label!(data[index]),
                            isSelectable: true,
                            flex1: 2,
                            flex2: 4,
                            isTextField:
                                isTextRow7 == null ? false : isTextRow7!(index),
                            controller: row7Controller == null
                                ? TextEditingController()
                                : row7Controller!(index),
                            onChange: (val) => row7TextOnChange!(val, index),
                            keyboardType: row7KeyboardType,
                            isIcon: isIconRow7,
                            onTap: () => row7Tap!(index),
                            myIcon: row7IconData == null
                                ? Icons.search
                                : row7IconData!(index),
                            iconColor: row7IconColor,
                            iconSize: row7IconSize,
                            isSearchIcon: isRow7Search == null
                                ? false
                                : isRow7Search!(index),
                            myDecoration: row7Decoration == null
                                ? BoxDecoration(
                                    color: Colors.amber.withOpacity(.1))
                                : row7Decoration!(index),
                            iconTurns: row7IconTurns,
                          )
                        : const SizedBox(),
                    isRow8
                        ? MyListRows(
                            title: row8Title,
                            isSelect2: isSelect2Row8,
                            value: row8Label!(data[index]),
                            isSelectable: true,
                            flex1: 2,
                            flex2: 4,
                            isTextField: isTextRow8,
                            controller: row8Controller == null
                                ? TextEditingController()
                                : row8Controller!(index),
                            onChange: (val) => row8TextOnChange!(val, index),
                            keyboardType: row8KeyboardType,
                            isIcon: isIconRow8,
                            onTap: () => row8Tap!(index),
                            myIcon: row8IconData == null
                                ? Icons.search
                                : row8IconData!(index),
                            iconColor: row8IconColor,
                            iconSize: row8IconSize,
                            isSearchIcon: isRow8Search,
                            myDecoration: row8Decoration ??
                                BoxDecoration(
                                    color: Colors.amber.withOpacity(.1)),
                            iconTurns: row8IconTurns,
                          )
                        : const SizedBox(),
                    isRow9
                        ? MyListRows(
                            title: row9Title,
                            isSelect2: isSelect2Row9,
                            value: row9Label!(data[index]),
                            isSelectable: true,
                            flex1: 2,
                            flex2: 4,
                            isTextField: isTextRow9,
                            controller: row9Controller == null
                                ? TextEditingController()
                                : row9Controller!(index),
                            onChange: (val) => row9TextOnChange!(val, index),
                            keyboardType: row9KeyboardType,
                            isIcon: isIconRow9,
                            onTap: () => row9Tap!(index),
                            myIcon: row9IconData == null
                                ? Icons.search
                                : row9IconData!(index),
                            iconColor: row9IconColor,
                            iconSize: row9IconSize,
                            isSearchIcon: isRow9Search,
                            myDecoration: row9Decoration ??
                                BoxDecoration(
                                    color: Colors.amber.withOpacity(.1)),
                            iconTurns: row9IconTurns,
                          )
                        : const SizedBox(),
                    isRow10
                        ? MyListRows(
                            title: row10Title,
                            isSelect2: isSelect2Row10,
                            value: row10Label!(data[index]),
                            isSelectable: true,
                            flex1: 2,
                            flex2: 4,
                            isTextField: isTextRow10,
                            controller: row10Controller == null
                                ? TextEditingController()
                                : row10Controller!(index),
                            onChange: (val) => row10TextOnChange!(val, index),
                            keyboardType: row10KeyboardType,
                            isIcon: isIconRow10,
                            onTap: () => row10Tap!(index),
                            myIcon: row10IconData == null
                                ? Icons.search
                                : row10IconData!(index),
                            iconColor: row10IconColor,
                            iconSize: row10IconSize,
                            isSearchIcon: isRow10Search,
                            myDecoration: row10Decoration ??
                                BoxDecoration(
                                    color: Colors.amber.withOpacity(.1)),
                            iconTurns: row10IconTurns,
                          )
                        : const SizedBox(),
                    isRow11
                        ? MyListRows(
                            title: row11Title,
                            isSelect2: isSelect2Row11,
                            value: row11Label!(data[index]),
                            isSelectable: true,
                            flex1: 2,
                            flex2: 4,
                            isTextField: isTextRow11,
                            controller: row11Controller == null
                                ? TextEditingController()
                                : row11Controller!(index),
                            onChange: (val) => row11TextOnChange!(val, index),
                            keyboardType: row11KeyboardType,
                            isIcon: isIconRow11,
                            onTap: () => row11Tap!(index),
                            myIcon: row11IconData == null
                                ? Icons.search
                                : row11IconData!(index),
                            iconColor: row11IconColor,
                            iconSize: row11IconSize,
                            isSearchIcon: isRow11Search,
                            myDecoration: row11Decoration ??
                                BoxDecoration(
                                    color: Colors.amber.withOpacity(.1)),
                            iconTurns: row11IconTurns,
                          )
                        : const SizedBox(),
                    isRow12
                        ? MyListRows(
                            title: row12Title,
                            isSelect2: isSelect2Row12,
                            value: row12Label!(data[index]),
                            isSelectable: true,
                            flex1: 2,
                            flex2: 4,
                            isTextField: isTextRow12,
                            controller: row12Controller == null
                                ? TextEditingController()
                                : row12Controller!(index),
                            onChange: (val) => row12TextOnChange!(val, index),
                            keyboardType: row12KeyboardType,
                            isIcon: isIconRow12,
                            onTap: () => row12Tap!(index),
                            myIcon: row12IconData == null
                                ? Icons.search
                                : row12IconData!(index),
                            iconColor: row12IconColor,
                            iconSize: row12IconSize,
                            isSearchIcon: isRow12Search,
                            myDecoration: row12Decoration ??
                                BoxDecoration(
                                    color: Colors.amber.withOpacity(.1)),
                            iconTurns: row12IconTurns,
                          )
                        : const SizedBox(),
                    isRow13
                        ? MyListRows(
                            title: row13Title,
                            isSelect2: isSelect2Row13,
                            value: row13Label!(data[index]),
                            isSelectable: true,
                            flex1: 2,
                            flex2: 4,
                            isTextField: isTextRow13,
                            controller: row13Controller == null
                                ? TextEditingController()
                                : row13Controller!(index),
                            onChange: (val) => row13TextOnChange!(val, index),
                            keyboardType: row13KeyboardType,
                            isIcon: isIconRow13,
                            onTap: () => row13Tap!(index),
                            myIcon: row13IconData == null
                                ? Icons.search
                                : row13IconData!(index),
                            iconColor: row13IconColor,
                            iconSize: row13IconSize,
                            isSearchIcon: isRow13Search,
                            myDecoration: row13Decoration ??
                                BoxDecoration(
                                    color: Colors.amber.withOpacity(.1)),
                            iconTurns: row13IconTurns,
                          )
                        : const SizedBox(),
                    isRow14
                        ? MyListRows(
                            title: row14Title,
                            isSelect2: isSelect2Row14,
                            value: row14Label!(data[index]),
                            isSelectable: true,
                            flex1: 2,
                            flex2: 4,
                            isTextField: isTextRow14,
                            controller: row14Controller == null
                                ? TextEditingController()
                                : row14Controller!(index),
                            onChange: (val) => row14TextOnChange!(val, index),
                            keyboardType: row14KeyboardType,
                            isIcon: isIconRow14,
                            onTap: () => row14Tap!(index),
                            myIcon: row14IconData == null
                                ? Icons.search
                                : row14IconData!(index),
                            iconColor: row14IconColor,
                            iconSize: row14IconSize,
                            isSearchIcon: isRow14Search,
                            myDecoration: row14Decoration ??
                                BoxDecoration(
                                    color: Colors.amber.withOpacity(.1)),
                            iconTurns: row14IconTurns,
                          )
                        : const SizedBox(),
                    isRow15
                        ? MyListRows(
                            title: row15Title,
                            isSelect2: isSelect2Row15,
                            value: row15Label!(data[index]),
                            isSelectable: true,
                            flex1: 2,
                            flex2: 4,
                            isTextField: isTextRow15,
                            controller: row15Controller == null
                                ? TextEditingController()
                                : row15Controller!(index),
                            onChange: (val) => row15TextOnChange!(val, index),
                            keyboardType: row15KeyboardType,
                            isIcon: isIconRow15,
                            onTap: () => row15Tap!(index),
                            myIcon: row15IconData == null
                                ? Icons.search
                                : row15IconData!(index),
                            iconColor: row15IconColor,
                            iconSize: row15IconSize,
                            isSearchIcon: isRow15Search,
                            myDecoration: row15Decoration ??
                                BoxDecoration(
                                    color: Colors.amber.withOpacity(.1)),
                            iconTurns: row15IconTurns,
                          )
                        : const SizedBox(),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
