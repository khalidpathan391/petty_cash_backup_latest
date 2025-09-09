import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petty_cash/data/models/custom/upload_progress.dart';
import 'package:petty_cash/data/repository/general_rep.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/po_transaction/common_pagination/CommonPaginationSearching.dart';
import 'package:petty_cash/view/widget/common_button.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';

class WFOption extends StatefulWidget {
  final String label;
  final String remarks;
  final int type;
  const WFOption({
    super.key,
    required this.label,
    required this.remarks,
    required this.type,
  });

  @override
  State<WFOption> createState() => _WFOptionState();
}

class _WFOptionState extends State<WFOption> {
  final _myRepo = GeneralRepository();
  final ValueNotifier<UploadProgress> _progress =
      ValueNotifier<UploadProgress>(UploadProgress(
    0,
    0,
    0,
  ));
  final CancelToken cancelToken = CancelToken();
  FormData formData = FormData();
  TextEditingController controller = TextEditingController();
  bool isApiLoading = false;
  String remark = '';
  String empId = '';
  String filePath = '';
  String url = '';
  bool isSet = true; //to check the page type
  String empName = '';

  //don't need set state for things called in init state
  @override
  void initState() {
    controller = TextEditingController();
    controller.text = '';
    isApiLoading = false;
    remark = '';
    empId = '';
    filePath = '';
    url = '';
    isSet = true;
    if (widget.type != 0 && widget.type != 1 && widget.type != 2) {
      isSet = false;
    }
    super.initState();
  }

  void setApis() {
    remark = controller.text;
    formData.fields.add(MapEntry("user_id", Global.empData!.userId.toString()));
    formData.fields
        .add(MapEntry("company_id", Global.empData!.companyId.toString()));
    formData.fields.add(MapEntry("header_id", Global.transactionHeaderId));
    formData.fields.add(MapEntry("txn_type", Global.menuData!.txnCode));
    formData.fields.add(MapEntry("assign_emp_id", empId));
    formData.fields.add(MapEntry("remarks", remark));
    if (widget.type == 0) {
      // 1) Rfi - request for information
      url = ApiUrl.wfRFI;
    } else if (widget.type == 1) {
      // 2) F&A - forward and approve
      url = ApiUrl.wfFNA;
    } else if (widget.type == 2) {
      // 3) Forward
      url = ApiUrl.wfForward;
    }
    setState(() {
      isApiLoading = true;
    });
  }

  Future<void> callApiWithFile(BuildContext context) async {
    setApis();
    _myRepo.postApiWithFileDio('', File(''),
        baseUrl: ApiUrl.baseUrl!,
        url: url,
        formData: formData,
        file: File(filePath),
        key: 'attachment_file', onProgress: (progress) {
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
        } else {
          AppUtils.showToastRedBg(context, value['error_description']);
        }
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
    return PopScope(
      canPop: !isApiLoading, //false for this to work so if true then false
      onPopInvoked: (didPop) => AppUtils.popDialog(
        context,
        didPop,
        content: 'The Upload Progress will be lost if you go back now!',
        isCancel: true,
        cancelToken: cancelToken,
      ),
      child: Scaffold(
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
          ),
          title: CommonTextView(
            label: widget.label,
            color: Colors.white,
            fontFamily: 'Bold',
            fontSize: context.resources.dimension.appBigText + 3,
          ),
          actions: [
            if (filePath.isNotEmpty)
              InkWell(
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
                      AppUtils.showToastRedBg(context, 'file not supported');
                    }
                  },
                  child: const Icon(Icons.remove_red_eye)),
            if (filePath.isNotEmpty)
              IconButton(
                  onPressed: () {
                    setState(() {
                      filePath = '';
                    });
                  },
                  icon: const Icon(Icons.delete)),
            Container(
              padding: EdgeInsets.only(right: AppWidth(10)),
              child: InkWell(
                  onTap: filePath.isNotEmpty
                      ? () {
                          AppUtils.showToastRedBg(
                              context, 'Only 1 Attachment Allowed');
                        }
                      : () {
                          showBottomSheet(context);
                        },
                  child: const Icon(Icons.attach_file_outlined)),
            ),
          ],
          // bottom: PreferredSize(
          //   preferredSize: Size.fromHeight(4.0), // Adjust the height of the bottom border
          //   child: Container(
          //     color: Colors.grey, // Color of the bottom border
          //     height: 4.0, // Height of the bottom border
          //   ),
          // ),
        ),
        bottomNavigationBar: SizedBox(
          child: isApiLoading
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      context.resources.color.themeColor),
                                  minHeight: AppHeight(2),
                                ),
                                CommonTextView(
                                  label:
                                      '${AppUtils.formatBytes(value.sentBytes)} / ${AppUtils.formatBytes(value.totalBytes)}',
                                  padding: EdgeInsets.only(top: AppHeight(10)),
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      context.resources.color.themeColor),
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
              : CommonButton(
                  text: 'Submit',
                  margin: EdgeInsets.symmetric(horizontal: AppWidth(75)),
                  onPressed: () {
                    if (isSet) {
                      if (empId.isEmpty) {
                        AppUtils.showToastRedBg(
                            context, 'Employee cannot be empty');
                      } else if (controller.text.isEmpty) {
                        AppUtils.showToastRedBg(
                            context, 'Remarks cannot be empty');
                      } else {
                        callApiWithFile(context);
                      }
                    } else {
                      AppUtils.showToastRedBg(context, 'Type Not Assigned');
                    }
                  },
                  isLoading: isApiLoading,
                ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextView(
              label: 'Subject:\n ${widget.remarks}',
              color: Colors.white,
              maxLine: 11,
              overFlow: TextOverflow.ellipsis,
              myDecoration: BoxDecoration(color: themeColor),
              width: AppWidthP(100),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            ),
            const CommonTextView(
              label: 'Emp Name/Code',
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            ),
            CommonTextView(
              label: empName.isNotEmpty ? empName : 'Employee *',
              myDecoration: BoxDecoration(
                  border:
                      Border.all(color: themeColor.withOpacity(.5), width: .5),
                  borderRadius: BorderRadius.circular(5)),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              maxLine: 1,
              overFlow: TextOverflow.ellipsis,
              fontSize: context.resources.dimension.appMediumText,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaginationSearching(
                      url: ApiUrl.baseUrl! + ApiUrl.hseCommonSearch,
                      searchType: 'EMPLOYEE',
                      searchKeyWord: '',
                      txnType: '',
                    ),
                  ),
                ).then((value) {
                  if (value != null) {
                    empId = value[0].toString();
                    empName = '${value[1]}-${value[2]}';
                  }
                }).whenComplete(() => setState(() {}));
              },
            ),
            const CommonTextView(
              label: 'Remarks',
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            ),
            CommonTextFormField(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              label: 'Enter Here... ',
              height: AppHeightP(25),
              maxLines: 100,
              keyboardType: TextInputType.multiline,
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showBottomSheet(BuildContext context) async {
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
                getImage(ImageSource.camera);
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
                getImage(ImageSource.gallery);
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
                    setState(() {});
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

  void getImage(ImageSource source) {
    final picker = ImagePicker();
    //getImage
    picker.pickImage(source: source).then((value) {
      if (value != null) {
        //image path
        filePath = '';
        filePath = value.path;
        // chartData.chartList[currentIndex].anyDataPath = value.path;
        setState(() {});
      } else {
        AppUtils.showToastRedBg(context, 'No Item Selected');
      }
    }).onError((error, stackTrace) {
      AppUtils.showToastRedBg(context, 'error:$error');
    });
  }
}
