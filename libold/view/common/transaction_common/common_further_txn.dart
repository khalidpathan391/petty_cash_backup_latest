// import 'package:crebri_erp_app/globalSize.dart';
// import 'package:crebri_erp_app/models/CommonModels/common_furthur_txn_model.dart';
// import 'package:crebri_erp_app/res/AppContextExtension.dart';
// import 'package:crebri_erp_app/view/widget/common_empty_list.dart';
// import 'package:crebri_erp_app/view/widget/custom_view_table.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';


// class FTCommon extends StatefulWidget {
//   final List<FurtherTrx> listData;
//   final List<MoreBtnLst> moreList;
//   final Function(int) openPage;
//   final Function(int)? onPageLongPress;
//   final Function(int) onItemTap;
//   const FTCommon({
//     super.key,
//     required this.listData,
//     required this.moreList,
//     required this.openPage,
//     this.onPageLongPress,
//     required this.onItemTap,
//   });

//   @override
//   State<FTCommon> createState() => FTCommonState();
// }

// class FTCommonState extends State<FTCommon> {
//   late List<dynamic> listData1;
//   @override
//   void initState() {
//     listData1 = widget.listData;
//     super.initState();
//   }


//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           if(widget.moreList.isNotEmpty)Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               IconButton(
//                 onPressed: ()=>showBottomSheet(context,widget.moreList),
//                 icon: const Icon(Icons.more),
//               ),
//             ],
//           ),
//           listData1.isEmpty ? Padding(
//             padding:  EdgeInsets.symmetric(vertical: AppHeight(120)),
//             child: const CommonEmptyList(),
//           ) :
//           SingleChildScrollView(
//             child: CustomViewOnlyTable(
//               data: listData1,
//               isScrollable: false,
//               header1: 'Txn Code',
//               header2: 'Doc. No.',
//               onOpen: (index){
//                 listData1[index].isOpen = !listData1[index].isOpen;
//                 setState(() {});
//               },
//               getHeader1: (data) => data.txnCode,
//               getHeader2: (data) => data.txnNo,
//               header2Search: (index)=>widget.openPage(index),
//               header2LongPress: (index)=>widget.onPageLongPress?.call(index),
//               header2TextColor:context.resources.color.themeColor,
//               header2Decoration: const BoxDecoration(color: Colors.white,),
//               row1Title: 'Created by',
//               row1Label: (data) => data.txnCrUser,
//               isRow2: true,
//               row2Title: 'Created Date',
//               row2Label: (data)=>data.txnCrDt,
//               isRow3: true,
//               row3Title: 'Status',
//               row3Label: (data)=>data.txnStatus,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void showBottomSheet(BuildContext context, List<MoreBtnLst> moreList1) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter myState) {
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Draggable area on top
//                     InkWell(
//                       onTap: ()=>Navigator.pop(context),
//                       child: Container(
//                         width: 40,
//                         height: 5,
//                         margin: const EdgeInsets.only(bottom: 16.0),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                     // Parent List with Expand/Collapse feature
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: moreList1.length,
//                       itemBuilder: (context, index) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ListTile(
//                               leading: buildImage(moreList1[index].icon ?? ''),
//                               title: Text(moreList1[index].name ?? ''),
//                               trailing: Icon(
//                                 moreList1[index].innerLst != null ?
//                                 (moreList1[index].innerLst!.isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
//                                     : null,
//                                 size: 16,
//                               ),
//                               onTap: () {
//                                 if (moreList1[index].innerLst != null) {
//                                   myState(() {
//                                     moreList1[index].innerLst!.isOpen = !moreList1[index].innerLst!.isOpen;
//                                   });
//                                 }
//                               },
//                             ),
//                             if (moreList1[index].innerLst!.isOpen)
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                 child: ListTile(
//                                   leading: buildImage(moreList1[index].innerLst!.icon ?? ''),
//                                   title: Text(moreList1[index].innerLst!.name ?? ''),
//                                   onTap: ()=>widget.onItemTap(index),
//                                 ),
//                               ),
//                           ],
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget buildImage(String? url) {
//     if (url == null || url.isEmpty) {
//       return const SizedBox(); // Return empty widget if no URL
//     }

//     if (url.endsWith('.svg')) {
//       return SvgPicture.network(
//         url,
//         height: 20,
//         width: 20,
//         placeholderBuilder: (context) => const CircularProgressIndicator(),  // Show a placeholder while loading
//       );
//     } else {
//       return Image.network(
//         url,
//         height: 20,
//         width: 20,
//         errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),  // Show error icon if image fails
//       );
//     }
//   }


// }

