import 'package:flutter/material.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/view/widget/CommonInkWell.dart';
import 'package:petty_cash/view/widget/CommonListingElements.dart';
import 'package:petty_cash/view/widget/common_empty_list%20copy.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:url_launcher/url_launcher.dart';

//add bool? isOpen = false; in model
class WFCommon extends StatefulWidget {
  final List<dynamic> listData;
  const WFCommon({super.key, required this.listData});

  @override
  State<WFCommon> createState() => _WFCommonState(listData);
}

class _WFCommonState extends State<WFCommon> {
  List<dynamic> listData1;
  // bool isOpen = false;//for settings icon on workflow
  bool isProject = false;
  bool isDivision = false;
  bool isDepartment = false;
  bool isDesignation = false;
  _WFCommonState(this.listData1);

  void isOpenWF(int index) {
    listData1[index].isOpen = !listData1[index].isOpen!;
    setState(() {});
  }

  // void setIsOpen(){isOpen = !isOpen;setState(() {});}
  void setIsProject(dynamic myState) {
    isProject = !isProject;
    setState(() {});
    myState(() {});
  }

  void setIsDivision(dynamic myState) {
    isDivision = !isDivision;
    setState(() {});
    myState(() {});
  }

  void setIsDepartment(dynamic myState) {
    isDepartment = !isDepartment;
    setState(() {});
    myState(() {});
  }

  void setIsDesignation(dynamic myState) {
    isDesignation = !isDesignation;
    setState(() {});
    myState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Color themeColor = context.resources.color.themeColor;
    return listData1.isEmpty
        ? const CommonEmptyList()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PopupMenuButton(
                padding: EdgeInsets.zero,
                offset: const Offset(-45, 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: themeColor, width: 2),
                ),
                elevation: 0.0,
                icon: Icon(
                  Icons.settings,
                  color: themeColor,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: StatefulBuilder(
                      builder: (context, myState) => InkWell(
                        onTap: () {
                          setIsDesignation(myState);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: AppWidth(5)),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                isDesignation
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: context.resources.color.themeColor,
                              ),
                              CommonTextView(
                                label: 'Designation',
                                padding: EdgeInsets.only(left: AppWidth(5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: StatefulBuilder(
                      builder: (context, myState) => InkWell(
                        onTap: () {
                          setIsProject(myState);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: AppWidth(5)),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                isProject
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: context.resources.color.themeColor,
                              ),
                              CommonTextView(
                                label: 'Project',
                                padding: EdgeInsets.only(left: AppWidth(5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: StatefulBuilder(
                      builder: (context, myState) => InkWell(
                        onTap: () {
                          setIsDivision(myState);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: AppWidth(5)),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                isDivision
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: context.resources.color.themeColor,
                              ),
                              CommonTextView(
                                label: 'Division',
                                padding: EdgeInsets.only(left: AppWidth(5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: StatefulBuilder(
                      builder: (context, myState) => InkWell(
                        onTap: () {
                          setIsDepartment(myState);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: AppWidth(5)),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                isDepartment
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: context.resources.color.themeColor,
                              ),
                              CommonTextView(
                                label: 'Department',
                                padding: EdgeInsets.only(left: AppWidth(5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: listData1.length,
                  padding: EdgeInsets.only(
                    right: AppWidth(5),
                    left: AppWidth(5),
                  ),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            right: AppWidth(5),
                            left: AppWidth(5),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(bottom: AppHeight(5)),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: AppHeight(30),
                                  decoration: BoxDecoration(
                                    color: context.resources.color.themeColor,
                                    border: const Border(
                                      bottom: BorderSide(
                                          width: 1.0, color: Colors.black),
                                    ),
                                  ),
                                  child: CommonInkWell(
                                    onTap: () {
                                      isOpenWF(index);
                                    },
                                    child: Row(
                                      children: [
                                        const MyHeaderData(
                                            title: 'Action Date & Time'),
                                        const RightBorder(),
                                        MyHeaderData(
                                          title: 'Action',
                                          isDropdown: true,
                                          dropIcon: listData1[index].isOpen
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: AppHeight(30),
                                  child: Row(
                                    children: [
                                      MyHeaderData(
                                        title:
                                            listData1[index].wfsAcDt!.isNotEmpty
                                                ? listData1[index].wfsAcDt!
                                                : '',
                                        textColor: Colors.black,
                                        myDecoration: BoxDecoration(
                                            color:
                                                Colors.amber.withOpacity(.1)),
                                      ),
                                      const RightBorder(),
                                      MyHeaderData(
                                        title: listData1[index]
                                                .wfsStatus!
                                                .isNotEmpty
                                            ? listData1[index].wfsStatus!
                                            : 'na',
                                        textColor: Colors.black,
                                        myDecoration: BoxDecoration(
                                            color:
                                                Colors.amber.withOpacity(.1)),
                                      ),
                                    ],
                                  ),
                                ),
                                ...listData1[index].isOpen!
                                    ? [
                                        MyListRows(
                                          title: 'AT. By Emp#',
                                          alignmentText1: Alignment.centerLeft,
                                          value: listData1[index].wfsEmpCode!,
                                          isSelectable: true,
                                          flex2: 1, //3 by default
                                          myDecoration: BoxDecoration(
                                              color:
                                                  Colors.amber.withOpacity(.1)),
                                        ),
                                        MyListRows(
                                          title: 'AT. By Emp. Name',
                                          alignmentText1: Alignment.centerLeft,
                                          value: listData1[index].wfsEmpName!,
                                          isSelectable: true,
                                          flex2: 1, //3 by default
                                          myDecoration: BoxDecoration(
                                              color:
                                                  Colors.amber.withOpacity(.1)),
                                        ),
                                        if (isDesignation)
                                          MyListRows(
                                            title: 'Designation',
                                            alignmentText1:
                                                Alignment.centerLeft,
                                            value: listData1[index]
                                                .wfsDesignation!,
                                            isSelectable: true,
                                            flex2: 1, //3 by default
                                            myDecoration: BoxDecoration(
                                                color: Colors.amber
                                                    .withOpacity(.1)),
                                          ),
                                        if (isProject)
                                          MyListRows(
                                            title: 'Project',
                                            alignmentText1:
                                                Alignment.centerLeft,
                                            value: listData1[index].wfsProject!,
                                            isSelectable: true,
                                            flex2: 1, //3 by default
                                            myDecoration: BoxDecoration(
                                                color: Colors.amber
                                                    .withOpacity(.1)),
                                          ),
                                        if (isDivision)
                                          MyListRows(
                                            title: 'Division',
                                            alignmentText1:
                                                Alignment.centerLeft,
                                            value:
                                                listData1[index].wfsDivision!,
                                            isSelectable: true,
                                            flex2: 1, //3 by default
                                            myDecoration: BoxDecoration(
                                                color: Colors.amber
                                                    .withOpacity(.1)),
                                          ),
                                        if (isDepartment)
                                          MyListRows(
                                            title: 'Department',
                                            alignmentText1:
                                                Alignment.centerLeft,
                                            value:
                                                listData1[index].wfsDepartment!,
                                            isSelectable: true,
                                            flex2: 1, //3 by default
                                            myDecoration: BoxDecoration(
                                                color: Colors.amber
                                                    .withOpacity(.1)),
                                          ),
                                        MyListRows(
                                          title: 'Remark',
                                          alignmentText1: Alignment.centerLeft,
                                          value: listData1[index].wfsRemarks!,
                                          isSelectable: true,
                                          flex2: 1, //3 by default
                                          myDecoration: BoxDecoration(
                                              color:
                                                  Colors.amber.withOpacity(.1)),
                                        ),
                                        listData1[index]
                                                .wfsAttachment
                                                .toString()
                                                .isNotEmpty
                                            ? MyListRows(
                                                title: 'Attachment',
                                                alignmentText1:
                                                    Alignment.centerLeft,
                                                value: listData1[index]
                                                    .wfsRemarks!,
                                                isIcon: true,
                                                onTap: () async {
                                                  //iconFunction
                                                  Uri url = Uri.parse(
                                                      ApiUrl.baseUrl! +
                                                          listData1[index]
                                                              .wfsAttachment
                                                              .toString());
                                                  if (!await launchUrl(url)) {
                                                    throw Exception(
                                                        'Could not launch $url');
                                                  }
                                                },
                                                flex2: 1, //3 by default
                                              )
                                            : const SizedBox(),
                                      ]
                                    : [],
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: context.resources.color.themeColor),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: CommonTextView(
                                label: '${index + 1}',
                                fontSize: context
                                    .resources.dimension.appExtraSmallText,
                                color: Colors.white,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
  }
}
