import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:petty_cash/data/models/common/common_searching_model.dart'
    as hse_sor;
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/widget/common_empty_list.dart';
import 'package:petty_cash/view/widget/common_text.dart';

import 'package:petty_cash/view_model/CommonProvider.dart';
import 'package:provider/provider.dart';

//Not used
class HsePaginationSearching extends StatefulWidget {
  static const String id = "hse_search_list";
  const HsePaginationSearching({super.key});

  @override
  State<HsePaginationSearching> createState() => _HsePaginationSearchingState();
}

class _HsePaginationSearchingState extends State<HsePaginationSearching> {
  @override
  void initState() {
    CommonVM();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.resources.color.themeColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: CommonTextView(
          label: 'Search'.tr(),
          color: Colors.white,
        ),
      ),
      body: Consumer<CommonVM>(
        builder: (context, provider, widget) {
          return PagedListView<int, hse_sor.SearchList>(
            pagingController: provider.pagingController
                as PagingController<int, hse_sor.SearchList>,
            builderDelegate: PagedChildBuilderDelegate
                // <NotificationLst>
                (
              animateTransitions: true,
              transitionDuration: const Duration(microseconds: 500),
              firstPageProgressIndicatorBuilder: (_) => Center(
                child: CircularProgressIndicator(
                  color: context.resources.color.themeColor,
                ),
              ),
              firstPageErrorIndicatorBuilder: (_) => Center(
                  child: AppUtils(context).getCommonErrorWidget(() {
                // provider.pagingController.retryLastFailedRequest();
              }, 'Error_Loading_Data'.tr())),
              newPageProgressIndicatorBuilder: (_) =>
                  // Text('Building'),
                  Center(
                child: CircularProgressIndicator(
                  color: context.resources.color.themeColor,
                ),
              ),
              newPageErrorIndicatorBuilder: (_) => Center(
                  child: AppUtils(context).getCommonErrorWidget(() {
                // provider.pagingController.retryLastFailedRequest();
              }, 'Error_Loading_More_Data'.tr())),
              noItemsFoundIndicatorBuilder: (_) => EmptyListWidget(
                onTap: () {
                  // provider.pagingController.refresh();
                },
              ),
              noMoreItemsIndicatorBuilder: (_) => const Center(
                child: CommonTextView(
                  label: 'List over',
                ),
              ),
              itemBuilder: (context, hse_sor.SearchList item, index) {
                return CommonTextView(
                  label: item.code.toString().isEmpty
                      ? item.desc.toString()
                      : item.desc.toString().isEmpty
                          ? item.code.toString()
                          : '${item.code.toString()}-${item.desc.toString()}',
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
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
