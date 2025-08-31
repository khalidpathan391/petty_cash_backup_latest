import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/base/BaseGestureTouchSafeArea.dart';
import 'package:petty_cash/view/widget/common_button.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';
import 'package:petty_cash/view_model/HomePage/HomeVM.dart';
import 'package:provider/provider.dart';

class HomeFilter extends StatefulWidget {
  static const String id = "home_filter";
  const HomeFilter({super.key});

  @override
  State<HomeFilter> createState() => _HomeFilterState();
}

class _HomeFilterState extends State<HomeFilter> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVM>(
      builder: (context, provider, widgets) {
        return BaseGestureTouchSafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: context.resources.color.themeColor,
              iconTheme: const IconThemeData(color: Colors.white),
              title: CommonTextView(
                label: 'Advance Filter',
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
                        // provider.callFilterApi()
                        ;
                      }, '')
                    : Column(
                        children: [
                          Expanded(
                            child: DefaultTabController(
                              length: 2,
                              child: Scaffold(
                                backgroundColor: Colors.white,
                                appBar: AppBar(
                                  automaticallyImplyLeading: false,
                                  backgroundColor: Colors.white,
                                  title: TabBar(
                                    tabs: [
                                      Tab(
                                        child: CommonTextView(
                                          label: 'SORT',
                                          fontSize: context
                                              .resources.dimension.appBigText,
                                          fontFamily: 'Bold',
                                        ),
                                      ),
                                      Tab(
                                        child: CommonTextView(
                                          label: 'Filter',
                                          fontSize: context
                                              .resources.dimension.appBigText,
                                          fontFamily: 'Bold',
                                        ),
                                      ),
                                    ],
                                    indicatorPadding: const EdgeInsets.all(0),
                                    padding: const EdgeInsets.all(0),
                                    unselectedLabelColor: context
                                        .resources.color.themeColor
                                        .withOpacity(.5),
                                    // indicatorSize: TabBarIndicatorSize.label, // Set indicator size to match tab label
                                    indicatorColor:
                                        context.resources.color.themeColor,
                                  ),
                                  elevation: 0,
                                ),
                                body: TabBarView(
                                  children: [
                                    //Sort
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        CommonTextView(
                                          label: 'Sort By',
                                          color: context.resources.color
                                              .defaultMediumGrey,
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.all(AppWidth(10)),
                                        ),
                                        Container(
                                          height: AppHeight(6),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                color: context.resources.color
                                                    .colorLightGrey,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount:
                                                  provider.sortListData.length,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        CommonTextView(
                                                          label: provider
                                                              .sortListData[
                                                                  index]
                                                              .code
                                                              .toString(),
                                                          color: context
                                                              .resources
                                                              .color
                                                              .defaultMediumGrey,
                                                          width: AppWidthP(25),
                                                        ),
                                                        Container(
                                                          width: AppWidthP(25),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Row(
                                                            children: [
                                                              IconButton(
                                                                onPressed: () {
                                                                  provider
                                                                      .setSelected(
                                                                          index,
                                                                          0);
                                                                },
                                                                icon: Icon(
                                                                  provider
                                                                          .sortListData[
                                                                              index]
                                                                          .isAscSelected!
                                                                      ? Icons
                                                                          .circle
                                                                      : Icons
                                                                          .circle_outlined,
                                                                  color: context
                                                                      .resources
                                                                      .color
                                                                      .themeColor,
                                                                ),
                                                              ),
                                                              CommonTextView(
                                                                label: 'ASC',
                                                                color: context
                                                                    .resources
                                                                    .color
                                                                    .defaultMediumGrey,
                                                              ),
                                                            ],
                                                          ),
                                                        ), //provider.sortListData[index].code.toString(),
                                                        Container(
                                                          width: AppWidthP(25),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Row(
                                                            children: [
                                                              IconButton(
                                                                onPressed: () {
                                                                  provider
                                                                      .setSelected(
                                                                          index,
                                                                          1);
                                                                },
                                                                icon: Icon(
                                                                  provider
                                                                          .sortListData[
                                                                              index]
                                                                          .isDescSelected!
                                                                      ? Icons
                                                                          .circle
                                                                      : Icons
                                                                          .circle_outlined,
                                                                  color: context
                                                                      .resources
                                                                      .color
                                                                      .themeColor,
                                                                ),
                                                              ),
                                                              CommonTextView(
                                                                label: 'DESC',
                                                                color: context
                                                                    .resources
                                                                    .color
                                                                    .defaultMediumGrey,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width: AppWidthP(25),
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: IconButton(
                                                            onPressed: () {
                                                              provider
                                                                  .setSelected(
                                                                      index, 0);
                                                            },
                                                            icon: Icon(
                                                              provider
                                                                      .sortListData[
                                                                          index]
                                                                      .isChecked!
                                                                  ? Icons.square
                                                                  : Icons
                                                                      .square_outlined,
                                                              color: context
                                                                  .resources
                                                                  .color
                                                                  .themeColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      height: AppHeight(6),
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          top: BorderSide(
                                                            color: context
                                                                .resources
                                                                .color
                                                                .colorLightGrey,
                                                            width: 1,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ),
                                      ],
                                    ),

                                    //Filter
                                    Column(
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount: provider
                                                  .dashBoardFilterData!
                                                  .filterDataLst!
                                                  .length,
                                              // physics: const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: AppHeight(10),
                                                          bottom: AppHeight(10),
                                                          right: AppWidth(5),
                                                          left: AppWidth(5)),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color: context
                                                                .resources
                                                                .color
                                                                .themeColor),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          CommonTextView(
                                                            height:
                                                                AppHeight(30),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left:
                                                                        AppWidth(
                                                                            5)),
                                                            label: 'Filter By',
                                                            color: Colors.white,
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            fontSize: context
                                                                .resources
                                                                .dimension
                                                                .appBigText,
                                                            fontFamily: 'Bold',
                                                            myDecoration: BoxDecoration(
                                                                color: context
                                                                    .resources
                                                                    .color
                                                                    .themeColor),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal:
                                                                  AppWidth(10),
                                                              vertical:
                                                                  AppHeight(10),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      CommonTextView(
                                                                    label: provider
                                                                        .dashBoardFilterData!
                                                                        .filterDataLst![
                                                                            index]
                                                                        .filterTypeName
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: provider
                                                                              .dashBoardFilterData!
                                                                              .filterDataLst![index]
                                                                              .filterTypeCode ==
                                                                          'DATE'
                                                                      ? CommonTextView(
                                                                          label: provider.dashBoardFilterData!.filterDataLst![index].filterByDate.toString().isNotEmpty
                                                                              ? provider.dashBoardFilterData!.filterDataLst![index].filterByDate.toString()
                                                                              : 'DD-MM-YYYY',
                                                                          height:
                                                                              AppHeight(30),
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          color: provider.dashBoardFilterData!.filterDataLst![index].filterByDate.toString().isNotEmpty
                                                                              ? Colors.black
                                                                              : Colors.grey,
                                                                          padding:
                                                                              EdgeInsets.only(left: AppWidth(5)),
                                                                          myDecoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(color: context.resources.color.defaultBlueGrey.withOpacity(.5)),
                                                                            borderRadius:
                                                                                BorderRadius.circular(AppHeight(30) * .1),
                                                                          ),
                                                                          onTap:
                                                                              () async {
                                                                            final DateTime?
                                                                                myDate =
                                                                                await showDatePicker(
                                                                              context: context,
                                                                              initialDate: DateTime.now(),
                                                                              firstDate: DateTime.now().subtract(const Duration(days: 0)),
                                                                              lastDate: DateTime(2101),
                                                                            );
                                                                            if (myDate !=
                                                                                null) {
                                                                              provider.setFilterDate(index, DateFormat("dd-MMM-yyyy").format(myDate));
                                                                            }
                                                                          },
                                                                        )
                                                                      : CommonTextFormField(
                                                                          label:
                                                                              'Enter Value',
                                                                          height:
                                                                              AppHeight(30),
                                                                          controller: provider
                                                                              .dashBoardFilterData!
                                                                              .filterDataLst![index]
                                                                              .myController,
                                                                          onChanged: (value) => provider.setOnChangeValue(
                                                                              value,
                                                                              index),
                                                                        ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          CommonTextView(
                                                            height:
                                                                AppHeight(30),
                                                            label:
                                                                'Filter Type',
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left:
                                                                        AppWidth(
                                                                            5)),
                                                            fontSize: context
                                                                .resources
                                                                .dimension
                                                                .appBigText,
                                                            myDecoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            .5)),
                                                          ),
                                                          SingleChildScrollView(
                                                            child: ListView
                                                                .builder(
                                                                    itemCount: provider
                                                                        .dashBoardFilterData!
                                                                        .filterDataLst![
                                                                            index]
                                                                        .filterTypeLst!
                                                                        .length,
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                    itemBuilder:
                                                                        (context,
                                                                            i) {
                                                                      return Row(
                                                                        children: [
                                                                          Expanded(
                                                                              child: SizedBox(
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                IconButton(
                                                                                  onPressed: () {
                                                                                    provider.setFilterSelected(index, i, provider.dashBoardFilterData!.filterDataLst![index].filterTypeLst![i].code.toString());
                                                                                  },
                                                                                  icon: Icon(
                                                                                    provider.dashBoardFilterData!.filterDataLst![index].filterTypeLst![i].isSelected! ? Icons.circle : Icons.circle_outlined,
                                                                                    color: context.resources.color.themeColor,
                                                                                  ),
                                                                                ),
                                                                                CommonTextView(
                                                                                  label: provider.dashBoardFilterData!.filterDataLst![index].filterTypeLst![i].name.toString(),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )),
                                                                          provider.dashBoardFilterData!.filterDataLst![index].filterTypeLst![i].code.toString() == 'BETWEEN' && provider.dashBoardFilterData!.filterDataLst![index].filterTypeLst![i].isSelected!
                                                                              ? Expanded(
                                                                                  child: CommonTextFormField(
                                                                                    label: 'Enter Value',
                                                                                    height: AppHeight(30),
                                                                                    margin: EdgeInsets.only(
                                                                                      right: AppWidth(10),
                                                                                    ),
                                                                                    // margin: EdgeInsets.only(right: AppWidth(5)),
                                                                                    controller: provider.dashBoardFilterData!.filterDataLst![index].filterTypeLst![i].betweenController,
                                                                                    onChanged: (value) => provider.setOnBetweenValue(value, index, i),
                                                                                  ),
                                                                                )
                                                                              : const SizedBox(),
                                                                        ],
                                                                      );
                                                                    }),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      height: AppHeight(6),
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          top: BorderSide(
                                                            color: context
                                                                .resources
                                                                .color
                                                                .colorLightGrey,
                                                            width: 1,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          CommonButton(
                              text: 'Apply',
                              isLoading: provider.isApply,
                              onPressed: () {
                                provider.setFilterJsonData(context);
                              }),
                        ],
                      ),
          ),
        );
      },
    );
  }
}
