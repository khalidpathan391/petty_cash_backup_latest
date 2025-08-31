
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:petty_cash/data/models/custom/upload_progress.dart';
// import 'package:petty_cash/data/repository/general_rep.dart';
// import 'package:petty_cash/global.dart';
// import 'package:petty_cash/globalSize.dart';
// import 'package:petty_cash/resources/api_url.dart';
// import 'package:petty_cash/resources/app_extension_context.dart';
// import 'package:petty_cash/utils/app_utils.dart';
// import 'package:petty_cash/view/base/BaseGestureTouchSafeArea.dart';
// import 'package:petty_cash/view/common/CustomLoaders/custom_refresh.dart';
// import 'package:petty_cash/view/widget/CommonInkWell.dart';
// import 'package:petty_cash/view/widget/CommonListingElements.dart';
// import 'package:petty_cash/view/widget/CommonPaginationSearching.dart';
// import 'package:petty_cash/view/widget/common_button.dart';
// import 'package:petty_cash/view/widget/common_text.dart';


// // Call Something like this
// // Navigator.push(context, MaterialPageRoute(builder: (context) => PaginationSearching(
// // ApiUrl.baseUrl! + ApiUrl.hseCommonSearch, 'EMPLOYEE', '',),),
// // ).then((value){
// // if(value != null) {
// // }
// // notifyListeners();
// // });

// class CommonAttachment extends StatefulWidget {
//   final bool isUpload;
//   final String txnType;
//   final String docNo;
//   final String tab;
//   final String uniqueVal;
//   final String lineId;
//   final String headerId;
//   final String menuId;
//   final List<int> attachmentIds;
//   const CommonAttachment({
//     super.key,
//     this.isUpload = true,
//     required this.txnType,
//     required this.docNo,
//     required this.tab,
//     required this.uniqueVal,
//     required this.lineId,
//     required this.headerId,
//     this.menuId = '',
//     this.attachmentIds = const [],
//   });

//   @override
//   State<CommonAttachment> createState() => _CommonAttachmentState();
// }

// class _CommonAttachmentState extends State<CommonAttachment> {
//   //read the change in value of progress
//   final ValueNotifier<UploadProgress> _progress =
//       ValueNotifier<UploadProgress>(UploadProgress(
//     0,
//     0,
//     0,
//   ));
//   final CancelToken cancelToken = CancelToken(); //for cancel token
//   @override
//   void initState() {
//     // viewData!.attachmentLst!.clear();//so the old static data is removed
//     selectedIndex.clear();
//     isApiLoading = false;
//     addAttachmentLine();
//     getAttachments();
//     super.initState();
//   }

//   final _myRepo = GeneralRepository();
//   bool isLoading = false;
//   AttachmentViewModel? viewData;
//   var chartData = ChartData(chartList: []);
//   List<int> selectedIndex = [];
//   bool allSelected = false;
//   String docTitle = '';
//   String docId = '';
//   String docType = '';
//   List<String> allAttachmentPath = [];
//   int currentIndex = 0;

//   void addAttachmentLine() {
//     setState(() {
//       var data = ChildChartData();
//       data.typeId = '';
//       data.docType = '';
//       data.type = '';
//       data.isSelected = allSelected; //haha
//       data.anyDataPath = '';
//       // data.typeList = [];
//       // data.typeList1 = [];
//       // data.typeList2 = [];
//       chartData.chartList.add(data);
//     });
//   }

//   void selectAllAttachment() {
//     setState(() {
//       allSelected = !allSelected;
//       for (int i = 0; i < chartData.chartList.length; i++) {
//         if (allSelected) {
//           chartData.chartList[i].isSelected = true;
//         } else {
//           chartData.chartList[i].isSelected = false;
//         }
//       }
//     });
//   }

//   void deleteAttachmentLine() {
//     setState(() {
//       if (allSelected) {
//         chartData.chartList.clear();
//         selectedIndex.clear();
//       } else {
//         //sort the index in descending order from big to small
//         //this makes sure the last item is removed first so the index issue doesn't come when removing items
//         selectedIndex.sort((a, b) => b.compareTo(a));
//         //remove all the selected indexes
//         for (int i = 0; i < selectedIndex.length; i++) {
//           chartData.chartList.removeAt(selectedIndex[i]);
//         }
//         selectedIndex.clear();
//       }
//       if (chartData.chartList.isEmpty) {
//         allSelected = false;
//       }
//     });
//   }

//   bool isApiLoading = false;

//   void checkAndAdd(BuildContext context) {
//     docTitle = '';
//     docType = '';
//     docId = '';
//     allAttachmentPath.clear();

//     for (int i = 0; i < chartData.chartList.length; i++) {
//       if (chartData.chartList[i].docType!.isNotEmpty &&
//           chartData.chartList[i].type!.isNotEmpty &&
//           chartData.chartList[i].typeId!.isNotEmpty &&
//           chartData.chartList[i].anyDataPath!.isNotEmpty) {
//         docTitle += '${chartData.chartList[i].docType},';
//         docType += '${chartData.chartList[i].type},';
//         docId += '${chartData.chartList[i].typeId},';
//         allAttachmentPath.add(chartData.chartList[i].anyDataPath!);
//       }
//     }
//     //removing last comma
//     docTitle = AppUtils.removeLastCharacter(docTitle);
//     docType = AppUtils.removeLastCharacter(docType);
//     docId = AppUtils.removeLastCharacter(docId);
//     if (docTitle.isEmpty) {
//       AppUtils.showToastRedBg(context, 'Document Type Cannot Be Empty');
//     } else if (docType.isEmpty) {
//       AppUtils.showToastRedBg(context, 'Document Title Cannot Be Empty');
//     } else if (allAttachmentPath.isEmpty) {
//       AppUtils.showToastRedBg(context, 'Attachment Cannot Be Empty');
//     } else {
//       addAttachments();
//     }
//   }

//   Future<void> addAttachments() async {
//     setState(() {
//       isApiLoading = true;
//     });
//     //data for dio to send params
//     FormData formData = FormData();
//     formData.fields.add(MapEntry("user_id", Global.empData!.userId.toString()));
//     formData.fields
//         .add(MapEntry("company_id", Global.empData!.companyId.toString()));
//     formData.fields.add(MapEntry("header_id", widget.headerId));
//     formData.fields.add(MapEntry("line_id", widget.lineId));
//     formData.fields.add(MapEntry("doc_title", docTitle));
//     formData.fields.add(MapEntry("doc_type_id", docId));
//     formData.fields.add(MapEntry("doc_type_name", docType));
//     formData.fields.add(MapEntry("unique_val", widget.uniqueVal));
//     formData.fields.add(MapEntry("tab", widget.tab));
//     formData.fields.add(MapEntry(
//         "menu_id",
//         widget.menuId.isNotEmpty
//             ? widget.menuId
//             : Global.menuData!.id
//                 .toString())); //114 default for hse sor transaction
//     formData.fields.add(MapEntry("txn_type", widget.txnType));
//     formData.fields.add(MapEntry("doc_no", widget.docNo));

//     _myRepo.postApiWithListFileAll(
//       '', File(''), '', File(''), fileParam: 'file_name',
//       baseUrl: ApiUrl.baseUrl!, url: ApiUrl.commonAddAttachments,
//       allData: allAttachmentPath, formData: formData,
//       onProgress: (progress) {
//         _progress.value = progress;
//       }, //update the changes in value
//       cancelToken: cancelToken,
//     ).then((value) {
//       if (value == 1) {
//         AppUtils.showToastRedBg(context, 'Api Call Cancelled!');
//       } else {
//         if (value['error_code'] == 200) {
//           AppUtils.showToastGreenBg(context, value['error_description']);
//           chartData.chartList.clear(); //clear old lines
//           addAttachmentLine(); // make 1 new default line
//           getAttachments(); // call the list in view
//         } else {
//           AppUtils.showToastRedBg(context, value['error_description']);
//         }
//       }
//     }).onError((error, stackTrace) {
//       AppUtils.showToastRedBg(context, 'error: $error');
//     }).whenComplete(() {
//       setState(() {
//         isApiLoading = false;
//       });
//     });
//   }

//   Future<void> getAttachments() async {
//     String attachmentIdString = widget.attachmentIds.join(',');
//     Map<String, String> getListData = {
//       'header_id': widget.headerId,
//       'doc_no': widget.docNo,
//       'txn_type': widget.txnType,
//       'menu_id': widget.menuId.isNotEmpty
//           ? widget.menuId
//           : Global.menuData!.id.toString(), //114
//       'tab': widget.tab,
//       'line_id': widget.lineId,
//       'unique_val': widget.uniqueVal,
//       'attachment_ids': attachmentIdString,
//     };
//     setState(() {
//       isLoading = true;
//     });
//     _myRepo
//         .postApi(ApiUrl.baseUrl! + ApiUrl.commonGetAttachmentList, getListData)
//         .then((value) {
//       viewData = AttachmentViewModel.fromJson(value);
//     }).onError((error, stackTrace) {
//       if (AppUtils.errorMessage.isEmpty) {
//         AppUtils.errorMessage = error.toString();
//       }
//     }).whenComplete(() {
//       isLoading = false;
//       setState(() {});
//     });
//   }

//   int deleteIndex = -1;

//   Future<void> deleteAttachments(
//       BuildContext context, String attachId, int index) async {
//     setState(() {
//       deleteIndex = index;
//     });
//     _myRepo.postApi(ApiUrl.baseUrl! + ApiUrl.commonDeleteAttachment,
//         {'attach_id': attachId}).then((value) {
//       if (value['error_code'] == 200) {
//         AppUtils.showToastGreenBg(context, value['error_description']);
//         viewData!.attachmentLst!.removeAt(index);
//         viewData!.headerAttchLst!.removeAt(index);
//       } else {
//         AppUtils.showToastRedBg(context, value['error_description']);
//       }
//     }).onError((error, stackTrace) {
//       AppUtils.showToastRedBg(context, 'error: $error');
//     }).whenComplete(() {
//       setState(() {
//         deleteIndex = -1;
//       });
//     });
//   }

//   List<int> attachmentId = [];

//   @override
//   Widget build(BuildContext context) {
//     Color themeColor = context.resources.color.themeColor;
//     return WillPopScope(
//       onWillPop: () async {
//         Global.attachmentsLength = viewData!.attachmentLst!.length;
//         Global.headerAttachmentList.clear();
//         if (viewData!.headerAttchLst != null) {
//           Global.headerAttachmentList = viewData!.headerAttchLst!;
//         }
//         attachmentId.clear();
//         if (viewData!.attachmentLst!.isNotEmpty) {
//           for (int i = 0; i < viewData!.attachmentLst!.length; i++) {
//             attachmentId.add(viewData!.attachmentLst![i].attachedId!);
//           }
//         }
//         if (!isApiLoading || !isLoading) {
//           //have to send by default the length so had to change the value
//           Navigator.pop(context, <dynamic>[
//             viewData!.attachmentLst!.length,
//             viewData!.headerAttchLst!,
//             attachmentId
//           ]);
//         } else {
//           bool value = await showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: CommonTextView(
//                     label: 'Are you sure?',
//                     alignment: Alignment.center,
//                     fontFamily: 'Bold',
//                     fontSize: context.resources.dimension.appBigText + 5,
//                   ),
//                   content: CommonTextView(
//                     label: 'Do you want to exit without saving changes?',
//                     fontSize: context.resources.dimension.appBigText,
//                     fontFamily: 'Bold',
//                     maxLine: 5,
//                     overFlow: TextOverflow.ellipsis,
//                     color: Colors.red,
//                   ),
//                   actions: <Widget>[
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         CommonButton(
//                           onPressed: () => Navigator.pop(context,
//                               false), //pop the dialog and send the value as false
//                           text: 'No',
//                           color: context.resources.color.themeColor
//                               .withOpacity(.5),
//                           textColor: Colors.white,
//                         ),
//                         CommonButton(
//                           onPressed: () => Navigator.pop(context,
//                               true), //pop the dialog and send the value as true
//                           text: 'Yes',
//                           color: context.resources.color.themeColor,
//                           textColor: Colors.white,
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ) ??
//               false; // ?? means giving default value as false
//           if (value) {
//             Navigator.pop(context, <dynamic>[
//               viewData!.attachmentLst!.length,
//               viewData!.headerAttchLst!,
//               attachmentId
//             ]);
//             cancelToken
//                 .cancel('Canceled'); //if they click yes cancel the api call
//           }
//         }
//         return false;
//       },
//       // canPop: !isApiLoading, //must be false to work so if api loading true i make it false for the popup to show
//       // onPopInvoked: (bool didPop) {
//       //   Global.attachmentsLength = viewData!.attachmentLst!.length;
//       //   AppUtils.popDialog(
//       //     context,didPop,
//       //     content: 'The Upload Progress will be lost if you go back now!',
//       //     isCancel: true,
//       //     cancelToken: cancelToken,
//       //     length: viewData!.attachmentLst!.length,
//       //   );
//       // },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: context.resources.color.themeColor,
//           iconTheme: const IconThemeData(color: Colors.white),
//           automaticallyImplyLeading: false,
//           centerTitle: true,
//           leading: InkWell(
//               onTap: () {
//                 if (isApiLoading || isLoading) {
//                   AppUtils.showToastRedBg(
//                       context, 'Cannot go back when data is being uploaded');
//                 } else {
//                   attachmentId.clear();
//                   if (viewData!.attachmentLst!.isNotEmpty) {
//                     for (int i = 0; i < viewData!.attachmentLst!.length; i++) {
//                       attachmentId.add(viewData!.attachmentLst![i].attachedId!);
//                     }
//                   }
//                   Navigator.pop(context, <dynamic>[
//                     viewData!.attachmentLst!.length,
//                     viewData!.headerAttchLst!,
//                     attachmentId
//                   ]);
//                 }
//               },
//               child: const Icon(Icons.arrow_back_ios_new_rounded)),
//           title: CommonTextView(
//             label: 'Attachments',
//             color: Colors.white,
//             fontSize: context.resources.dimension.appBigText + 3,
//             fontFamily: 'Bold',
//           ),
//         ),
//         body: isLoading
//             ? const Center(child: CustomLoader())
//             :
//             // AppUtils.errorMessage.isNotEmpty ? AppUtils(context).getCommonErrorWidget(() {
//             //   setState(() {AppUtils.errorMessage = '';});}, ''):
//             DefaultTabController(
//                 initialIndex: widget.isUpload ? 0 : 1,
//                 length: 2,
//                 child: Column(
//                   children: [
//                     TabBar(
//                       tabs: [
//                         Tab(
//                           child: CommonTextView(
//                             label: 'Upload',
//                             fontSize: context.resources.dimension.appBigText,
//                             margin:
//                                 EdgeInsets.symmetric(horizontal: AppWidth(10)),
//                           ),
//                         ),
//                         Tab(
//                           child: CommonTextView(
//                             label: 'Download/View',
//                             fontSize: context.resources.dimension.appBigText,
//                             margin:
//                                 EdgeInsets.symmetric(horizontal: AppWidth(10)),
//                           ),
//                         ),
//                       ],
//                       indicatorPadding: const EdgeInsets.all(0),
//                       padding: const EdgeInsets.all(0),
//                       tabAlignment: TabAlignment.center,
//                       indicator: BoxDecoration(
//                         color: Colors.white,
//                         border: Border(
//                             bottom: BorderSide(
//                           color: context.resources.color.themeColor,
//                           width: 2,
//                         )),
//                       ),
//                       overlayColor: MaterialStateColor.resolveWith((states) {
//                         if (states.contains(MaterialState.pressed)) {
//                           return context.resources.color.themeColor
//                               .withOpacity(.2);
//                         }
//                         return Colors.white;
//                       }),
//                       isScrollable: true,
//                     ),
//                     Expanded(
//                       child: TabBarView(
//                         children: [
//                           //Upload
//                           BaseGestureTouchSafeArea(
//                             child: Scaffold(
//                               appBar: AppBar(
//                                 automaticallyImplyLeading: false,
//                                 iconTheme: IconThemeData(color: themeColor),
//                                 title: Row(
//                                   children: [
//                                     IconButton(
//                                       onPressed: () {
//                                         selectAllAttachment();
//                                       },
//                                       icon: Icon(
//                                         allSelected
//                                             ? Icons.check_box
//                                             : Icons.check_box_outline_blank,
//                                         color: themeColor,
//                                       ),
//                                     ),
//                                     const CommonTextView(
//                                       label: 'Select All',
//                                     ),
//                                     Expanded(
//                                         child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         IconButton(
//                                           onPressed: () {
//                                             addAttachmentLine();
//                                           },
//                                           icon: const Icon(Icons.add),
//                                         ),
//                                         IconButton(
//                                           onPressed: () {
//                                             deleteAttachmentLine();
//                                           },
//                                           icon: const Icon(Icons.delete),
//                                         ),
//                                       ],
//                                     )),
//                                   ],
//                                 ),
//                               ),
//                               bottomNavigationBar: SizedBox(
//                                 child: isApiLoading
//                                     ? ValueListenableBuilder<UploadProgress>(
//                                         valueListenable: _progress,
//                                         builder: (context, value, child) {
//                                           return Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               ...value.progress != 1
//                                                   ? [
//                                                       LinearProgressIndicator(
//                                                         value: value.progress,
//                                                         backgroundColor: context
//                                                             .resources
//                                                             .color
//                                                             .themeColor
//                                                             .withOpacity(.5),
//                                                         valueColor:
//                                                             AlwaysStoppedAnimation<
//                                                                     Color>(
//                                                                 context
//                                                                     .resources
//                                                                     .color
//                                                                     .themeColor),
//                                                         minHeight: AppHeight(2),
//                                                       ),
//                                                       CommonTextView(
//                                                         label:
//                                                             '${AppUtils.formatBytes(value.sentBytes)} / ${AppUtils.formatBytes(value.totalBytes)}',
//                                                         padding:
//                                                             EdgeInsets.only(
//                                                                 top: AppHeight(
//                                                                     10)),
//                                                       ),
//                                                       CommonTextView(
//                                                         label:
//                                                             'Uploading : ${(value.progress * 100).toStringAsFixed(0)}%',
//                                                         padding: EdgeInsets
//                                                             .symmetric(
//                                                                 vertical:
//                                                                     AppHeight(
//                                                                         10)),
//                                                       ),
//                                                     ]
//                                                   : [
//                                                       LinearProgressIndicator(
//                                                         backgroundColor: context
//                                                             .resources
//                                                             .color
//                                                             .themeColor
//                                                             .withOpacity(.5),
//                                                         valueColor:
//                                                             AlwaysStoppedAnimation<
//                                                                     Color>(
//                                                                 context
//                                                                     .resources
//                                                                     .color
//                                                                     .themeColor),
//                                                         minHeight: AppHeight(2),
//                                                       ),
//                                                       CommonTextView(
//                                                         label:
//                                                             'Syncing Data ...',
//                                                         padding: EdgeInsets
//                                                             .symmetric(
//                                                                 vertical:
//                                                                     AppHeight(
//                                                                         10)),
//                                                       ),
//                                                     ],
//                                             ],
//                                           );
//                                         },
//                                       )
//                                     : CommonButton(
//                                         onPressed: isApiLoading
//                                             ? () {}
//                                             : () {
//                                                 if (widget.isUpload) {
//                                                   checkAndAdd(context);
//                                                 } else {
//                                                   AppUtils.showToastRedBg(
//                                                       context,
//                                                       "Upload isn't available in View mode");
//                                                 }
//                                               },
//                                         margin: EdgeInsets.symmetric(
//                                             horizontal: AppWidth(75)),
//                                         // isLoading: isApiLoading,
//                                         text: 'Save',
//                                       ),
//                               ),
//                               body: ListView.builder(
//                                   itemCount: chartData.chartList.length,
//                                   shrinkWrap: true,
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: AppWidth(10),
//                                   ),
//                                   itemBuilder: (context, index) {
//                                     return Container(
//                                       margin: EdgeInsets.symmetric(
//                                           vertical: AppHeight(10)),
//                                       decoration: BoxDecoration(
//                                         border: Border.all(color: Colors.black),
//                                       ),
//                                       child: Column(
//                                         children: [
//                                           Container(
//                                             height: AppHeight(30),
//                                             decoration: BoxDecoration(
//                                               color: context
//                                                   .resources.color.themeColor,
//                                               border: const Border(
//                                                 bottom: BorderSide(
//                                                     width: 1.0,
//                                                     color: Colors.black),
//                                               ),
//                                             ),
//                                             child: CommonInkWell(
//                                               onTap: () {},
//                                               child: Row(
//                                                 children: [
//                                                   MyHeaderData(
//                                                     title: '#',
//                                                     isIcon: true,
//                                                     iconData: chartData
//                                                             .chartList[index]
//                                                             .isSelected!
//                                                         ? Icons.check_box
//                                                         : Icons
//                                                             .check_box_outline_blank,
//                                                     onIconTap: () {
//                                                       setState(() {
//                                                         chartData
//                                                                 .chartList[index]
//                                                                 .isSelected =
//                                                             !chartData
//                                                                 .chartList[
//                                                                     index]
//                                                                 .isSelected!;
//                                                         if (chartData
//                                                             .chartList[index]
//                                                             .isSelected!) {
//                                                           selectedIndex
//                                                               .add(index);
//                                                         } else {
//                                                           selectedIndex
//                                                               .remove(index);
//                                                         }
//                                                       });
//                                                     },
//                                                     flex: 20,
//                                                   ),
//                                                   const RightBorder(),
//                                                   const MyHeaderData(
//                                                     title: 'Type',
//                                                     flex: 35,
//                                                   ),
//                                                   const RightBorder(),
//                                                   const MyHeaderData(
//                                                     title: 'Document Title',
//                                                     flex: 35,
//                                                   ),
//                                                   const RightBorder(),
//                                                   MyHeaderData(
//                                                     title: '#',
//                                                     isIcon: true,
//                                                     isIconCount: true,
//                                                     iconCount: chartData
//                                                             .chartList[index]
//                                                             .anyDataPath!
//                                                             .isNotEmpty
//                                                         ? '1'
//                                                         : '0',
//                                                     iconData: Icons.attach_file,
//                                                     onIconTap:
//                                                         // chartData.chartList[index].anyDataPath!.isNotEmpty ? (){
//                                                         //   AppUtils.showToastRedBg(context, 'Only 1 item per line');
//                                                         // }://removed the check
//                                                         () {
//                                                       setState(() {
//                                                         currentIndex = index;
//                                                       });
//                                                       showBottomSheet(context);
//                                                     },
//                                                     flex: 10,
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: AppHeight(30),
//                                             child: Row(
//                                               children: [
//                                                 MyHeaderData(
//                                                   title: '${index + 1}',
//                                                   textColor: Colors.black,
//                                                   flex: 20,
//                                                 ),
//                                                 const RightBorder(),
//                                                 MyHeaderData(
//                                                     title: chartData
//                                                             .chartList[index]
//                                                             .type!
//                                                             .isNotEmpty
//                                                         ? chartData
//                                                             .chartList[index]
//                                                             .type!
//                                                         : 'Select',
//                                                     textColor: Colors.black,
//                                                     flex: 35,
//                                                     onTap: () {
//                                                       Global.commonSearchType =
//                                                           SearchListType
//                                                               .defaultType;
//                                                       Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               PaginationSearching(
//                                                             url: ApiUrl
//                                                                     .baseUrl! +
//                                                                 ApiUrl
//                                                                     .commonAttachmentTypeList,
//                                                             txnType: 'SOR',
//                                                             searchKeyWord: '',
//                                                             searchType: '',
//                                                           ),
//                                                         ),
//                                                       ).then((value) {
//                                                         if (value != null) {
//                                                           chartData
//                                                               .chartList[index]
//                                                               .typeId = value[
//                                                                   0]
//                                                               .toString();
//                                                           chartData
//                                                                   .chartList[index]
//                                                                   .type =
//                                                               value[
//                                                                   2]; //'${value[1]}-${value[2]}';
//                                                         }
//                                                       }).whenComplete(() {
//                                                         setState(() {});
//                                                       });
//                                                     }),
//                                                 const RightBorder(),
//                                                 MyHeaderData(
//                                                   title: chartData
//                                                           .chartList[index]
//                                                           .docType!
//                                                           .isNotEmpty
//                                                       ? chartData
//                                                           .chartList[index]
//                                                           .docType!
//                                                       : 'Here',
//                                                   textColor: Colors.black,
//                                                   isTextField: true,
//                                                   controller: chartData
//                                                       .chartList[index]
//                                                       .controller,
//                                                   onChange: (val) {
//                                                     setState(() {
//                                                       chartData.chartList[index]
//                                                           .docType = val;
//                                                     });
//                                                   },
//                                                   flex: 45,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   }),
//                             ),
//                           ),
//                           //Download/View
//                           ListView.builder(
//                               itemCount: viewData!.attachmentLst!.isNotEmpty
//                                   ? viewData!.attachmentLst!.length
//                                   : 0,
//                               shrinkWrap: true,
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: AppWidth(10),
//                               ),
//                               itemBuilder: (context, index) {
//                                 return Container(
//                                   margin: EdgeInsets.symmetric(
//                                       vertical: AppHeight(10)),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(color: Colors.black),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                         height: AppHeight(30),
//                                         decoration: BoxDecoration(
//                                           color: context
//                                               .resources.color.themeColor,
//                                           border: const Border(
//                                             bottom: BorderSide(
//                                                 width: 1.0,
//                                                 color: Colors.black),
//                                           ),
//                                         ),
//                                         child: CommonInkWell(
//                                           onTap: () {},
//                                           child: Row(
//                                             children: [
//                                               const MyHeaderData(
//                                                 title: 'Sr. No.',
//                                                 flex: 20,
//                                               ),
//                                               const RightBorder(),
//                                               const MyHeaderData(
//                                                 title: 'Type',
//                                                 flex: 35,
//                                               ),
//                                               const RightBorder(),
//                                               const MyHeaderData(
//                                                 title: 'Document Title',
//                                                 flex: 35,
//                                               ),
//                                               const RightBorder(),
//                                               Expanded(
//                                                   flex: 10,
//                                                   child: deleteIndex == index
//                                                       ? Container(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .all(2.5),
//                                                           alignment:
//                                                               Alignment.center,
//                                                           child:
//                                                               const CircularProgressIndicator(
//                                                             color: Colors.white,
//                                                           ),
//                                                         )
//                                                       : PopupMenuButton<int>(
//                                                           padding:
//                                                               EdgeInsets.zero,
//                                                           icon: const Icon(
//                                                             Icons
//                                                                 .more_vert_rounded,
//                                                             color: Colors.white,
//                                                           ),
//                                                           onSelected: (int
//                                                               value) async {
//                                                             if (value == 1) {
//                                                               Uri url = Uri.parse(
//                                                                   viewData!
//                                                                       .attachmentLst![
//                                                                           index]
//                                                                       .filePath!);
//                                                               if (!await launchUrl(
//                                                                   url)) {
//                                                                 throw Exception(
//                                                                     'Could not launch $url');
//                                                               }
//                                                             }
//                                                             if (value == 2) {
//                                                               // deleteAttachments(context, viewData!.attachmentLst![
//                                                               // index].attachedId.toString(),index);
//                                                               if (widget
//                                                                   .isUpload) {
//                                                                 AppUtils
//                                                                     .yesNoDialog(
//                                                                   context,
//                                                                   'Delete',
//                                                                   'Are You Sure ?',
//                                                                   onYes: () {
//                                                                     deleteAttachments(
//                                                                         context,
//                                                                         viewData!
//                                                                             .attachmentLst![index]
//                                                                             .attachedId
//                                                                             .toString(),
//                                                                         index);
//                                                                   },
//                                                                 );
//                                                               } else {
//                                                                 AppUtils.showToastRedBg(
//                                                                     context,
//                                                                     'Cannot delete in view mode');
//                                                               }
//                                                             }
//                                                           },
//                                                           itemBuilder:
//                                                               (BuildContext
//                                                                       context) =>
//                                                                   <PopupMenuEntry<
//                                                                       int>>[
//                                                             PopupMenuItem<int>(
//                                                               value: 1,
//                                                               padding: EdgeInsets
//                                                                   .only(
//                                                                       left: AppWidth(
//                                                                           5)),
//                                                               child: Row(
//                                                                 children: [
//                                                                   Icon(
//                                                                     Icons
//                                                                         .remove_red_eye_outlined,
//                                                                     color:
//                                                                         themeColor,
//                                                                   ),
//                                                                   CommonTextView(
//                                                                     label:
//                                                                         'View',
//                                                                     padding: EdgeInsets.only(
//                                                                         left: AppWidth(
//                                                                             5)),
//                                                                   )
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                             PopupMenuItem<int>(
//                                                               value: 2,
//                                                               padding: EdgeInsets
//                                                                   .only(
//                                                                       left: AppWidth(
//                                                                           5)),
//                                                               child: Row(
//                                                                 mainAxisSize:
//                                                                     MainAxisSize
//                                                                         .min,
//                                                                 children: [
//                                                                   Icon(
//                                                                     Icons
//                                                                         .delete,
//                                                                     color:
//                                                                         themeColor,
//                                                                   ),
//                                                                   CommonTextView(
//                                                                     label:
//                                                                         'Delete',
//                                                                     padding: EdgeInsets.only(
//                                                                         left: AppWidth(
//                                                                             5)),
//                                                                   )
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         )),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: AppHeight(30),
//                                         child: Row(
//                                           children: [
//                                             MyHeaderData(
//                                               title: '${index + 1}',
//                                               textColor: Colors.black,
//                                               flex: 20,
//                                             ),
//                                             const RightBorder(),
//                                             MyHeaderData(
//                                                 title: viewData!
//                                                     .attachmentLst![index]
//                                                     .docType!,
//                                                 textColor: Colors.black,
//                                                 flex: 35,
//                                                 onTap: () {}),
//                                             const RightBorder(),
//                                             MyHeaderData(
//                                               title: viewData!
//                                                   .attachmentLst![index]
//                                                   .docTitle!,
//                                               textColor: Colors.black,
//                                               flex: 45,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               }),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   void showBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         // Color themeColor = context.resources.color.themeColor;
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             if (chartData.chartList[currentIndex].anyDataPath!.isNotEmpty)
//               ListTile(
//                 leading: const Icon(
//                   Icons.remove_red_eye,
//                   size: 30,
//                 ),
//                 title: CommonTextView(
//                   label: 'View',
//                   fontSize: context.resources.dimension.appBigText + 3,
//                   fontFamily: 'Bold',
//                 ),
//                 onTap: () {
//                   AppUtils.showLocalImage(
//                       context, chartData.chartList[currentIndex].anyDataPath!);
//                 },
//               ),
//             ListTile(
//               leading: const Icon(
//                 Icons.camera,
//                 size: 30,
//               ),
//               title: CommonTextView(
//                 label: 'Camera',
//                 fontSize: context.resources.dimension.appBigText + 3,
//                 fontFamily: 'Bold',
//               ),
//               onTap: () {
//                 getImage(ImageSource.camera);
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(
//                 Icons.photo,
//                 size: 30,
//               ),
//               title: CommonTextView(
//                 label: 'Gallery',
//                 fontSize: context.resources.dimension.appBigText + 3,
//                 fontFamily: 'Bold',
//               ),
//               onTap: () {
//                 getImage(ImageSource.gallery);
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(
//                 Icons.insert_drive_file,
//                 size: 30,
//               ),
//               title: CommonTextView(
//                 label: 'All Files',
//                 fontSize: context.resources.dimension.appBigText + 3,
//                 fontFamily: 'Bold',
//               ),
//               onTap: () {
//                 //File picker
//                 FilePicker.platform.pickFiles().then((value) {
//                   if (value != null) {
//                     //file path
//                     setState(() {
//                       chartData.chartList[currentIndex].anyDataPath =
//                           value.files.single.path!;
//                     });
//                   } else {
//                     AppUtils.showToastRedBg(context, 'No Item Selected');
//                   }
//                 }).onError((error, stackTrace) {
//                   AppUtils.showToastRedBg(context, 'error:$error');
//                 }).whenComplete(() {
//                   Navigator.pop(context);
//                 });
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void getImage(ImageSource source) {
//     final picker = ImagePicker();
//     //getImage
//     picker.pickImage(source: source).then((value) {
//       if (value != null) {
//         //image path
//         chartData.chartList[currentIndex].anyDataPath = value.path;
//       } else {
//         AppUtils.showToastRedBg(context, 'No Item Selected');
//       }
//     }).onError((error, stackTrace) {
//       AppUtils.showToastRedBg(context, 'error:$error');
//     }).whenComplete(() => setState(() {}));
//   }
// }
