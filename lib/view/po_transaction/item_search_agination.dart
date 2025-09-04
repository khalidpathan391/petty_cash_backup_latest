// ignore_for_file: no_logic_in_create_state, camel_case_types

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:petty_cash/data/models/po_model.dart/item_details_model.dart';
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

class PoItemDetailsSeraching extends StatefulWidget {
  static const String id = "item_pagination_searching";
  final String url;
  final String searchType;
  final String txnType;
  final String searchKeyWord;

  final String? refTxntype;
  final String? actvityId;
  final String? categoryId;
  final bool isMenuId;
  final bool isAsset;
  final bool isUsedBy;
  final bool isItem;
  final String? supp_id;

  const PoItemDetailsSeraching({
    Key? key,
    required this.url,
    required this.searchType,
    required this.txnType,
    required this.searchKeyWord,
    this.refTxntype,
    this.isMenuId = false,
    this.isAsset = false,
    this.isUsedBy = false,
    this.actvityId,
    this.categoryId,
    this.isItem = false,
    this.supp_id,
  }) : super(key: key);

  @override
  WorkOrdeSrearchingState createState() =>
      WorkOrdeSrearchingState(searchKeyWord);
}

//Searching issue check api or my side

class WorkOrdeSrearchingState extends State<PoItemDetailsSeraching> {
  String search;
  //
  WorkOrdeSrearchingState(this.search);

  // void _toggleButtonWidth() {}

  final PagingController<int, SearchList> _pagingController =
      PagingController(firstPageKey: 0);
  final _myRepo = GeneralRepository();

  int pageIndex = 0;
  bool showTextField = false;

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
      'company_id': Global.empData!.companyId.toString(),
      'search_keyword': search,
      'search_type': widget.searchType,
      'txn_type': widget.txnType,
      'next_page_no': pageIndex.toString(),
      'ref_txn_type': widget.refTxntype ?? '',
      'activity_id': widget.actvityId ?? '',
      'category_id': widget.categoryId ?? '',
      'user_id': Global.empData!.userId.toString(),
      'mid': widget.isMenuId ? Global.menuData!.id.toString() : '',
      'supplier_id': widget.supp_id ?? '',
    };
    return data;
  }

  bool isNeedPullToRefresh = false;

  Future<void> _fetchPage() async {
    _myRepo.postApi(widget.url, getData()).then((value) {
      ItemDetailsModel data = ItemDetailsModel.fromJson(value);
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
        AppUtils.showToastRedBg(context, data.errorDescription.toString());
      }
    }).onError((error, stackTrace) {
      if (AppUtils.errorMessage.isEmpty) {
        // AppUtils.errorMessage = error.toString();
      }
      _pagingController.error = error;
    }).whenComplete(() {
      isNeedPullToRefresh = false;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color themeColor = context.resources.color.themeColor;
    return Scaffold(
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
                    AppUtils.showToastRedBg(context, 'Search Cannot be Empty!');
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
                label: 'Purchase Order Search',
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
              } else {
                showTextField = true;
              }
              setState(() {});
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
            setState(() {
              pageIndex = 0;
              isNeedPullToRefresh = true;
              _pagingController.refresh();
            });
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
                      numberOfRow: 20,
                      shimmerViewType: ShimmerViewType.COMMON_SEARCH,
                    ),
                    firstPageErrorIndicatorBuilder: (_) => Center(
                        child: AppUtils(context).getCommonErrorWidget(() {
                      _pagingController.retryLastFailedRequest();
                    }, 'Error Loading Data')),
                    newPageProgressIndicatorBuilder: (_) => const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: CommonShimmerView(
                          numberOfRow: 20,
                          shimmerViewType: ShimmerViewType.COMMON_SEARCH,
                        ),
                      ),
                    ),
                    newPageErrorIndicatorBuilder: (_) => Center(
                        child: AppUtils(context).getCommonErrorWidget(() {
                      _pagingController.retryLastFailedRequest();
                    }, 'Error Loading More Data')),
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
                        onTap: () => Navigator.pop(context, item),
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
                              if (item.itemCode.toString().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: Text(
                                    'Code: ${item.itemCode.toString()}',
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(.8),
                                    ),
                                  ),
                                ),
                              if (item.itemDescription.toString().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3.0),
                                  child: Text(
                                    'Description: ${item.itemDescription.toString()}',
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
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
