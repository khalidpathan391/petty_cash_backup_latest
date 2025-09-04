import 'package:flutter/material.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';
import 'package:petty_cash/view_model/HomePage/HomeVM.dart';
import 'package:provider/provider.dart';

class MultiFilterSearchList extends StatefulWidget {
  static const String id = "multi_filter_search_list_home";

  const MultiFilterSearchList({super.key});

  @override
  State<MultiFilterSearchList> createState() => _MultiFilterSearchListState();
}

class _MultiFilterSearchListState extends State<MultiFilterSearchList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVM>(builder: (context, provider, widget) {
      return Scaffold(
        appBar: AppBar(
          title: CommonTextView(
            label: 'Search',
            color: Colors.white,
            fontSize: context.resources.dimension.appBigText + 2,
            fontFamily: 'Bold',
          ),
          centerTitle: true,
        ),
        body: provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : AppUtils.errorMessage.isNotEmpty
                ? AppUtils(context).getCommonErrorWidget(() {
                    // provider.callSettingPriorityApi();
                  }, '')
                : Column(
                    children: [
                      CommonTextFormField(
                        label: 'Search here...',
                        margin: EdgeInsets.symmetric(
                            horizontal: AppWidth(10), vertical: AppHeight(10)),
                        prefixWidget: const Icon(Icons.search),
                        suffixWidget: InkWell(
                            onTap: () {
                              provider.setDefaultOnSearchPop();
                            },
                            child: const Icon(Icons.cancel_outlined)),
                        controller: provider.searchController,
                        // onChanged: provider.searchList,
                      ),
                      Container(
                        height: AppHeight(6),
                        margin: EdgeInsets.only(top: AppHeight(5)),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: context.resources.color.colorLightGrey,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: provider.filteredSearchList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (provider.searchListKey == 'Condition') {
                                  provider.setConditionType(
                                    provider
                                        .filteredSearchList[index].showvalue,
                                    provider.filteredSearchList[index].id,
                                    provider.filteredSearchList[index].code,
                                  );
                                }
                                if (provider.searchListKey == 'Txn') {
                                  // provider.addTxnType(provider.filteredSearchList[index].code,provider.filteredSearchList[index].id);
                                }
                                if (provider.searchListKey == 'User') {
                                  // provider.addUserType(provider.filteredSearchList[index].code,provider.filteredSearchList[index].id);
                                }
                                if (provider.searchListKey == 'Notification') {
                                  // provider.addNotificationType(
                                  //     provider.filteredSearchList[index].showval,
                                  //     provider.filteredSearchList[index].id,
                                  //   provider.filteredSearchList[index].description,
                                  // );
                                }
                                Navigator.pop(context);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonTextView(
                                    label: provider.searchListKey ==
                                                'Condition' ||
                                            provider.searchListKey == 'Txn'
                                        ? provider.filteredSearchList[index]
                                            .showvalue!
                                        : provider.searchListKey == 'User' ||
                                                provider.searchListKey ==
                                                    'Notification'
                                            ? provider.filteredSearchList[index]
                                                .showval!
                                            : 'na',
                                    margin: EdgeInsets.symmetric(
                                        horizontal: AppWidth(10),
                                        vertical: AppHeight(10)),
                                  ),
                                  Container(
                                    height: AppHeight(6),
                                    margin: EdgeInsets.only(top: AppHeight(5)),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: context
                                              .resources.color.colorLightGrey,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
      );
    });
  }
}
