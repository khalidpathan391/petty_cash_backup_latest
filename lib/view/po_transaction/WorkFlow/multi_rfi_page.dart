import 'package:flutter/material.dart';
import 'package:petty_cash/data/models/custom/wf_multi_rfi_model.dart';
import 'package:petty_cash/data/repository/general_rep.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/po_transaction/common_pagination/CommonPaginationSearching.dart';
import 'package:petty_cash/view/widget/CommonInkWell.dart';
import 'package:petty_cash/view/widget/CommonListingElements.dart';
import 'package:petty_cash/view/widget/common_button.dart';
import 'package:petty_cash/view/widget/common_text.dart';

class MultiRFIPage extends StatefulWidget {
  const MultiRFIPage({super.key});

  @override
  State<MultiRFIPage> createState() => _MultiRFIPageState();
}

class _MultiRFIPageState extends State<MultiRFIPage> {
  final _myRepo = GeneralRepository();
  bool isApiLoading = false;

  MultiRFI multiRFIData =
      MultiRFI([]); // Initialize multiRFIData so it's not null
  bool isAllSelected = false;

  @override
  void initState() {
    isAllSelected = false;
    isHit = false;
    required = false;
    empIdAll = '';
    empCodeAll = '';
    empNameAll = '';
    remarks = '';
    //setting default above and line item below
    var data =
        MultiRFILine(); //unique for each listItem as this is the type of item in the list.
    data.empId = '';
    data.empCode = '';
    data.empName = '';
    data.empDesignation = '';
    data.controller = TextEditingController();
    data.isOpen = true;
    data.isRequired = false;
    data.isSelected = isAllSelected;
    multiRFIData.lineData!.add(data);
    super.initState();
  }

  void addALine() {
    //unique for each listItem as this is the type of item in the list.
    var data = MultiRFILine();
    data.empId = '';
    data.empCode = '';
    data.empName = '';
    data.empDesignation = '';
    requiredAll = '';
    data.controller = TextEditingController();
    data.isOpen = true;
    data.isRequired = false;
    data.isSelected = isAllSelected;
    setState(() {
      multiRFIData.lineData!.add(data);
    });
  }

  void deleteALine() {
    if (isAllSelected) {
      multiRFIData.lineData!.clear();
      isAllSelected = false;
      addALine();
    } else {
      //inbuilt optimized remove function
      multiRFIData.lineData!
          .removeWhere((lineItem) => lineItem.isSelected == true);
      if (multiRFIData.lineData!.isEmpty) {
        addALine();
      } else {
        setState(() {});
      } //so only 1 setState runs
    }
  }

  void setShow(int index) {
    setState(() {
      multiRFIData.lineData![index].isOpen =
          !multiRFIData.lineData![index].isOpen!;
    });
  }

  void setRequired(int index) {
    setState(() {
      multiRFIData.lineData![index].isRequired =
          !multiRFIData.lineData![index].isRequired!;
    });
  }

  void setSelected(int index) {
    multiRFIData.lineData![index].isSelected =
        !multiRFIData.lineData![index].isSelected!;
    setState(() {});
  }

  void setOnAll() {
    isAllSelected = !isAllSelected;
    for (int i = 0; i < multiRFIData.lineData!.length; i++) {
      multiRFIData.lineData![i].isSelected = isAllSelected;
    }
    setState(() {});
  }

  bool isHit = false;
  bool required = false;
  String empIdAll = '';
  String empCodeAll = '';
  String empNameAll = '';
  String remarks = '';
  String requiredAll = '';

  void setParam() {
    isHit = false;
    required = false;
    empIdAll = '';
    empCodeAll = '';
    empNameAll = '';
    remarks = '';
    requiredAll = '';
    for (int i = 0; i < multiRFIData.lineData!.length; i++) {
      // checking if even 1 is true then send
      if (multiRFIData.lineData![i].isRequired!) {
        requiredAll += '1,';
        required = true;
      } else {
        requiredAll += '0,';
      }
      if (multiRFIData.lineData![i].empId!.isEmpty) {
        AppUtils.showToastRedBg(
            context, 'Emp Cannot be empty at index: ${i + 1}');
        isHit = true;
        break;
      } else {
        empIdAll += '${multiRFIData.lineData![i].empId},';
        empCodeAll += '${multiRFIData.lineData![i].empCode},';
        empNameAll += '${multiRFIData.lineData![i].empName},';
      }
      if (multiRFIData.lineData![i].controller!.text.isEmpty) {
        AppUtils.showToastRedBg(
            context, 'Comment cannot be empty at index: ${i + 1}');
        isHit = true;
        break;
      } else {
        remarks += '${multiRFIData.lineData![i].controller!.text},';
      }
    }
    empIdAll = AppUtils.removeLastCharacter(empIdAll);
    empCodeAll = AppUtils.removeLastCharacter(empCodeAll);
    empNameAll = AppUtils.removeLastCharacter(empNameAll);
    remarks = AppUtils.removeLastCharacter(remarks);
    requiredAll = AppUtils.removeLastCharacter(requiredAll);
    setState(() {
      isApiLoading = true;
    });
  }

  Future<void> callApi(BuildContext context) async {
    setParam();
    if (!required) {
      //if false it means not even 1 isRequired is selected
      AppUtils.showToastRedBg(context, 'At least 1 Required is to be selected');
      isHit = true;
    }
    if (isHit) {
      setState(() {
        isApiLoading = false;
      });
      return; //break if true
    }
    Map<String, String> apiParam = {
      'user_id': Global.empData!.userId.toString(),
      'company_id': Global.empData!.companyId.toString(),
      'header_id': Global.transactionHeaderId,
      'txn_type': Global.menuData!.txnCode,
      'mid': Global.menuData!.id.toString(),
      'required': requiredAll,
      'remarks': remarks,
      'assign_emp_id': empIdAll,
      'assign_emp_code': empCodeAll,
      'assign_emp_name': empNameAll,
    };
    _myRepo
        .postApi(ApiUrl.baseUrl! + ApiUrl.wfMultiRFI, apiParam)
        .then((value) {
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
          label: 'Multi-Request For Information',
          color: Colors.white,
          fontFamily: 'Bold',
          fontSize: context.resources.dimension.appBigText + 3,
        ),
      ),
      bottomNavigationBar: SizedBox(
        child: CommonButton(
          text: 'Submit',
          isLoading: isApiLoading,
          disable: isApiLoading, //if true disable button
          margin: EdgeInsets.symmetric(horizontal: AppWidth(75)),
          onPressed: () {
            callApi(context);
          },
          // isLoading: isApiLoading,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppHeight(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    setOnAll();
                  },
                  icon: Icon(
                    isAllSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: themeColor,
                  ),
                  padding: EdgeInsets.zero,
                ),
                const CommonTextView(
                  label: 'Select All',
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        addALine();
                      },
                      icon: Icon(
                        Icons.add,
                        color: themeColor,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    IconButton(
                      onPressed: () {
                        deleteALine();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: themeColor,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                )),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: multiRFIData.lineData!.length,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                  horizontal: AppWidth(15), vertical: AppHeight(5)),
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: AppHeight(10)),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: AppHeight(30),
                        decoration: BoxDecoration(
                          color: context.resources.color.themeColor,
                          border: const Border(
                            bottom: BorderSide(width: 1.0, color: Colors.black),
                          ),
                        ),
                        child: CommonInkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              MyHeaderData(
                                title: '#',
                                isIcon: true,
                                iconData:
                                    multiRFIData.lineData![index].isSelected!
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                onIconTap: () {
                                  setSelected(index);
                                },
                                flex: 3,
                              ),
                              const RightBorder(),
                              const MyHeaderData(
                                title: 'Emp Code',
                                flex: 3,
                              ),
                              const RightBorder(),
                              MyHeaderData(
                                title: 'Required',
                                flex: 4,
                                isDropdown: true,
                                dropIcon: multiRFIData.lineData![index].isOpen!
                                    ? Icons.arrow_drop_up_outlined
                                    : Icons.arrow_drop_down,
                                onTap: () {
                                  setShow(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppHeight(30),
                        child: Row(
                          children: [
                            MyHeaderData(
                              title: '${index + 1}',
                              textColor: Colors.black,
                              flex: 3,
                              myDecoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(.1)),
                            ),
                            const RightBorder(),
                            MyHeaderData(
                              title: multiRFIData
                                      .lineData![index].empCode!.isNotEmpty
                                  ? multiRFIData.lineData![index].empCode
                                      .toString()
                                  : 'Enter User Id',
                              textColor: Colors.black,
                              flex: 3,
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
                                      isItem: true,
                                    ),
                                  ),
                                ).then((value) {
                                  if (value != null) {
                                    multiRFIData.lineData![index].empId =
                                        value.userId.toString();
                                    multiRFIData.lineData![index].empCode =
                                        value.code.toString();
                                    multiRFIData.lineData![index].empName =
                                        value.desc.toString();
                                    multiRFIData
                                            .lineData![index].empDesignation =
                                        value.jobDesc.toString();
                                  }
                                }).whenComplete(() => setState(() {}));
                              },
                            ),
                            const RightBorder(),
                            MyHeaderData(
                              title: '#',
                              isIcon: true,
                              iconData:
                                  multiRFIData.lineData![index].isRequired!
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                              iconColor: themeColor,
                              onIconTap: () {
                                setRequired(index);
                              },
                              flex: 4,
                            ),
                          ],
                        ),
                      ),
                      ...multiRFIData.lineData![index].isOpen!
                          ? [
                              MyListRows(
                                title: 'EmpName',
                                value: multiRFIData
                                        .lineData![index].empName!.isNotEmpty
                                    ? multiRFIData.lineData![index].empName
                                        .toString()
                                    : '',
                                isSelectable: true,
                                myDecoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(.1)),
                                flex1: 3,
                                flex2: 7,
                              ),
                              MyListRows(
                                title: 'Designation',
                                value: multiRFIData.lineData![index]
                                        .empDesignation!.isNotEmpty
                                    ? multiRFIData
                                        .lineData![index].empDesignation
                                        .toString()
                                    : '',
                                isSelectable: true,
                                flex1: 3,
                                flex2: 7,
                                myDecoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(.1)),
                              ),
                              MyListRows(
                                title: 'Comments',
                                value: 'Enter remarks',
                                isSelectable: true,
                                isTextField: true,
                                flex1: 3,
                                flex2: 7,
                                controller:
                                    multiRFIData.lineData![index].controller,
                              ),
                            ]
                          : [],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
