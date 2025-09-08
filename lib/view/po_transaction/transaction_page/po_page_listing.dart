// ignore_for_file: no_logic_in_create_state, unused_import, camel_case_types, unused_local_variable, library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:petty_cash/data/models/po_model.dart/po_listing_model.dart';
import 'package:petty_cash/data/repository/general_rep.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';

class CommonPaginationSearching extends StatefulWidget {
  static const String id = "common_pagination";
  final String url;
  final String lookupCode;

  const CommonPaginationSearching({
    super.key,
    required this.url,
    required this.lookupCode,
  });

  @override
  _CommonPaginationSearchingState createState() =>
      _CommonPaginationSearchingState();
}

class _CommonPaginationSearchingState extends State<CommonPaginationSearching> {
  final PagingController<int, SearchList> _pagingController =
      PagingController(firstPageKey: 0);

  final _myRepo = GeneralRepository();
  final TextEditingController _searchController = TextEditingController();

  String _searchKeyword = '';
  int nextPageVal = 0;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final Map<String, String> requestData = {
        'user_id': Global.empData!.userId.toString(),
        'company_id': Global.empData!.companyId.toString(),
        'page_no': pageKey.toString(),
        'search_keyword': _searchKeyword,
      };

      final response = await _myRepo.postApi(widget.url, requestData);

      final PoListingModel data = PoListingModel.fromJson(response);

      if (data.errorCode == 200 && data.data != null) {
        final newItems = data.data!.searchList ?? [];
        final isLastPage = newItems.length < 15;

        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          nextPageVal = pageKey + 1;
          _pagingController.appendPage(newItems, nextPageVal);
        }
      } else {
        _pagingController.error = data.errorDescription ?? 'Unknown error';
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = context.resources.color.themeColor;

    return Scaffold(
      backgroundColor: context.resources.color.colorWhite,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const CommonTextView(
          label: 'Common Search',
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          CommonTextFormField(
            controller: _searchController,
            margin:
                const EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 10),
            label: 'Search here...',
            textInputAction: TextInputAction.search,
            prefixWidget: GestureDetector(
              onTap: () {
                setState(() {
                  _searchController.clear();
                  _searchKeyword = '';
                });
              },
              child: Icon(
                Icons.close,
                color: themeColor,
                size: 30,
              ),
            ),
            suffixWidget: GestureDetector(
              onTap: () {
                setState(() {
                  _searchKeyword = _searchController.text;
                  nextPageVal = 0;
                  _pagingController.refresh();
                });
              },
              child: Icon(
                Icons.search,
                color: themeColor,
                size: 30,
              ),
            ),
            onFieldSubmitted: (value) {
              setState(() {
                _searchKeyword = value;
                nextPageVal = 0;
                _pagingController.refresh();
              });
            },
            onChanged: (value) {
              setState(() {
                _searchKeyword = value;
              });
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _pagingController.refresh();
              },
              child: PagedListView<int, SearchList>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<SearchList>(
                  animateTransitions: true,
                  transitionDuration: const Duration(milliseconds: 300),
                  firstPageProgressIndicatorBuilder: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  newPageProgressIndicatorBuilder: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  firstPageErrorIndicatorBuilder: (_) => Center(
                    child: CommonTextView(
                        label: 'Error loading data. Please try again.'.tr()),
                  ),
                  newPageErrorIndicatorBuilder: (_) => Center(
                    child:
                        CommonTextView(label: 'Error loading more data.'.tr()),
                  ),
                  noItemsFoundIndicatorBuilder: (_) => Center(
                    child: CommonTextView(label: 'No items found.'.tr()),
                  ),
                  noMoreItemsIndicatorBuilder: (_) => Center(
                    child: CommonTextView(label: 'No more items.'.tr()),
                  ),
                  itemBuilder: (context, item, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, item);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 12.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonTextView(
                                        label: item.txnCode ?? '',
                                        fontWeight: FontWeight.bold,
                                        margin: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        fontSize: context.resources.dimension
                                                .appBigText -
                                            2,
                                      ),
                                      CommonTextView(
                                        label: item.reference ?? '',
                                        margin:
                                            const EdgeInsets.only(left: 5.0),
                                        fontSize: 12,
                                        maxLine: 1,
                                        overFlow: TextOverflow.ellipsis,
                                      ),
                                      CommonTextView(
                                        label: item.status ?? '',
                                        margin:
                                            const EdgeInsets.only(left: 5.0),
                                        fontSize: 12,
                                        maxLine: 1,
                                        overFlow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Divider(),
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
        ],
      ),
    );
  }
}
