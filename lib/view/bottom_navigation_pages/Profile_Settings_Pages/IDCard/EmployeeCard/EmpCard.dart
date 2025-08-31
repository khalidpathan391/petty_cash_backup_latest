// ignore_for_file: library_private_types_in_public_api, unused_element, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/common_annotated_region.dart';
import 'package:petty_cash/view/widget/common_shimmer_view.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view_model/HomePage/ProfileAndSettings/profile_settings_vm.dart';

import 'package:provider/provider.dart';

class EmployeeIDForm extends StatefulWidget {
  final VoidCallback onDoubleTap;
  final bool isLandscape;

  const EmployeeIDForm(
      {Key? key, required this.onDoubleTap, this.isLandscape = false})
      : super(key: key);

  @override
  _EmployeeIDFormState createState() => _EmployeeIDFormState();
}

ProfileSettingsVM empProvider = ProfileSettingsVM();

class _EmployeeIDFormState extends State<EmployeeIDForm>
    with TickerProviderStateMixin {
  bool _isFront = true;
  bool _isLandscape = false;
  VoidCallback? onDoubleTap;

  @override
  void initState() {
    empProvider = Provider.of(context, listen: false);
    empProvider.callEmpIDApi();

    _isLandscape = widget.isLandscape;
    onDoubleTap = widget.onDoubleTap;

    super.initState();
  }

  double? textSizeM;
  @override
  Widget build(BuildContext context) {
    return CommonAnnotatedRegion(
      child: Consumer<ProfileSettingsVM>(builder: (context, provider, widget) {
        //   double screenHeight = MediaQuery.of(context).size.height;
        // double cardHeight = screenHeight * 0.34;
        textSizeM = context.resources.dimension.appBigText + 3;
        return provider.isLoading
            ? const CommonShimmerView(
                numberOfRow: 20,
                shimmerViewType: ShimmerViewType.TRN_PAGE,
              )
            : provider.empErrorMsg.isNotEmpty
                ? AppUtils(context).getCommonErrorWidget(() {
                    provider.callEmpIDApi();
                  }, provider.empErrorMsg)
                : Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: _isLandscape
                              ? EdgeInsets.only(top: AppHeight(10))
                              : EdgeInsets.only(top: AppHeight(5)),
                          child: Card(
                            elevation: 7.0,
                            // color: Colors.teal.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: GestureDetector(
                              onHorizontalDragStart: (details) {
                                if (_isLandscape) {
                                  _isFront = !_isFront;
                                  setState(() {});
                                }
                              },
                              onTap: () {
                                _isLandscape
                                    ? AppUtils.showToastRedBg(context,
                                        "Double Tap to Exit Full Screen Mode")
                                    : AppUtils.showToastRedBg(context,
                                        "Double Tap to Open in Full Screen Mode");
                              },
                              onDoubleTap: onDoubleTap,
                              onHorizontalDragUpdate: (details) {},
                              child: Stack(
                                children: [
                                  Container(
                                    height:
                                        _isLandscape ? AppHeightP(92) : null,
                                    width: _isLandscape ? AppWidthP(70) : null,
                                    // height: _isLandscape
                                    //     ? AppHeightP(85)
                                    //     : AppHeight(210),
                                    // width: _isLandscape
                                    //     ? AppWidthP(70)
                                    //     : AppWidthP(95),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image:
                                            AssetImage('assets/images/bg.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                      // border: Border(
                                      //   top: BorderSide(
                                      //       color: Colors.black, width: 1),
                                      // ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 4, bottom: 4),
                                      child: _isFront
                                          ? _buildFrontContent()
                                          : _buildBackContent(),
                                    ),
                                  ),
                                  if (_isFront)
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 25,
                                        decoration: const BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(8.0),
                                            bottomLeft: Radius.circular(8.0),
                                          ),
                                          border: Border(
                                            bottom: BorderSide(
                                                color: Colors.orange, width: 1),
                                          ),
                                        ),
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 25,
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(
                                                        color: Colors.white,
                                                        width: AppWidth(5)),
                                                  ),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(35.0),
                                                    bottomLeft:
                                                        Radius.circular(8.0),
                                                  ),
                                                ),
                                                child: const Center(
                                                  child: Text("ERP"),
                                                ),
                                              ),
                                            ),
                                            _getColorContainer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
      }),
    );
  }

  Widget _buildFrontContent() {
    String profileImageUrl =
        empProvider.employeeIDModel!.data![0].empPhoto.toString();
    // String companyLogoUrl =
    //     empProvider.employeeIDModel!.data![0].empComLogo.toString();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  "assets/images/Sendan3.png",
                  height: _isLandscape ? AppHeight(50 * 2.5) : AppHeight(30),
                ),
                //  Image.network(
                //   ApiUrl.baseUrl! + companyLogoUrl,
                //   height: _isLandscape ? AppHeight(50 * 2.5) : AppHeight(30),
                // ),
              ),
            ),
            Image.asset(
              "assets/images/14001-.png",
              height: _isLandscape ? AppHeight(55 * 2.4) : AppHeight(35),
            ),
            const SizedBox(width: 7),
            Image.asset(
              "assets/images/18001-.png",
              height: _isLandscape ? AppHeight(50 * 2.3) : AppHeight(30),
            ),
            const SizedBox(width: 7),
            Image.asset(
              "assets/images/9001-.png",
              height: _isLandscape ? AppHeight(49 * 2.3) : AppHeight(30),
            ),
            const SizedBox(width: 7),
            Image.asset(
              "assets/images/005-.png",
              height: _isLandscape ? AppHeight(50 * 2.3) : AppHeight(30),
            ),
          ],
        ),
        const SizedBox(
          width: double.infinity,
          child: Divider(
            color: Colors.green,
            thickness: 2,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: AppWidth(10)),
                  height:
                      _isLandscape ? AppHeight(80) * 5 : AppHeight(70) * 1.5,
                  width: _isLandscape
                      ? (AppHeight(100) * 3.5) / 1.2
                      : (AppHeight(90) * 1.2) / 1.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.grey, width: 0.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      ApiUrl.baseUrl! + profileImageUrl,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image,
                            size: _isLandscape
                                ? AppHeight(80) * 5 / 2
                                : AppHeight(70) * 1.5 / 2,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: AppWidth(20)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CommonTextView(
                        label: 'Emp No:  ',
                        fontSize: _isLandscape
                            ? context.resources.dimension.appBigText + 3
                            : context.resources.dimension.appMediumText + 2,
                        fontFamily: "Italic",
                        margin: _isLandscape
                            ? EdgeInsets.only(top: AppHeight(5))
                            : EdgeInsets.only(top: AppHeight(2)),
                        overFlow: TextOverflow.ellipsis,
                      ),
                      CommonTextView(
                        label: empProvider.employeeIDModel!.data![0].empNo
                            .toString(),
                        fontSize: _isLandscape
                            ? context.resources.dimension.appBigText + 3
                            : context.resources.dimension.appMediumText + 2,
                        fontFamily: "Italic",
                        margin: _isLandscape
                            ? EdgeInsets.only(top: AppHeight(5))
                            : EdgeInsets.only(top: AppHeight(2)),
                        overFlow: TextOverflow.ellipsis,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  CommonTextView(
                    label:
                        'Emp Name: ${empProvider.employeeIDModel!.data![0].empName}',
                    fontSize: _isLandscape
                        ? context.resources.dimension.appBigText + 3
                        : context.resources.dimension.appMediumText + 2,
                    fontFamily: "Italic",
                    margin: _isLandscape
                        ? EdgeInsets.only(top: AppHeight(5))
                        : EdgeInsets.only(top: AppHeight(2)),
                    overFlow: TextOverflow.ellipsis,
                  ),
                  CommonTextView(
                    label:
                        'Job Title: ${empProvider.toTitleCase(empProvider.employeeIDModel!.data![0].empJobTitle.toString())}',
                    fontSize: _isLandscape
                        ? context.resources.dimension.appBigText + 3
                        : context.resources.dimension.appMediumText + 2,
                    fontFamily: "Italic",
                    margin: _isLandscape
                        ? EdgeInsets.only(top: AppHeight(5))
                        : EdgeInsets.only(top: AppHeight(2)),
                    overFlow: TextOverflow.ellipsis,
                  ),
                  CommonTextView(
                    label:
                        'Validity: ${empProvider.employeeIDModel!.data![0].empValidity}',
                    fontSize: _isLandscape
                        ? context.resources.dimension.appBigText + 3
                        : context.resources.dimension.appMediumText + 2,
                    fontFamily: "Italic",
                    margin: _isLandscape
                        ? EdgeInsets.only(top: AppHeight(5))
                        : EdgeInsets.only(
                            top: AppHeight(2),
                          ),
                    overFlow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CommonTextView(
                          label:
                              "${empProvider.employeeIDModel!.data![0].empNameBl} :",
                          maxLine: 1,
                          alignment: Alignment.centerRight,
                          overFlow: TextOverflow.ellipsis,
                          fontSize: _isLandscape
                              ? context.resources.dimension.appBigText + 4
                              : context.resources.dimension.appMediumText + 2,
                          margin: _isLandscape
                              ? EdgeInsets.only(top: AppHeight(5))
                              : EdgeInsets.only(top: AppHeight(0)),
                          fontWeight: FontWeight.bold,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                      Expanded(
                        child: CommonTextView(
                          label: empProvider
                              .employeeIDModel!.data![0].hEmpNameBl
                              .toString(),
                          maxLine: 1,
                          alignment: Alignment.centerRight,
                          overFlow: TextOverflow.ellipsis,
                          fontSize: _isLandscape
                              ? context.resources.dimension.appBigText + 4
                              : context.resources.dimension.appMediumText + 2,
                          margin: _isLandscape
                              ? EdgeInsets.only(
                                  top: AppHeight(5),
                                )
                              : const EdgeInsets.only(top: 0),
                          fontWeight: FontWeight.bold,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CommonTextView(
                          label:
                              ": ${empProvider.employeeIDModel!.data![0].empJobBl} ",
                          maxLine: 1,
                          alignment: Alignment.centerRight,
                          overFlow: TextOverflow.ellipsis,
                          fontSize: _isLandscape
                              ? context.resources.dimension.appBigText + 4
                              : context.resources.dimension.appMediumText + 2,
                          margin: _isLandscape
                              ? EdgeInsets.only(
                                  top: AppHeight(5),
                                )
                              : EdgeInsets.only(top: AppHeight(0)),
                          fontWeight: FontWeight.bold,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      Expanded(
                        child: CommonTextView(
                          label: empProvider.employeeIDModel!.data![0].hEmpJobBl
                              .toString(),
                          maxLine: 1,
                          // color: Colors.teal,
                          alignment: Alignment.centerRight,
                          overFlow: TextOverflow.ellipsis,
                          fontSize: _isLandscape
                              ? context.resources.dimension.appBigText + 4
                              : context.resources.dimension.appMediumText + 2,
                          margin: _isLandscape
                              ? EdgeInsets.only(top: AppHeight(5))
                              : const EdgeInsets.only(top: 0),
                          fontWeight: FontWeight.bold,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CommonTextView(
                          label:
                              "${empProvider.employeeIDModel!.data![0].empValidityBl} :",
                          alignment: Alignment.centerRight,
                          fontSize: _isLandscape
                              ? context.resources.dimension.appBigText + 4
                              : context.resources.dimension.appMediumText + 2,
                          margin: _isLandscape
                              ? EdgeInsets.only(top: AppHeight(5))
                              : EdgeInsets.only(top: AppHeight(0)),
                          fontWeight: FontWeight.bold,
                          maxLine: 1,
                          overFlow: TextOverflow.ellipsis,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                      Expanded(
                        child: CommonTextView(
                          label: empProvider
                              .employeeIDModel!.data![0].hEmpValidityBl
                              .toString(),
                          alignment: Alignment.centerRight,
                          fontSize: _isLandscape
                              ? context.resources.dimension.appBigText + 4
                              : context.resources.dimension.appMediumText + 2,
                          margin: _isLandscape
                              ? EdgeInsets.only(top: AppHeight(5))
                              : const EdgeInsets.only(top: 0),
                          fontWeight: FontWeight.bold,
                          maxLine: 1,
                          overFlow: TextOverflow.ellipsis,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppHeight(30),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBackContent() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppWidth(5), vertical: AppHeight(5)),
        // ignore: prefer_const_constructors
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CommonTextView(
                        label: 'ID/Iqama No',
                        fontSize: _isLandscape
                            ? context.resources.dimension.appBigText + 3
                            : context.resources.dimension.appMediumText,
                        fontFamily: "Italic",
                        fontWeight: FontWeight.bold,
                        margin: _isLandscape
                            ? EdgeInsets.only(top: AppHeight(5))
                            : EdgeInsets.only(top: AppHeight(0))),
                    CommonTextView(
                        label: empProvider.employeeIDModel!.data![0].empIqamaNo
                            .toString(),
                        fontSize: _isLandscape
                            ? context.resources.dimension.appBigText + 3
                            : context.resources.dimension.appMediumText,
                        fontFamily: 'Italic',
                        margin: _isLandscape
                            ? EdgeInsets.only(top: AppHeight(5))
                            : EdgeInsets.only(top: AppHeight(0))),
                  ],
                ),
                Column(
                  children: [
                    CommonTextView(
                        label: 'Nationality',
                        fontSize: _isLandscape
                            ? context.resources.dimension.appBigText + 3
                            : context.resources.dimension.appMediumText,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Italic",
                        margin: _isLandscape
                            ? EdgeInsets.only(top: AppHeight(5))
                            : EdgeInsets.only(top: AppHeight(0))),
                    CommonTextView(
                        label: empProvider
                            .employeeIDModel!.data![0].empNationality
                            .toString(),
                        alignment: Alignment.centerRight,
                        fontSize: _isLandscape
                            ? context.resources.dimension.appBigText + 3
                            : context.resources.dimension.appMediumText,
                        fontFamily: 'Italic',
                        margin: _isLandscape
                            ? EdgeInsets.only(
                                top: AppHeight(5),
                              )
                            : EdgeInsets.only(top: AppHeight(0))),
                  ],
                ),
                Column(
                  children: [
                    CommonTextView(
                        label: 'Blood Group',
                        fontSize: _isLandscape
                            ? context.resources.dimension.appBigText + 3
                            : context.resources.dimension.appMediumText,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Italic",
                        margin: _isLandscape
                            ? EdgeInsets.only(top: AppHeight(5))
                            : EdgeInsets.only(top: AppHeight(0))),
                    CommonTextView(
                        label: empProvider.employeeIDModel!.data![0].empBloodG
                            .toString(),
                        fontSize: _isLandscape
                            ? context.resources.dimension.appBigText + 3
                            : context.resources.dimension.appMediumText,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        alignment: Alignment.centerRight,
                        margin: _isLandscape
                            ? EdgeInsets.only(
                                top: AppHeight(5),
                              )
                            : EdgeInsets.only(top: AppHeight(0)))
                  ],
                ),
              ],
            ),
            SizedBox(
              height: AppHeight(5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonTextView(
                    label: 'Emergency Contact Number',
                    fontWeight: FontWeight.bold,
                    fontSize: _isLandscape
                        ? context.resources.dimension.appBigText + 5
                        : context.resources.dimension.appBigText,
                    fontFamily: "Italic",
                    margin: _isLandscape
                        ? EdgeInsets.only(top: AppHeight(5))
                        : EdgeInsets.only(top: AppHeight(0))),
              ],
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonTextView(
                    label: 'Company Nurse  :',
                    fontSize: _isLandscape
                        ? context.resources.dimension.appBigText + 3
                        : context.resources.dimension.appMediumText,
                    fontFamily: "Italic",
                    margin: _isLandscape
                        ? EdgeInsets.only(top: AppHeight(5))
                        : EdgeInsets.only(top: AppHeight(0))),
                // SizedBox( width: AppWidth(20.6*5),),
                Expanded(
                  child: CommonTextView(
                      label: empProvider.employeeIDModel!.data![0].emergencyCoNo
                          .toString(),
                      fontSize: _isLandscape
                          ? context.resources.dimension.appBigText + 3
                          : context.resources.dimension.appMediumText,
                      fontFamily: "Italic",
                      alignment: Alignment.centerRight,
                      margin: _isLandscape
                          ? EdgeInsets.only(top: AppHeight(5))
                          : EdgeInsets.only(top: AppHeight(0))),
                ),
              ],
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonTextView(
                    label: 'GOSI/Med Insurence Assistance :',
                    fontSize: _isLandscape
                        ? context.resources.dimension.appBigText + 3
                        : context.resources.dimension.appMediumText,
                    fontFamily: "Italic",
                    margin: _isLandscape
                        ? EdgeInsets.only(
                            top: AppHeight(5),
                          )
                        : EdgeInsets.only(top: AppHeight(0))),
                //SizedBox( width: AppWidth(8*5),),
                Expanded(
                  child: CommonTextView(
                      label: empProvider
                          .employeeIDModel!.data![0].gosiMedInsAssNo
                          .toString(),
                      alignment: Alignment.centerRight,
                      fontSize: _isLandscape
                          ? context.resources.dimension.appBigText + 3
                          : context.resources.dimension.appMediumText,
                      fontFamily: "Italic",
                      margin: _isLandscape
                          ? EdgeInsets.only(
                              top: AppHeight(5),
                            )
                          : EdgeInsets.only(top: AppHeight(0))),
                ),
              ],
            ),
            SizedBox(
              height: AppHeight(25),
            ),
            Center(
              child: CommonTextView(
                label:
                    empProvider.employeeIDModel!.data![0].empComName.toString(),
                fontSize: _isLandscape
                    ? context.resources.dimension.appBigText + 4
                    : context.resources.dimension.appBigText,
                fontFamily: "Italic",
                margin: _isLandscape
                    ? EdgeInsets.only(top: AppHeight(5))
                    : EdgeInsets.only(top: AppHeight(0)),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: AppHeight(25),
            ),
            Column(
              children: [
                CommonTextView(
                  label: empProvider.employeeIDModel!.data![0].empComAdd1
                      .toString(),
                  fontSize: _isLandscape
                      ? context.resources.dimension.appMediumText + 4
                      : context.resources.dimension.appExtraSmallText,
                  alignment: Alignment.center,
                  fontFamily: "Italic",
                  margin: _isLandscape
                      ? EdgeInsets.only(top: AppHeight(5))
                      : EdgeInsets.only(top: AppHeight(0)),
                  overFlow: TextOverflow.ellipsis,
                ),
                CommonTextView(
                  label: empProvider.employeeIDModel!.data![0].empComAdd2
                      .toString(),
                  fontSize: _isLandscape
                      ? context.resources.dimension.appMediumText + 4
                      : context.resources.dimension.appExtraSmallText,
                  alignment: Alignment.center,
                  fontFamily: "Italic",
                  margin: _isLandscape
                      ? EdgeInsets.only(top: AppHeight(5))
                      : EdgeInsets.only(top: AppHeight(0)),
                  overFlow: TextOverflow.ellipsis,
                ),
                CommonTextView(
                  label: empProvider.employeeIDModel!.data![0].empComAdd3
                      .toString(),
                  fontSize: _isLandscape
                      ? context.resources.dimension.appMediumText + 4
                      : context.resources.dimension.appExtraSmallText,
                  alignment: Alignment.center,
                  fontFamily: "Italic",
                  margin: _isLandscape
                      ? EdgeInsets.only(top: AppHeight(5))
                      : EdgeInsets.only(top: AppHeight(0)),
                  overFlow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: AppHeight(15)),
              child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextView(
                      label: 'Authorized Signature',
                      fontSize: _isLandscape
                          ? context.resources.dimension.appBigText + 4
                          : context.resources.dimension.appBigText,
                      fontFamily: "Italic",
                      margin: _isLandscape
                          ? EdgeInsets.only(top: AppHeight(5))
                          : EdgeInsets.only(top: 0, bottom: AppHeight(18)),
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      width: AppWidth(12 * 5),
                    ),
                    Image.asset("assets/images/Sign-.png",
                        height: _isLandscape ? AppHeight(60) : AppHeight(30))
                    // SvgPicture.asset("assets/images/sign.svg",
                    //     height: _isLandscape ? AppHeight(60) : AppHeight(30))
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _getColorContainer() {
    return Container(
      width: _isLandscape
          ? MediaQuery.of(context).size.width / 1.5 - 65 * 2.5
          : MediaQuery.of(context).size.width / 1.5 - 14,
      height: 25,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
        ),
        color: Colors.orange,
      ),
      child: CommonTextView(
          label: 'www.sendan.com sa',
          fontFamily: "Italic",
          color: Colors.white,
          fontSize: context.resources.dimension.appBigText + 2),
      alignment: Alignment.bottomRight,
      margin: EdgeInsets.only(right: AppWidth(10)),
    );
  }

  void _handleDoubleTap() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      _isLandscape = true;
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      _isLandscape = false;
    }
  }
}
