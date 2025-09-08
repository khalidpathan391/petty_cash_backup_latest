import 'package:flutter/material.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Home_Pages/multi_filter_more.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view_model/HomePage/HomeVM.dart';
import 'package:provider/provider.dart';

class MultiFilter extends StatefulWidget {
  static const String id = "multi_filter_home";
  const MultiFilter({super.key});

  @override
  State<MultiFilter> createState() => _MultiFilterState();
}

class _MultiFilterState extends State<MultiFilter> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVM>(
      builder: (context, provider, widgets) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: context.resources.color.themeColor,
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            title: CommonTextView(
              label: 'List Page',
              fontSize: context.resources.dimension.appBigText + 2,
              color: Colors.white,
              fontFamily: 'Bold',
            ),
            actions: [
              IconButton(
                onPressed: AppUtils.errorMessage.isNotEmpty
                    ? null
                    : () {
                        Navigator.pushNamed(context, MultiFilterMore.id)
                            .then((value) {
                          provider.setDefaultOnAddRulesPop();
                        });
                      },
                icon: const Icon(Icons.add),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: context.resources.color.themeColor,
            onPressed: AppUtils.errorMessage.isNotEmpty
                ? null
                : () {
                    provider.callMultiFilterDeleteApi(context);
                  },
            child: const Icon(Icons.delete),
          ),
          body: provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : AppUtils.errorMessage.isNotEmpty
                  ? AppUtils(context).getCommonErrorWidget(() {
                      provider.callMultiFilterListApi();
                    }, '')
                  : provider.multiFilterData!.rulesList!.isEmpty
                      ? const Center(
                          child: Text('Rule List Empty'),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount:
                                    provider.multiFilterData!.rulesList!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonTextView(
                                            label: provider.multiFilterData!
                                                        .rulesList![index].srNo
                                                        .toString()
                                                        .length ==
                                                    1
                                                ? '#0${provider.multiFilterData!.rulesList![index].srNo}'
                                                : '#${provider.multiFilterData!.rulesList![index].srNo}',
                                            margin: EdgeInsets.symmetric(
                                                vertical: AppHeight(5),
                                                horizontal: AppWidth(10)),
                                            color: Colors.grey,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              provider.callMultiFilterUpdateApi(
                                                  context, index, 1);
                                              Navigator.pushNamed(context,
                                                      MultiFilterMore.id)
                                                  .then((value) {
                                                provider
                                                    .setDefaultOnAddRulesPop();
                                              });
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: context
                                                  .resources.color.themeColor,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          provider.setMultiFilterSelected(
                                            index,
                                            provider.multiFilterData!
                                                .rulesList![index].ruleId
                                                .toString(),
                                          );
                                        },
                                        child: Container(
                                          color: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: AppWidth(10),
                                              vertical: AppHeight(10)),
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: AppHeight(5)),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              // provider.setMultiFilterSelected(
                                                              //   index,
                                                              //   provider.multiFilterData!.rulesList![index].ruleId.toString(),
                                                              // );
                                                            },
                                                            child: Icon(
                                                              provider
                                                                      .multiFilterData!
                                                                      .rulesList![
                                                                          index]
                                                                      .isSelected!
                                                                  ? Icons
                                                                      .radio_button_checked
                                                                  : Icons
                                                                      .circle_outlined,
                                                              size: 20,
                                                            ),
                                                          ),
                                                          CommonTextView(
                                                            label: 'Name:',
                                                            fontSize: context
                                                                .resources
                                                                .dimension
                                                                .appMediumText,
                                                            fontFamily: 'Bold',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: CommonTextView(
                                                        label:
                                                            '${provider.multiFilterData!.rulesList![index].ruleName}${provider.multiFilterData!.rulesList![index].ruleId}',
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        fontSize: context
                                                            .resources
                                                            .dimension
                                                            .appMediumText,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: CommonTextView(
                                                        label: 'Condition:',
                                                        alignment:
                                                            Alignment.center,
                                                        fontSize: context
                                                            .resources
                                                            .dimension
                                                            .appMediumText,
                                                        fontFamily: 'Bold',
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: CommonTextView(
                                                        label: provider
                                                            .multiFilterData!
                                                            .rulesList![index]
                                                            .ruleCondition!,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        fontSize: context
                                                            .resources
                                                            .dimension
                                                            .appMediumText,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: AppHeight(5)),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: CommonTextView(
                                                        label:
                                                            'Condition Data:',
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        fontSize: context
                                                            .resources
                                                            .dimension
                                                            .appMediumText,
                                                        fontFamily: 'Bold',
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: CommonTextView(
                                                        label: provider
                                                            .multiFilterData!
                                                            .rulesList![index]
                                                            .conditionData!,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        fontSize: context
                                                            .resources
                                                            .dimension
                                                            .appMediumText,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: AppHeight(5)),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: CommonTextView(
                                                        label: 'Rule To Run:',
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        fontSize: context
                                                            .resources
                                                            .dimension
                                                            .appMediumText,
                                                        fontFamily: 'Bold',
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: CommonTextView(
                                                        isSelectable: true,
                                                        label: provider
                                                            .multiFilterData!
                                                            .rulesList![index]
                                                            .ruleType!,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        fontSize: context
                                                            .resources
                                                            .dimension
                                                            .appMediumText,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
        );
      },
    );
  }
}
