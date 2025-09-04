
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:petty_cash/data/models/po_model.dart/po_listing_model.dart';
// import 'package:petty_cash/data/repository/general_rep.dart';
// import 'package:petty_cash/global.dart';
// import 'package:petty_cash/resources/api_url.dart';
// import 'package:petty_cash/resources/app_extension_context.dart';
// import 'package:petty_cash/utils/app_utils.dart';
// import 'package:petty_cash/view/bottom_navigation_pages/HomePage.dart';
// import 'package:petty_cash/view/bottom_navigation_pages/Profile_Settings_Pages/my_account_page.dart';
// import 'package:petty_cash/view/common_annotated_region.dart';
// import 'package:petty_cash/view/widget/CommonInkWell.dart';
// import 'package:petty_cash/view/widget/CustomAppBar.dart';
// import 'package:petty_cash/view/widget/common_shimmer_view.dart';
// import 'package:petty_cash/view/widget/common_text.dart';
// import 'package:petty_cash/view/widget/custom_refresher.dart';

// class CommonListingPage extends StatefulWidget {
//   static const String id = "common_listing";

//   const CommonListingPage({super.key});

//   @override
//   CommonListingPageState createState() => CommonListingPageState();
// }

// class CommonListingPageState extends State<CommonListingPage> {
//   final PagingController<int, QueryList> _pagingController =
//       PagingController(firstPageKey: 0);
//   final _myRepo = GeneralRepository();

//   String? txnType;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     txnType = ModalRoute.of(context)!.settings.arguments as String?;
//     _pagingController.addPageRequestListener((pageKey) {
//       _fetchPage();
//     });
//   }

//   @override
//   void initState() {
//     // _pagingController.addPageRequestListener((pageKey) {
//     //   _fetchPage();
//     // });
//     super.initState();
//     controller.text = '';
//   }

//   Map getData() {
//     Map data = {
//       'user_id': Global.empData!.userId.toString(),
//       'company_id': Global.empData!.companyId.toString(),
//       'menu_id': Global.menuData!.id.toString(),
//       'search_keyword': controller.text.toString(),
//       'page_no': pageIndex.toString(),
//       'filter_type_code': Global.menuData!.filterTypeCode,
//       'filter_type_val': Global.menuData!.filterTypeVal,
//     };
//     return data;
//   }

//   bool isNeedPullToRefresh = false;
//   int pageIndex = 1;
//   PoListingModel? mainListingData;
//   bool isApiHit = false;

//   void _fetchPage() {
//     if (isApiHit) {
//       return;
//     }
//     isApiHit = true;
//     _myRepo
//         .postApi(ApiUrl.baseUrl! + ApiUrl.getCommonListing, getData())
//         .then((value) {
//       mainListingData = PoListingModel.fromJson(value);
//       if (mainListingData!.errorCode == 200) {
//         if (AppUtils.errorMessage.isEmpty) {
//           if (mainListingData!.listing!.queryList!.length < 15) {
//             _pagingController
//                 .appendLastPage(mainListingData!.listing!.queryList!);
//           } else {
//             if (_pagingController.itemList != null &&
//                 (_pagingController.itemList!.length ==
//                     mainListingData!.listing!.noOfRecords)) {
//               _pagingController
//                   .appendLastPage(mainListingData!.listing!.queryList!);
//             } else {
//               _pagingController.appendPage(
//                   mainListingData!.listing!.queryList!, pageIndex);
//               pageIndex++;
//             }
//           }
//         }
//       } else {
//         AppUtils.showToastRedBg(
//             context, mainListingData!.errorDescription.toString());
//       }
//     }).onError((error, stackTrace) {
//       if (AppUtils.errorMessage.isEmpty) {
//         AppUtils.errorMessage = error.toString();
//       }
//       _pagingController.error = error.toString();
//     }).whenComplete(() {
//       isNeedPullToRefresh = false;
//       isApiHit = false;
//       setState(() {});
//     });
//   }

//   //searching
//   TextEditingController controller = TextEditingController();

//   @override
//   void dispose() {
//     _pagingController.dispose();
//     super.dispose();
//   }

//   void search(String data) {
//     if (data.isEmpty) {
//       FocusScope.of(context).unfocus();
//       pageIndex = 1;
//       _pagingController.refresh();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     //  data = ModalRoute.of(context)!.settings.arguments as Menu;
//     return CommonAnnotatedRegion(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: CustomAppBar(
//           onTap: () {
//             Navigator.pushNamed(context, MyAccount.id);
//           },
//           type: '${Global.menuData!.title}-${Global.menuData!.txnCode}',
//           typeIcon: Global.menuData!.menuIcon,
//           isTransaction: true,
//           isTransactionBack: true,
//           isAdd: true,
//           isSave: false,
//           isSubmit: false,
//           isList: false,
//           save: () {},
//           submitOrApproval: () {},
//           list: () {},
//           openNew: () {
          
//           },
//         ),
//         body: Center(
//           child: RefreshIndicator(
//             onRefresh: () async {
//               setState(() {
//                 pageIndex = 1;
//                 isNeedPullToRefresh = true;
//                 _pagingController.refresh();
//               });
//             },
//             edgeOffset: -300,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                           margin: const EdgeInsets.only(
//                               left: 10.0, right: 5.0, top: 10.0),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                                 width: 0.2,
//                                 color: context.resources.color.colorBlack),
//                             borderRadius: BorderRadius.circular(0),
//                           ),
//                           height: 31.0,
//                           width: MediaQuery.of(context).size.width,
//                           child: TextFormField(
//                             controller: controller,
//                             cursorColor: Colors.orange,
//                             onChanged: search,
//                             style: const TextStyle(
//                                 fontSize: 16.0,
//                                 fontFamily: 'Gilroy-Light',
//                                 color: Colors.black),
//                             decoration: InputDecoration(
//                                 isDense: true,
//                                 contentPadding:
//                                     EdgeInsets.only(left: 5.0, top: 2.0),
//                                 fillColor: const Color(0xaed8dbdb),
//                                 border: InputBorder.none,
//                                 hintText: 'Search here...',
//                                 hintStyle: const TextStyle(
//                                     fontSize: 16.0,
//                                     fontFamily: 'Regular',
//                                     color: Color(0xFAC6C5C5)),
//                                 counterStyle: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 16.0,
//                                     fontFamily: 'Regular'),
//                                 suffixIcon: IconButton(
//                                   icon: Icon(
//                                     Icons.search,
//                                     color: context.resources.color.themeColor,
//                                   ),
//                                   onPressed: () {
//                                     if (controller.text.toString().isNotEmpty) {
//                                       FocusScope.of(context).unfocus();
//                                       pageIndex = 1;
//                                       _pagingController.refresh();
//                                     } else {
//                                       AppUtils.showToastRedBg(context,
//                                           "Please enter search keyword");
//                                     }
//                                   },
//                                 )),
//                             textInputAction: TextInputAction.search,
//                             onFieldSubmitted: (_) {
//                               if (controller.text.toString().isNotEmpty) {
//                                 pageIndex = 1;
//                                 _pagingController.refresh();
//                               } else {
//                                 AppUtils.showToastRedBg(
//                                     context, "Please enter search keyword");
//                               }
//                             },
//                           )),
//                     ),
//                     Container(
//                         margin: const EdgeInsets.only(
//                             left: 3.0, right: 5.0, top: 10.0),
//                         height: 30.0,
//                         padding: const EdgeInsets.all(7.5),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                               width: 0.2,
//                               color: context.resources.color.colorBlack),
//                           borderRadius: BorderRadius.circular(0),
//                         ),
//                         child: SvgPicture.asset(
//                           'assets/images/erp_app_icon/settings.svg',
//                           height: 20,
//                           width: 20,
//                           color: context.resources.color.themeColor,
//                         )),
//                     CommonInkWell(
//                       onTap: () {
//                         pageIndex = 1;
//                         isNeedPullToRefresh = true;
//                         _pagingController.refresh();
//                       },
//                       child: Container(
//                           margin: const EdgeInsets.only(
//                               left: 2.0, right: 10.0, top: 10.0),
//                           height: 30.0,
//                           padding: const EdgeInsets.all(7.5),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                                 width: 0.2,
//                                 color: context.resources.color.colorBlack),
//                             borderRadius: BorderRadius.circular(0),
//                           ),
//                           child: SvgPicture.asset(
//                             'assets/images/erp_app_icon/refresh.svg',
//                             height: 20,
//                             width: 20,
//                             color: context.resources.color.themeColor,
//                           )),
//                     ),
//                   ],
//                 ),
//                 Container(
//                     width: MediaQuery.of(context).size.width,
//                     margin: const EdgeInsets.only(top: 10.0),
//                     color: Colors.grey.withOpacity(0.2),
//                     padding: const EdgeInsets.all(10.0),
//                     child: CommonTextView(
//                         label:
//                             "Total Records: ${mainListingData != null ? mainListingData!.listing!.noOfRecords : ''}")),
//                 isNeedPullToRefresh
//                     ? const CustomRefresher()
//                     : Expanded(
//                         flex: 1,
//                         child: PagedListView<int, QueryList>(
//                           pagingController: _pagingController,
//                           builderDelegate: PagedChildBuilderDelegate<QueryList>(
//                             animateTransitions: true,
//                             transitionDuration:
//                                 const Duration(microseconds: 500),
//                             firstPageProgressIndicatorBuilder: (_) =>
//                                 const CommonShimmerView(
//                                     numberOfRow: 15,
//                                     shimmerViewType:
//                                         ShimmerViewType.COMMON_LIST),
//                             firstPageErrorIndicatorBuilder: (_) => Center(
//                                 child:
//                                     AppUtils(context).getCommonErrorWidget(() {
//                               _pagingController.retryLastFailedRequest();
//                             }, 'Error Loading Data')),
//                             newPageProgressIndicatorBuilder: (_) =>
//                                 const CommonShimmerView(
//                                     numberOfRow: 15,
//                                     shimmerViewType:
//                                         ShimmerViewType.COMMON_LIST),
//                             newPageErrorIndicatorBuilder: (_) => Center(
//                                 child:
//                                     AppUtils(context).getCommonErrorWidget(() {
//                               _pagingController.retryLastFailedRequest();
//                             }, 'Error Loading More Data')),
//                             noItemsFoundIndicatorBuilder: (_) =>
//                                 EmptyListWidget(
//                               onTap: () {
//                                 _pagingController.refresh();
//                               },
//                             ),
//                             noMoreItemsIndicatorBuilder: (_) => const Center(
//                               child: CommonTextView(
//                                 label: 'List over',
//                               ),
//                             ),
//                             itemBuilder: (context, item, index) {
//                               return CommonInkWell(
//                                 onTap: () {
//                                   //for common header attachments
//                                   //Video
//                                   for (int i = 0;
//                                       i < Global.allVideoData.length;
//                                       i++) {
//                                     //disposing all the videoControllers
//                                     Global.allVideoData[i].videoController!
//                                         .dispose();
//                                   }
//                                   Global.allVideoData.clear();
//                                   Global.commonSearchType =
//                                       SearchListType.defaultType;
//                                   try {
//                                     if (Global.menuData!.pageTypeCode
//                                             .toString()
//                                             .toLowerCase() ==
//                                         'lis') {
//                                       Navigator.pushNamed(
//                                               context, GLUnpostedTransaction.id,
//                                               arguments: int.parse(
//                                                   item.key1.toString()))
//                                           .then((value) {});
//                                     } else {
//                                       Navigator.pushNamed(
//                                               context, Global.menuData!.txnCode,
//                                               arguments: int.parse(
//                                                   item.key1.toString()))
//                                           .then((value) {});
//                                     }
//                                   } catch (e) {
//                                     AppUtils.showToastRedBg(context,
//                                         "Page Not Found For This Txn Type ${Global.menuData!.txnCode}");
//                                   }
//                                 },
//                                 child: Stack(
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         border: Border(
//                                           bottom: BorderSide(
//                                               color: context
//                                                   .resources.color.themeColor
//                                                   .withOpacity(0.1),
//                                               width: 1.5),
//                                         ),
//                                       ),
//                                       padding: const EdgeInsets.all(8.0),
//                                       margin: EdgeInsets.only(
//                                           top: (index == 0) ? 10.0 : 0),
//                                       width: MediaQuery.of(context).size.width,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Expanded(
//                                                   flex: 1,
//                                                   child: CommonTextView(
//                                                     label:
//                                                         "${item.key2}-${item.key3}",
//                                                     fontSize: 14.0,
//                                                     color: context.resources
//                                                         .color.themeColor,
//                                                   )),
//                                               Expanded(
//                                                   flex: 1,
//                                                   child: Align(
//                                                       alignment:
//                                                           Alignment.topRight,
//                                                       child: CommonTextView(
//                                                           label: "${item.key4}",
//                                                           fontSize: 14.0))),
//                                             ],
//                                           ),
//                                           const SizedBox(
//                                             height: 2,
//                                           ),
//                                           CommonTextView(
//                                               label: "${item.key9}",
//                                               fontSize: 12.0),
//                                           const SizedBox(
//                                             height: 2,
//                                           ),
//                                           Row(
//                                             children: [
//                                               Expanded(
//                                                   flex: 2,
//                                                   child: CommonTextView(
//                                                       label:
//                                                           "${item.key5}-${item.key6}",
//                                                       fontSize: 14.0)),
//                                               Expanded(
//                                                   flex: 1,
//                                                   child: Align(
//                                                       alignment:
//                                                           Alignment.topRight,
//                                                       child: CommonTextView(
//                                                           label: "${item.key8}",
//                                                           fontSize: 14.0))),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                         width: 15.0,
//                                         height: 15.0,
//                                         margin:
//                                             const EdgeInsets.only(left: 2.0),
//                                         transform: Matrix4.translationValues(
//                                             0.0,
//                                             (index != 0) ? -8.0 : 0.00,
//                                             0.0),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: context
//                                               .resources.color.themeColor,
//                                         ),
//                                         child: Center(
//                                             child: CommonTextView(
//                                           label: '${index + 1}',
//                                           fontSize: 5.0,
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         )))
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
