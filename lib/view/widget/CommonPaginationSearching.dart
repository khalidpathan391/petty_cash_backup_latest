// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:petty_cash/data/models/common/common_searching_model.dart';
import 'package:petty_cash/data/repository/general_rep.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/bottom_navigation_pages/HomePage.dart';
import 'package:petty_cash/view/widget/common_shimmer_view.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/custom_refresher.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';
import 'package:petty_cash/view/widget/listview_over_widget.dart';

class PaginationSearching extends StatefulWidget {
  static const String id = "pagination_searching";
  final String url;
  final String searchType;
  final String txnType;
  final String searchKeyWord;
  final bool isItem;
  final String leaveStartDate;
  final String leaveEndDate;
  final bool isMenuId;
  final String? chargeTypeId;
  final String? refTxntype;
  final String? refId;
  final String? empId;
  final String? divisionId;
  final bool showId;
  final String? ID;
  final String? headerId;
  final String title;
  final String? lookupCode;
  final String? supplierId;

  const PaginationSearching({
    super.key,
    required this.url,
    required this.searchType,
    required this.txnType,
    required this.searchKeyWord,
    this.isItem = false,
    this.leaveStartDate = '',
    this.leaveEndDate = '',
    this.isMenuId = false,
    this.chargeTypeId,
    this.refTxntype,
    this.refId,
    this.empId,
    this.showId = false,
    this.divisionId,
    this.ID,
    this.headerId,
    this.title = 'Common Searching',
    this.lookupCode,
    this.supplierId,
  });

  @override
  PaginationSearchingState createState() =>
      PaginationSearchingState(searchKeyWord);
}

//Searching issue check api or my side

class PaginationSearchingState extends State<PaginationSearching> {
  String search;
  //
  PaginationSearchingState(this.search);

  // void _toggleButtonWidth() {}

  final PagingController<int, SearchList> _pagingController =
      PagingController(firstPageKey: 0);
  final _myRepo = GeneralRepository();

  int pageIndex = 0;

  @override
  void initState() {
    showTextField = false;
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage();
    });
    super.initState();
  }

  Map getData() {
    Map data = {
      'user_id': Global.empData!.userId.toString(),
      'company_id': Global.empData!.companyId.toString(),
      'search_keyword': search,
      'search_type': widget.searchType,
      'code': widget.searchType,
      'txn_type': widget.txnType,
      'next_page_no': pageIndex.toString(),
      'lv_start_dt': widget.leaveStartDate,
      'lv_end_dt': widget.leaveEndDate,
      'menu_id': widget.isMenuId ? Global.menuData!.id.toString() : '',
      'charge_type': widget.chargeTypeId ?? '',
      'ref_txn_type': widget.refTxntype ?? '',
      'ref_id': widget.refId ?? '',
      'emp_id': widget.empId ?? '',
      'division_id': widget.divisionId ?? '',
      'id': widget.ID ?? '',
      'header_id': widget.headerId ?? '',
      'search_val': search,
      'lookup_code': widget.lookupCode ?? '',
      'supplier_id': widget.supplierId ?? '',
    };
    return data;
  }

  bool isNeedPullToRefresh = false;

  Future<void> _fetchPage() async {
    _myRepo.postApi(widget.url, getData()).then((value) {
      HseSorCommonSearchingModel data =
          HseSorCommonSearchingModel.fromJson(value);
      if (data.errorCode == 200) {
        if (AppUtils.errorMessage.isEmpty) {
          if (data.data!.searchList!.length < 15) {
            _pagingController.appendLastPage(data.data!.searchList!);
          } else {
            if (_pagingController.itemList != null &&
                (_pagingController.itemList!.length ==
                    data.data!.totalRecords)) {
              _pagingController.appendLastPage(data.data!.searchList!);
            } else {
              _pagingController.appendPage(data.data!.searchList!, pageIndex);
              pageIndex++;
            }
          }
        }
      } else {
        _pagingController.error = data.errorDescription.toString();
        AppUtils.errorMessage = data.errorDescription.toString();
        // AppUtils.showToastRedBg(context, data.errorDescription.toString());
      }
    }).onError((error, stackTrace) {
      if (AppUtils.errorMessage.isEmpty) {
        // AppUtils.errorMessage = error.toString();
      }
      _pagingController.error = error;
    }).whenComplete(() {
      isNeedPullToRefresh = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  TextEditingController controller = TextEditingController();
  bool showTextField = false;

  @override
  Widget build(BuildContext context) {
    Color themeColor = context.resources.color.themeColor;
    return PopScope(
      canPop: true,
      onPopInvoked: (canPop) {
        AppUtils.errorMessage = '';
        if (canPop) {
          return;
        }
      },
      child: Scaffold(
        backgroundColor: context.resources.color.colorWhite,
        appBar: AppBar(
          backgroundColor: context.resources.color.themeColor,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: showTextField
              ? CommonTextFormField(
                  label: 'Search Here...',
                  controller: controller,
                  textColor: Colors.white,
                  cursorColor: Colors.white,
                  hintColor: Colors.grey,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (val) {
                    if (val.isEmpty) {
                      AppUtils.showToastRedBg(
                          context, 'Search Cannot be Empty!');
                    } else {
                      search = controller
                          .text; //val can also be used as its the string val
                      pageIndex = 0; //always when searching
                      _pagingController.refresh();
                    }
                  },
                  onChanged: (val) {
                    if (val.isEmpty) {
                      search = controller.text;
                      pageIndex = 0; //always when searching
                      _pagingController.refresh();
                    }
                  },
                )
              : CommonTextView(
                  label: widget.title,
                  color: Colors.white,
                  fontSize: context.resources.dimension.appBigText + 4,
                ),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context, null);
              },
              child: const Icon(Icons.arrow_back_ios_new_rounded)),
          actions: [
            if (showTextField)
              IconButton(
                onPressed: () {
                  if (controller.text.isEmpty) {
                    AppUtils.showToastRedBg(context, 'Search Cannot be Empty!');
                  } else {
                    search = controller.text;
                    pageIndex = 0; //always when searching
                    _pagingController.refresh();
                  }
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            IconButton(
              onPressed: () {
                if (showTextField) {
                  showTextField = false;
                  controller.text = '';
                  setState(() {});
                  if (search.isNotEmpty) {
                    search = '';
                    pageIndex = 0; //always when searching
                    _pagingController.refresh();
                  }
                } else {
                  showTextField = true;
                  setState(() {});
                }
              },
              icon: Icon(
                showTextField ? Icons.close : Icons.search,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
        body: Center(
          child: RefreshIndicator(
            onRefresh: () async {
              pageIndex = 0;
              isNeedPullToRefresh = true;
              setState(() {});
              _pagingController.refresh();
            },
            edgeOffset: -300,
            child: isNeedPullToRefresh
                ? const CustomRefresher()
                : PagedListView<int, SearchList>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate(
                      animateTransitions: true,
                      transitionDuration: const Duration(microseconds: 500),
                      firstPageProgressIndicatorBuilder: (_) =>
                          const CommonShimmerView(
                        numberOfRow: 15,
                        shimmerViewType: ShimmerViewType.COMMON_SEARCH,
                      ),
                      firstPageErrorIndicatorBuilder: (_) => Center(
                          child: AppUtils(context).getCommonErrorWidget(() {
                        _pagingController.retryLastFailedRequest();
                      }, AppUtils.errorMessage)),
                      newPageProgressIndicatorBuilder: (_) =>
                          const CommonShimmerView(
                        numberOfRow: 15,
                        shimmerViewType: ShimmerViewType.COMMON_SEARCH,
                      ),
                      newPageErrorIndicatorBuilder: (_) => Center(
                        child: AppUtils(context).getCommonErrorWidget(
                          () {
                            _pagingController.retryLastFailedRequest();
                          },
                          AppUtils.errorMessage,
                        ),
                      ),
                      noItemsFoundIndicatorBuilder: (_) => EmptyListWidget(
                        onTap: () {
                          _pagingController.refresh();
                        },
                      ),
                      noMoreItemsIndicatorBuilder: (_) => ListOverWidget(
                        themeColor: themeColor,
                      ),
                      itemBuilder: (context, item, index) {
                        return GestureDetector(
                          onTap: () {
                            // Handle the pop logic based on conditions
                            if (widget.isItem) {
                              Navigator.pop(context, item);
                            } else {
                              if (widget.searchType == 'EMPLOYEE') {
                                Navigator.pop(context, [
                                  item.userId,
                                  item.code.toString(),
                                  item.desc.toString(),
                                ]);
                              } else {
                                Navigator.pop(context, [
                                  item.id,
                                  item.code.toString(),
                                  item.desc.toString(),
                                ]);
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppWidth(10),
                              vertical: AppHeight(5),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  bottom: BorderSide(
                                color: themeColor
                                    .withOpacity(.3), // Custom border color
                                width: 1,
                              )),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.code.toString().isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 2.0),
                                    child: Text(
                                      'Code: ${item.code.toString()}',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(.8),
                                      ),
                                    ),
                                  ),
                                if (item.desc.toString().isNotEmpty &&
                                    !widget.showId)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    child: Text(
                                      'Description: ${item.desc.toString()}',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black.withOpacity(.5),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                        /*CommonTextView(
                          label: widget.showId ?
                          item.code.toString(): item.code.toString().isEmpty ?
                          item.desc.toString() : item.desc.toString().isEmpty ?
                          item.code.toString() : '${item.code.toString()}-${item.desc.toString()}',
                          onTap: () {
                            //already used this in many places so for new transaction send isItem true to get the whole line as item
                            if (widget.isItem) {
                              Navigator.pop(context, item);
                            } else {
                              if (widget.searchType == 'EMPLOYEE') {
                                Navigator.pop(context, [
                                  item.userId,
                                  item.code.toString(),
                                  item.desc.toString()
                                ]);
                              } else {
                                Navigator.pop(context, [
                                  item.id,
                                  item.code.toString(),
                                  item.desc.toString()
                                ]);
                              }
                            }
                          },
                          maxLine: 3,
                          overFlow: TextOverflow.ellipsis,
                          margin: EdgeInsets.symmetric(
                              horizontal: AppWidth(5), vertical: AppHeight(5)),
                          padding: EdgeInsets.symmetric(
                              horizontal: AppWidth(2.5), vertical: AppHeight(5)),
                          myDecoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                        );*/
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
