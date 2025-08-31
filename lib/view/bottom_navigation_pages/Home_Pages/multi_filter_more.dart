import 'package:flutter/material.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/widget/common_button.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';
import 'package:petty_cash/view_model/HomePage/HomeVM.dart';
import 'package:provider/provider.dart';

class MultiFilterMore extends StatefulWidget {
  static const String id = "multi_filter_more_home";
  const MultiFilterMore({super.key});

  @override
  State<MultiFilterMore> createState() => _MultiFilterMoreState();
}

class _MultiFilterMoreState extends State<MultiFilterMore> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVM>(builder: (context, provider, widget) {
      return Scaffold(
        appBar: AppBar(
          title: CommonTextView(
            label: 'Add Rules',
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
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: AppWidth(10),
                              vertical: AppHeight(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextView(
                                label: 'Name*',
                                fontSize:
                                    context.resources.dimension.appMediumText,
                                margin: EdgeInsets.only(bottom: AppHeight(5)),
                              ),
                              provider.isApply
                                      // provider.updatePage
                                      ==
                                      'yes'
                                  ? CommonTextView(
                                      label: provider.ruleName,
                                      alignment: Alignment.centerLeft,
                                      height: AppHeight(30),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: AppWidth(5)),
                                      color: Colors.grey,
                                      myDecoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    )
                                  : CommonTextFormField(
                                      label: 'Enter Name',
                                      margin:
                                          EdgeInsets.only(bottom: AppHeight(5)),
                                      height: AppHeight(30),
                                      controller: provider.ruleTypeController,
                                      onChanged: provider.setRuleName,
                                    ),
                              CommonTextView(
                                label: 'Select Rules to run',
                                fontSize:
                                    context.resources.dimension.appMediumText,
                                margin: EdgeInsets.only(bottom: AppHeight(5)),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppWidth(5),
                                    vertical: AppHeight(2)),
                                margin: EdgeInsets.only(bottom: AppHeight(5)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            provider.setRulesAllNotification();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right: AppWidth(5)),
                                            child: Icon(provider.allNotification
                                                ? Icons.circle
                                                : Icons.circle_outlined),
                                          ),
                                        ),
                                        const Expanded(
                                          child: CommonTextView(
                                            label:
                                                'Move all notification what you have and new notification',
                                            maxLine: 1,
                                            isSelectable: true,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            provider.setRulesNewNotification();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right: AppWidth(5)),
                                            child: Icon(provider.newNotification
                                                ? Icons.circle
                                                : Icons.circle_outlined),
                                          ),
                                        ),
                                        const Expanded(
                                          child: CommonTextView(
                                            label: 'New notification only',
                                            maxLine: 1,
                                            isSelectable: true,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              CommonTextView(
                                label: 'Condition*',
                                fontSize:
                                    context.resources.dimension.appMediumText,
                                margin: EdgeInsets.only(bottom: AppHeight(5)),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: AppHeight(30),
                                margin: EdgeInsets.only(bottom: AppHeight(5)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppWidth(10),
                                    vertical: AppHeight(5)),
                                child: InkWell(
                                  onTap: () {
                                    // provider.callMultiFilterConditionApi();
                                    // Navigator.pushNamed(context, MultiFilterSearchList.id).then((value){});
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 3,
                                        height: AppHeight(20),
                                        margin:
                                            EdgeInsets.only(right: AppWidth(5)),
                                        color: Colors.orange,
                                      ),
                                      CommonTextView(
                                        label: provider.conditionType.isNotEmpty
                                            ? provider.conditionType
                                            : 'Please Select Condition',
                                        color: provider.conditionType.isNotEmpty
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              provider.conditionType == 'SUBJECT - Subject'
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonTextView(
                                          label: 'Subject*',
                                          fontSize: context.resources.dimension
                                              .appMediumText,
                                          margin: EdgeInsets.only(
                                              bottom: AppHeight(5)),
                                        ),
                                        CommonTextFormField(
                                          label: 'Enter Subject with',
                                          margin: EdgeInsets.only(
                                              bottom: AppHeight(5)),
                                          height: AppHeight(30),
                                          controller:
                                              provider.subjectTypeController,
                                          onChanged: provider.setSubjectWith,
                                        )
                                      ],
                                    )
                                  : provider.conditionType == 'TXN - Txn'
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CommonTextView(
                                              label: 'Txn*',
                                              fontSize: context.resources
                                                  .dimension.appMediumText,
                                              margin: EdgeInsets.only(
                                                  bottom: AppHeight(5)),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              margin: EdgeInsets.only(
                                                  bottom: AppHeight(5)),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: AppWidth(10),
                                                  vertical: AppHeight(5)),
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      // provider.callMultiFilterTxnApi();
                                                      // Navigator.pushNamed(context, MultiFilterSearchList.id).then((value){});
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 3,
                                                          height: AppHeight(20),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right:
                                                                      AppWidth(
                                                                          5)),
                                                          color: Colors.orange,
                                                        ),
                                                        const CommonTextView(
                                                          label:
                                                              'Please Select txn',
                                                          color: Colors.grey,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Wrap(
                                                  //   spacing: 2.0,
                                                  //   runSpacing: -10,
                                                  //   alignment: WrapAlignment.start,
                                                  //   crossAxisAlignment: WrapCrossAlignment.center,
                                                  //   children: [
                                                  //     ...provider.txnSelectedData.map((data) => Chip(
                                                  //       label: CommonTextView(
                                                  //         label: data.x!,
                                                  //         fontSize: context.resources.dimension.appMediumText,
                                                  //       ),
                                                  //       backgroundColor: Colors.grey.withOpacity(.5),
                                                  //       deleteIcon: const Icon(Icons.highlight_remove_outlined,),
                                                  //       onDeleted: (){provider.removeTxnType(data);},
                                                  //     ),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : provider.conditionType == 'USER - User'
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonTextView(
                                                  label: 'User*',
                                                  fontSize: context.resources
                                                      .dimension.appMediumText,
                                                  margin: EdgeInsets.only(
                                                      bottom: AppHeight(5)),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  margin: EdgeInsets.only(
                                                      bottom: AppHeight(5)),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: AppWidth(10),
                                                      vertical: AppHeight(5)),
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          // provider.callMultiFilterUserApi();
                                                          // Navigator.pushNamed(context, MultiFilterSearchList.id).then((value){});
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 3,
                                                              height:
                                                                  AppHeight(20),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          AppWidth(
                                                                              5)),
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            const CommonTextView(
                                                              label:
                                                                  'Please Select user',
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // Wrap(
                                                      //   spacing: 2.0,
                                                      //   runSpacing: -10,
                                                      //   alignment: WrapAlignment.start,
                                                      //   crossAxisAlignment: WrapCrossAlignment.center,
                                                      //   children: [
                                                      //     ...provider.userSelectedData.map((data) => Chip(
                                                      //       label: CommonTextView(
                                                      //         label: data.x!,
                                                      //         fontSize: context.resources.dimension.appMediumText,
                                                      //       ),
                                                      //       backgroundColor: Colors.grey.withOpacity(.5),
                                                      //       deleteIcon: const Icon(Icons.highlight_remove_outlined,),
                                                      //       onDeleted: (){provider.removeUserType(data);},
                                                      //     ),
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                              CommonTextView(
                                label: 'Notification Type*',
                                fontSize:
                                    context.resources.dimension.appMediumText,
                                margin: EdgeInsets.only(bottom: AppHeight(5)),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                margin: EdgeInsets.only(bottom: AppHeight(5)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppWidth(10),
                                    vertical: AppHeight(5)),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        // if(provider.selectedNotification == 'All'){
                                        //   AppUtils.showToastRedBg(context, 'Already Selected All');
                                        // }else{
                                        //   provider.callMultiFilterNotificationApi();
                                        //   Navigator.pushNamed(context, MultiFilterSearchList.id).then((value){});
                                        // }
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 3,
                                            height: AppHeight(20),
                                            margin: EdgeInsets.only(
                                                right: AppWidth(5)),
                                            color: Colors.orange,
                                          ),
                                          const CommonTextView(
                                            label:
                                                'Please Select Notification Type',
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Wrap(
                                    //   spacing: 2.0,
                                    //   runSpacing: -10,
                                    //   alignment: WrapAlignment.start,
                                    //   crossAxisAlignment: WrapCrossAlignment.center,
                                    //   children: [
                                    //     ...provider.notificationSelectedData.map((data) => Chip(
                                    //       label: CommonTextView(
                                    //         label: data.x!,
                                    //         fontSize: context.resources.dimension.appMediumText,
                                    //       ),
                                    //       backgroundColor: Colors.grey.withOpacity(.5),
                                    //       deleteIcon: const Icon(Icons.highlight_remove_outlined,),
                                    //       onDeleted: (){provider.removeNotificationType(data);},
                                    //     ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        CommonButton(
                          text: 'Run Now',
                          onPressed: () {
                            // if(provider.updatePage == 'yes'){
                            //   provider.callMultiFilterUpdateApi(context, provider.myRuleIndex, 0);
                            // }else{
                            //   provider.checkAndAddRule(context);
                            // }
                          },
                          isLoading: provider.isApply,
                          margin: EdgeInsets.only(top: AppHeight(230)),
                        ),
                      ],
                    ),
                  ),
      );
    });
  }
}
