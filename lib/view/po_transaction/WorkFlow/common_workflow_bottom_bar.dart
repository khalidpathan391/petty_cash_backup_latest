// Global.menuData!.txnType - transaction type
// Navigator.pushNamed(context, Global.menuData!.txnType,arguments: -1).then((value) {});

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petty_cash/data/models/common/common_work_flow_model.dart';
import 'package:petty_cash/data/models/custom/upload_progress.dart';
import 'package:petty_cash/data/repository/general_rep.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/base/BaseGestureTouchSafeArea.dart';
import 'package:petty_cash/view/po_transaction/WorkFlow/multi_rfi_page.dart';
import 'package:petty_cash/view/po_transaction/WorkFlow/reinit_page.dart';
import 'package:petty_cash/view/po_transaction/WorkFlow/work_flow_option.dart';
import 'package:petty_cash/view/widget/common_button.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';

class CommonWFBottomBar extends StatefulWidget {
  final String remarks;
  final Future<bool> Function() callSubmitApi;
  final List<WorkFlowIcons> wfList0;

  const CommonWFBottomBar(
      {super.key,
      required this.callSubmitApi,
      required this.remarks,
      required this.wfList0});

  @override
  State<CommonWFBottomBar> createState() => _CommonWFBottomBarState();
}

class _CommonWFBottomBarState extends State<CommonWFBottomBar> {
  List<dynamic> wfList = [];
  final _myRepo = GeneralRepository();
  final ValueNotifier<UploadProgress> _progress =
      ValueNotifier<UploadProgress>(UploadProgress(
    0,
    0,
    0,
  ));
  final CancelToken cancelToken = CancelToken();
  FormData formData = FormData();

  bool isShow = false;
  bool isOne = false;
  bool isTwo = false;
  bool isEight = false;
  bool isApproval = false;
  bool isReject = false;

  @override
  void initState() {
    filePath = '';
    remark = '';
    isApiLoading = false;
    controller = TextEditingController();
    controller.text = '';
    super.initState();
  }

  TextEditingController controller = TextEditingController();
  String remark = '';

  bool isApiLoading = false;

  Future<void> callApproveNRejectNReplyApi(
      BuildContext context, StateSetter myState, String url) async {
    remark = controller.text;
    if (remark.isEmpty) {
      AppUtils.showToastRedBg(context, 'Remarks cannot be empty');
      return;
    }
    myState(() {
      isApiLoading = true;
    });
    formData.fields.add(MapEntry("user_id", Global.empData!.userId.toString()));
    formData.fields
        .add(MapEntry("company_id", Global.empData!.companyId.toString()));
    formData.fields.add(MapEntry("header_id", Global.transactionHeaderId));
    formData.fields.add(MapEntry("txn_type", Global.menuData!.txnCode));
    formData.fields.add(MapEntry("sub_txn_type", Global.subTxnType));
    formData.fields.add(const MapEntry("extra_data", ''));
    formData.fields.add(MapEntry("remarks", remark));
    formData.fields.add(MapEntry("is_notify", isCheck ? '1' : '0'));

    _myRepo.postApiWithFileDio('', File(''),
        key: 'attachment_file',
        baseUrl: ApiUrl.baseUrl!,
        url: url,
        file: File(filePath),
        formData: formData, onProgress: (progress) {
      _progress.value = progress;
    }, cancelToken: cancelToken).then((value) {
      if (value == 1) {
        AppUtils.showToastRedBg(context, 'Api Call Cancelled!');
      } else {
        if (value['error_code'] == 200) {
          AppUtils.showToastGreenBg(context, value['error_description']);
          Future.delayed(const Duration(milliseconds: 1500)).then((value) {
            Navigator.pop(context);
            Navigator.pop(context);
          });
          // Navigator.pushAndRemoveUntil(context,);
        } else {
          AppUtils.showToastRedBg(context, value['error_description']);
        }
      }
    }).onError((error, stackTrace) {
      AppUtils.showToastRedBg(context, 'error: $error');
    }).whenComplete(() {
      myState(() {
        isApiLoading = false;
      });
    });
  }

  // void onChange(String val){remark = val;}

  String url = '';
  Map<String, String> data = {};

  void setApis(int type) {
    remark = controller.text;
    data = {
      'user_id': Global.empData!.userId.toString(),
      'company_id': Global.empData!.companyId.toString(),
      'header_id': Global.transactionHeaderId,
      'txn_type': Global.menuData!.txnCode,
      'remarks': remark,
    };
    if (type == 1) {
      // 1) Approve Amend
      url = ApiUrl.baseUrl! + ApiUrl.wfApproveAmend;
    } else if (type == 2) {
      // 2) Reject Amend
      url = ApiUrl.baseUrl! + ApiUrl.wfRejectAmend;
    }
    setState(() {
      isApiLoading = true;
    });
  }

  Future<void> callApi(BuildContext context, int type) async {
    setApis(type);
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
  }

  @override
  Widget build(BuildContext context) {
    wfList = widget.wfList0;
    Color themeColor = context.resources.color.themeColor;
    return widget.wfList0.isNotEmpty
        ? Container(
            height: 60,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: .5),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: AppHeight(5)),
            child: Center(
              child: ListView.builder(
                itemCount: wfList.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: wfList.length == 2
                            ? 50
                            : wfList.length == 3
                                ? 35
                                : wfList.length == 4
                                    ? 20
                                    : wfList.length == 5
                                        ? 10
                                        : 5),
                    child: wfList[index].isApiLoading!
                        ? Container(
                            height: 25,
                            width: 25,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: themeColor,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              if (wfList[index].name == 'Approved') {
                                wfList[index].isApiLoading = true;
                                widget.callSubmitApi().then((success) {
                                  if (success) {
                                    // Future.delayed(const Duration(milliseconds: 1500), () {showWFPopUp(context,pageType: 'Approve');});
                                    showWFPopUp(
                                      context,
                                      pageType: 'Approve',
                                      controller: controller,
                                      url: ApiUrl.wfApprove, //approve api
                                      // onChange:onChange,
                                    );
                                  }
                                }).whenComplete(() {
                                  wfList[index].isApiLoading = false;
                                });
                                /*showWFPopUp(context,
                      pageType: 'Approve',
                      controller: controller,
                      url: ApiUrl.wfApprove,//approve api
                      // onChange:onChange,
                    );*/
                              } //1)Approve
                              else if (wfList[index].name == 'Reject') {
                                wfList[index].isApiLoading = true;
                                widget.callSubmitApi().then((success) {
                                  if (success) {
                                    // Future.delayed(const Duration(milliseconds: 1500), () {showWFPopUp(context,pageType: 'Approve');});
                                    showWFPopUp(
                                      context,
                                      pageType: 'Reject',
                                      controller: controller,
                                      url: ApiUrl.wfReject, //reject api
                                      // onChange:onChange,
                                    );
                                  }
                                }).whenComplete(() {
                                  wfList[index].isApiLoading = false;
                                });
                              } //2)Reject
                              else if (wfList[index].name == 'RFI') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WFOption(
                                        label: 'RFI Details',
                                        remarks: widget.remarks,
                                        type: 0,
                                      ),
                                    ));
                              } // 3) Rfi
                              else if (wfList[index].name == 'MRFI') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MultiRFIPage(),
                                    ));
                              } // 4) Multi rfi
                              else if (wfList[index].name == 'A&F') {
                                wfList[index].isApiLoading = true;
                                widget.callSubmitApi().then((success) {
                                  if (success) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WFOption(
                                            label: 'F&A Details',
                                            remarks: widget.remarks,
                                            type: 1,
                                          ),
                                        )).then((value) {
                                      wfList[index].isApiLoading = false;
                                    });
                                  }
                                });
                                wfList[index].isApiLoading = false;
                              } // 5) Approve and Forward
                              else if (wfList[index].name == 'Forward') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WFOption(
                                        label: 'Forward Details',
                                        remarks: widget.remarks,
                                        type: 2,
                                      ),
                                    ));
                              } // 6) Forward
                              else if (wfList[index].name == 'ReInit') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ReInitPage(),
                                    ));
                              } // 7) ReInit
                              else if (wfList[index].name == 'Reply') {
                                showWFPopUp(
                                  context,
                                  pageType: 'Reply',
                                  controller: controller,
                                  url: ApiUrl.wfReply, //reject api
                                  isReply: true,
                                  label: 'What would you like to tell us?',
                                  rfiRemark: widget.remarks,
                                  // onChange:onChange,
                                );
                              } // 8)reply
                              else if (wfList[index].name ==
                                  'Approve Amendment') {
                                AppUtils.showSubmit(context,
                                    controller: controller,
                                    label: 'Amend Approve', onSubmit: (file) {
                                  callApi(context, 1);
                                });
                              } // 9) Amend Approve
                              else if (wfList[index].name ==
                                  'Reject Amendment') {
                                AppUtils.showSubmit(context,
                                    controller: controller,
                                    label: 'Amend Reject', onSubmit: (file) {
                                  callApi(context, 2);
                                });
                              } // 10) Amend Reject
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  wfList[index].icon!,
                                  width: 25,
                                  height: 25,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return const Icon(
                                      Icons.details,
                                      size: 20,
                                    );
                                  },
                                ),
                                CommonTextView(
                                  label: wfList[index].name!,
                                  maxLine: 1,
                                  fontSize: context
                                      .resources.dimension.appExtraSmallText,
                                  overFlow: TextOverflow.ellipsis,
                                  fontFamily: 'Bold',
                                  alignment: Alignment.center,
                                  width: 50,
                                  padding: const EdgeInsets.only(top: 5),
                                ),
                              ],
                            ),
                          ),
                  );
                },
              ),
            ),
          )
        : const SizedBox();
  }

  String filePath = '';
  bool isCheck = false;

  void showWFPopUp(
    BuildContext context, {
    TextEditingController? controller,
    Function(String)? onChange,
    required String pageType,
    bool isReply = false,
    String label = 'Comments',
    String rfiRemark = 'NA',
    required String url,
  }) {
    filePath = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color themeColor = context.resources.color.themeColor;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter myState) {
          return PopScope(
            canPop:
                !isApiLoading, //false for this to work so if true then false
            onPopInvoked: (didPop) => AppUtils.popDialog(
              context,
              didPop,
              content: 'The Upload Progress will be lost if you go back now!',
              isCancel: true,
              cancelToken: cancelToken,
            ),
            child: BaseGestureTouchSafeArea(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(4.0), // Set the corner radius
                ),
                title: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: themeColor, width: .2))),
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CommonTextView(
                        label: pageType,
                        color: themeColor,
                        fontSize: context.resources.dimension.appMediumText,
                        fontFamily: 'Bold',
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (filePath.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: InkWell(
                                onTap: () {
                                  List<String> parts = filePath.split('.');
                                  String extension = parts.last
                                      .toLowerCase(); // Return the last part as lowercase
                                  if (extension == 'jpg' ||
                                      extension == 'jpeg' ||
                                      extension == 'png') {
                                    AppUtils.showPhotoDialog(
                                        context, 'Selected Image', filePath,
                                        isOnline: false);
                                  } else {
                                    AppUtils.showToastRedBg(
                                        context, 'file not supported');
                                  }
                                },
                                child: const Icon(
                                  Icons.remove_red_eye,
                                  size: 17,
                                ),
                              ),
                            ),
                          Transform.rotate(
                            angle: 45,
                            child: InkWell(
                              //instead of setState myState
                              onTap: filePath.isNotEmpty
                                  ? () {
                                      AppUtils.showToastRedBg(
                                          context, 'One Attachment Only');
                                    }
                                  : () {
                                      showBottomSheet(context, myState);
                                    },
                              child: const Icon(
                                Icons.attach_file,
                                size: 17,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: InkWell(
                              onTap: () {
                                myState(() {
                                  filePath = '';
                                });
                              },
                              child: const Icon(
                                Icons.delete,
                                size: 17,
                              ),
                            ),
                          ),
                          // InkWell(
                          //   onTap: () {Navigator.pop(context);},
                          //   child: const Icon(
                          //     Icons.close,
                          //     size: 17,
                          //   ),
                          // ),
                        ],
                      )),
                    ],
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextView(
                      label: label,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    if (isReply)
                      CommonTextView(
                        label: rfiRemark,
                        myDecoration: BoxDecoration(
                            border: Border.all(
                                color: themeColor.withOpacity(.5), width: .5),
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.amber.withOpacity(.1)),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        maxLine: 1,
                        overFlow: TextOverflow.ellipsis,
                        fontSize: context.resources.dimension.appMediumText,
                      ),
                    CommonTextFormField(
                      label: 'Type your comments here',
                      height: AppHeightP(30),
                      width: AppWidthP(80),
                      maxLines: 100,
                      keyboardType: TextInputType.multiline,
                      controller: controller,
                      onChanged: onChange,
                    ),
                    if (!isReply)
                      GestureDetector(
                        onTap: () {
                          myState(() {
                            isCheck = !isCheck;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Icon(isCheck
                                  ? Icons.check_box_rounded
                                  : Icons.check_box_outline_blank),
                              CommonTextView(
                                label: 'Notify the users,which are in workflow',
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    context.resources.dimension.appMediumText,
                                maxLine: 1,
                                overFlow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                // Adjust content padding
                actionsPadding: const EdgeInsets.only(
                    right: 10.0, left: 10.0, bottom: 10.0),
                // Adjust actions padding
                actions: [
                  isApiLoading
                      ? ValueListenableBuilder<UploadProgress>(
                          valueListenable: _progress,
                          builder: (context, value, child) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...value.progress != 1
                                    ? [
                                        LinearProgressIndicator(
                                          value: value.progress,
                                          backgroundColor: context
                                              .resources.color.themeColor
                                              .withOpacity(.5),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  context.resources.color
                                                      .themeColor),
                                          minHeight: AppHeight(2),
                                        ),
                                        CommonTextView(
                                          label:
                                              '${AppUtils.formatBytes(value.sentBytes)} / ${AppUtils.formatBytes(value.totalBytes)}',
                                          padding: EdgeInsets.only(
                                              top: AppHeight(10)),
                                        ),
                                        CommonTextView(
                                          label:
                                              'Uploading : ${(value.progress * 100).toStringAsFixed(0)}%',
                                          padding: EdgeInsets.symmetric(
                                              vertical: AppHeight(10)),
                                        ),
                                      ]
                                    : [
                                        LinearProgressIndicator(
                                          backgroundColor: context
                                              .resources.color.themeColor
                                              .withOpacity(.5),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  context.resources.color
                                                      .themeColor),
                                          minHeight: AppHeight(2),
                                        ),
                                        CommonTextView(
                                          label: 'Syncing Data ...',
                                          padding: EdgeInsets.symmetric(
                                              vertical: AppHeight(10)),
                                        ),
                                      ],
                              ],
                            );
                          },
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonButton(
                              text: 'Cancel'.tr(),
                              textColor: Colors.white,
                              color: context.resources.color.secondaryColor,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              fontSize: 15,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            CommonButton(
                              text: 'Submit'.tr(),
                              isLoading: isApiLoading,
                              textColor: Colors.white,
                              color: context.resources.color.themeColor,
                              onPressed: () {
                                callApproveNRejectNReplyApi(
                                    context, myState, url);
                              },
                              fontSize: 15,
                            ),
                          ],
                        ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> showBottomSheet(
      BuildContext context, StateSetter myState) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Color themeColor = context.resources.color.themeColor;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(
                Icons.camera,
                size: 30,
              ),
              title: CommonTextView(
                label: 'Camera',
                fontSize: context.resources.dimension.appBigText + 3,
                fontFamily: 'Bold',
              ),
              onTap: () {
                getImage(ImageSource.camera, myState);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo,
                size: 30,
              ),
              title: CommonTextView(
                label: 'Gallery',
                fontSize: context.resources.dimension.appBigText + 3,
                fontFamily: 'Bold',
              ),
              onTap: () {
                getImage(ImageSource.gallery, myState);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.insert_drive_file,
                size: 30,
              ),
              title: CommonTextView(
                label: 'All Files',
                fontSize: context.resources.dimension.appBigText + 3,
                fontFamily: 'Bold',
              ),
              onTap: () {
                //File picker
                FilePicker.platform.pickFiles().then((value) {
                  if (value != null) {
                    filePath = '';
                    filePath = value.files.single.path!;
                    myState(() {});
                  } else {
                    AppUtils.showToastRedBg(context, 'No Item Selected');
                  }
                }).onError((error, stackTrace) {
                  AppUtils.showToastRedBg(context, 'error:$error');
                }).whenComplete(() {
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void getImage(ImageSource source, StateSetter myState) {
    final picker = ImagePicker();
    //getImage
    picker.pickImage(source: source).then((value) {
      if (value != null) {
        //image path
        filePath = '';
        filePath = value.path;
        // chartData.chartList[currentIndex].anyDataPath = value.path;
        myState(() {});
      } else {
        AppUtils.showToastRedBg(context, 'No Item Selected');
      }
    }).onError((error, stackTrace) {
      AppUtils.showToastRedBg(context, 'error:$error');
    });
  }
}
