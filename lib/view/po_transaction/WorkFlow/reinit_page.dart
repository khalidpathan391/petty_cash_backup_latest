import 'package:flutter/material.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/base/BaseGestureTouchSafeArea.dart';
import 'package:petty_cash/view/po_transaction/common_pagination/CommonPaginationSearching.dart';
import 'package:petty_cash/view/widget/common_button.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';

import '../../../data/repository/general_rep.dart';

class ReInitPage extends StatefulWidget {
  const ReInitPage({super.key});

  @override
  State<ReInitPage> createState() => _ReInitPageState();
}

class _ReInitPageState extends State<ReInitPage>
    with SingleTickerProviderStateMixin {
  final _myRepo = GeneralRepository();
  late TabController tabController;
  TextEditingController rController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController tController = TextEditingController();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(handleTabChange); //when click on tab
    tabController.animation!
        .addListener(handleTabAnimationChange); //when swipe in page
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  //Since only 2 pages use a bool to do changes to button
  bool isReInit = true;
  bool isApiLoading = false;
  int isNotify = 0;

  void handleTabChange() {
    if (tabController.indexIsChanging) {
      isReInit = (tabController.index == 0);
      setState(() {});
    }
  }

  // Listener function for animation changes
  void handleTabAnimationChange() {
    if (tabController.index.toDouble() == tabController.animation!.value) {
      isReInit = (tabController.index == 0);
      setState(() {});
    }
  }

  String assEmpId = '';
  String assEmpCode = '';
  String assEmpName = '';
  String fromEmpId = '';
  String fromEmpName = '';

  Future<bool> checkConditions(BuildContext context, int type) async {
    if (type == 0) {
      //for reinit
      if (levelController.text.isEmpty) {
        AppUtils.showToastRedBg(context, 'Level Cannot be empty');
        return false;
      } else if (rController.text.isEmpty) {
        AppUtils.showToastRedBg(context, 'Remarks Cannot be empty in Re-Init');
        return false;
      } else {
        return true;
      }
    } else {
      //for transfer
      if (fromEmpId.isEmpty) {
        AppUtils.showToastRedBg(
            context, 'Transfer From Employee Cannot be empty');
        return false;
      } else if (assEmpId.isEmpty) {
        AppUtils.showToastRedBg(
            context, 'Transfer To Employee Cannot be empty');
        return false;
      } else {
        return true;
      }
    }
  }

  Future<void> callApi(BuildContext context, String url, int type) async {
    //0 re-init and 1 transfer
    setState(() {
      isApiLoading = true;
    });
    Map<String, String> data = {
      'is_transfer': type.toString(),
      'user_id': Global.empData!.userId.toString(),
      'company_id': Global.empData!.companyId.toString(),
      'header_id': Global.transactionHeaderId,
      'sub_txn_type': Global.subTxnType,
      'txn_type': Global.menuData!.txnCode,
      'remarks': type == 0 ? rController.text : tController.text,
      //for re-initiate
      'is_notify': isNotify.toString(),
      'initiate_level': levelController.text,
      //for transfer
      'assign_emp_id': assEmpId,
      'assign_emp_code': assEmpCode,
      'assign_emp_name': assEmpName,
      'from_assign_emp_id': fromEmpId,
      'from_assign_emp_name': fromEmpName,
    };
    bool toHit = await checkConditions(context, type);
    if (toHit) {
      _myRepo.postApi(url, data).then((value) {
        if (value['error_code'] == 200) {
          AppUtils.showToastGreenBg(context, value['error_description']);
          Future.delayed(const Duration(milliseconds: 1500)).then((value) {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        } else {
          AppUtils.showToastRedBg(context, value['error_description']);
        }
      }).onError((error, stackTrace) {
        AppUtils.showToastRedBg(context, 'error: $error');
      }).whenComplete(() {
        setState(() {
          isApiLoading = false;
        });
      });
    } else {
      setState(() {
        isApiLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color themeColor = context.resources.color.themeColor;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white, size: 20),
        backgroundColor: themeColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          padding: EdgeInsets.zero,
        ),
        title: CommonTextView(
          label: 'Re-Initiate',
          color: Colors.white,
          fontFamily: 'Bold',
          fontSize: context.resources.dimension.appBigText + 3,
        ),
      ),
      bottomNavigationBar: SizedBox(
        child: CommonButton(
          text: isReInit ? 'Re-Initiate' : 'Transfer',
          isLoading: isApiLoading,
          margin: EdgeInsets.symmetric(horizontal: AppWidth(75)),
          onPressed: isApiLoading
              ? () {
                  AppUtils.showToastAnyBg(context, 'Api Loading ...');
                }
              : isReInit
                  ? () {
                      callApi(context, ApiUrl.baseUrl! + ApiUrl.wfReInit, 0);
                    }
                  : () {
                      callApi(context, ApiUrl.baseUrl! + ApiUrl.wfReInit, 1);
                    },
          // isLoading: isApiLoading,
        ),
      ),
      body: BaseGestureTouchSafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                controller: tabController,
                tabs: [
                  Tab(
                    child: CommonTextView(
                      label: 'Re-Initiate',
                      fontSize: context.resources.dimension.appBigText,
                      margin: EdgeInsets.symmetric(horizontal: AppWidth(10)),
                    ),
                  ),
                  Tab(
                    child: CommonTextView(
                      label: 'Transfer',
                      fontSize: context.resources.dimension.appBigText,
                      margin: EdgeInsets.symmetric(horizontal: AppWidth(10)),
                    ),
                  ),
                ],
                indicatorPadding: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                tabAlignment: TabAlignment.center,
                indicator: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(
                    color: context.resources.color.themeColor,
                    width: 2,
                  )),
                ),
                overlayColor: MaterialStateColor.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return context.resources.color.themeColor.withOpacity(.2);
                  }
                  return Colors.white;
                }),
                isScrollable: true,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppWidth(10),
                              vertical: AppHeight(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextView(
                                label: 'Re-Initiate from level?',
                                fontSize:
                                    context.resources.dimension.appBigText + 3,
                                fontFamily: 'Bold',
                                maxLine: 1,
                                overFlow: TextOverflow.ellipsis,
                                padding: EdgeInsets.symmetric(
                                    vertical: AppHeight(5)),
                              ),
                              CommonTextFormField(
                                label: 'Enter level... ',
                                maxLines: 100,
                                height: AppHeightP(7),
                                keyboardType: TextInputType.number,
                                maxLength: 3,
                                controller: levelController,
                              ),
                              CommonTextView(
                                label: 'Comments',
                                fontSize:
                                    context.resources.dimension.appBigText + 3,
                                fontFamily: 'Bold',
                                maxLine: 1,
                                overFlow: TextOverflow.ellipsis,
                                padding: EdgeInsets.symmetric(
                                    vertical: AppHeight(5)),
                              ),
                              CommonTextFormField(
                                label: 'Enter remarks here... ',
                                height: AppHeightP(30),
                                maxLines: 100,
                                keyboardType: TextInputType.multiline,
                                controller: rController,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: AppHeight(5)),
                                child: InkWell(
                                  onTap: () {
                                    if (isNotify == 0) {
                                      isNotify = 1;
                                    } else {
                                      isNotify = 0;
                                    }
                                    setState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      Icon(isNotify == 0
                                          ? Icons.check_box_outline_blank
                                          : Icons.check_box),
                                      const CommonTextView(
                                        label:
                                            ' Notify the users, which are in workflow.',
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppWidth(10),
                              vertical: AppHeight(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextView(
                                label: 'Select Employee',
                                fontSize:
                                    context.resources.dimension.appBigText + 3,
                                fontFamily: 'Bold',
                                maxLine: 1,
                                overFlow: TextOverflow.ellipsis,
                                padding: EdgeInsets.symmetric(
                                    vertical: AppHeight(5)),
                              ),
                              CommonTextView(
                                label: fromEmpId.isNotEmpty
                                    ? fromEmpName
                                    : 'Transfer from Employee *',
                                myDecoration: BoxDecoration(
                                    border: Border.all(
                                        color: themeColor.withOpacity(.5),
                                        width: .5),
                                    borderRadius: BorderRadius.circular(3)),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                margin: EdgeInsets.symmetric(
                                    vertical: AppHeight(10)),
                                maxLine: 1,
                                overFlow: TextOverflow.ellipsis,
                                fontSize:
                                    context.resources.dimension.appMediumText,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaginationSearching(
                                        url: ApiUrl.baseUrl! +
                                            ApiUrl.hseCommonSearch,
                                        searchType: 'EMPLOYEE',
                                        searchKeyWord: '',
                                        txnType: '',
                                      ),
                                    ),
                                  ).then((value) {
                                    if (value != null) {
                                      fromEmpId = value[0].toString();
                                      fromEmpName = value[2].toString();
                                    }
                                  }).whenComplete(() => setState(() {}));
                                },
                              ),
                              CommonTextView(
                                label: assEmpCode.isNotEmpty
                                    ? '$assEmpCode - $assEmpName'
                                    : 'Transfer To Employee *',
                                myDecoration: BoxDecoration(
                                    border: Border.all(
                                        color: themeColor.withOpacity(.5),
                                        width: .5),
                                    borderRadius: BorderRadius.circular(3)),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                margin: EdgeInsets.only(bottom: AppHeight(10)),
                                maxLine: 1,
                                overFlow: TextOverflow.ellipsis,
                                fontSize:
                                    context.resources.dimension.appMediumText,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaginationSearching(
                                        url: ApiUrl.baseUrl! +
                                            ApiUrl.hseCommonSearch,
                                        searchType: 'EMPLOYEE',
                                        searchKeyWord: '',
                                        txnType: '',
                                      ),
                                    ),
                                  ).then((value) {
                                    if (value != null) {
                                      assEmpId = value[0].toString();
                                      assEmpCode = value[1].toString();
                                      assEmpName = value[2].toString();
                                    }
                                  }).whenComplete(() => setState(() {}));
                                },
                              ),
                              CommonTextFormField(
                                label: 'Enter remarks here... ',
                                height: AppHeightP(30),
                                maxLines: 100,
                                keyboardType: TextInputType.multiline,
                                controller: tController,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
