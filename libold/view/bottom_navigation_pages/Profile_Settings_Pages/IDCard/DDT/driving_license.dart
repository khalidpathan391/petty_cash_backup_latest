// ignore_for_file: deprecated_member_use, avoid_unnecessary_containers, unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/common_annotated_region.dart';
import 'package:petty_cash/view/widget/common_shimmer_view.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view_model/HomePage/ProfileAndSettings/profile_settings_vm.dart';

import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../globalSize.dart';

class DrivingLicense extends StatefulWidget {
  static const String id = 'driving_license';
  final VoidCallback onDoubleTap;
  final bool isLandscape;

  const DrivingLicense(
      {Key? key, required this.onDoubleTap, this.isLandscape = false})
      : super(key: key);

  @override
  State<DrivingLicense> createState() => _DrivingLicenseState();
}

ProfileSettingsVM empProvider = ProfileSettingsVM();

class _DrivingLicenseState extends State<DrivingLicense> {
  bool? _isLandscape;
  VoidCallback? onDoubleTap;
  @override
  void initState() {
    empProvider = Provider.of(context, listen: false);
    empProvider.callDDTApi();
    _isLandscape = widget.isLandscape;
    onDoubleTap = widget.onDoubleTap;

    super.initState();
  }

  bool _isFront = true;
  @override
  Widget build(BuildContext context) {
    double mSize = context.resources.dimension.appMediumText - 2;
    double landScapeSize = context.resources.dimension.appBigText + 3;

    return CommonAnnotatedRegion(
      child: Consumer<ProfileSettingsVM>(builder: (context, provider, widget) {
        return provider.isLoading1
            ? const CommonShimmerView(
                numberOfRow: 20,
                shimmerViewType: ShimmerViewType.TRN_PAGE,
              )
            : provider.DdtErrorMsg.isNotEmpty
                ? AppUtils(context).getCommonErrorWidget(() {
                    provider.callDDTApi();
                  }, provider.DdtErrorMsg)
                : Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: _isLandscape!
                          ? EdgeInsets.only(top: AppHeight(10))
                          : EdgeInsets.only(top: AppHeight(25)),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: AppWidth(10)),
                        child: Card(
                          elevation: 7.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: GestureDetector(
                            onHorizontalDragStart: (details) {
                              if (_isLandscape!) {
                                _isFront = !_isFront;
                                setState(() {});
                              }
                            },
                            onTap: () {
                              _isLandscape!
                                  ? AppUtils.showToastRedBg(
                                      context, "Double Tap to Exit Full Screen")
                                  : AppUtils.showToastRedBg(context,
                                      "Double Tap to Open in Full Screen");
                            },
                            onDoubleTap: onDoubleTap,
                            //_handleDoubleTap,
                            onHorizontalDragUpdate: (details) {},
                            child: Stack(
                              children: [
                                Container(
                                  height: _isLandscape! ? AppHeightP(92) : null,
                                  width: _isLandscape! ? AppWidthP(70) : null,

                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/bg.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                  ),
                                  // margin: const EdgeInsets.all(10),
                                  child: _isFront
                                      ? _buildFrontContent(mSize, landScapeSize)
                                      : _buildBackContent(mSize, landScapeSize),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
      }),
    );
  }

  Widget _buildFrontContent(
    double mSize,
    double landScapeSize,
  ) {
    // String greenlogo = empProvider.empDDt!.data!.greenLogo.toString();
    String profileImageUrl = empProvider.empDDt!.data!.empPhoto.toString();
    //String companyLogoUrl = empProvider.empDDt!.data!.empComLogo.toString();
    return Padding(
      padding: _isLandscape!
          ? const EdgeInsets.only(left: 10, right: 3, top: 3, bottom: 3)
          : const EdgeInsets.all(7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  "assets/images/Sendan3.png",
                  height: _isLandscape! ? AppHeight(40 * 2) : AppHeight(30),
                ),
                // Image.network(
                //   companyLogoUrl,
                //   height: _isLandscape! ? AppHeight(80) : AppHeight(30),
                // ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonTextView(
                    label: "DRIVING PERMIT",
                    fontWeight: FontWeight.bold,
                    fontSize: _isLandscape! ? landScapeSize + 2 : mSize,
                  ),
                ],
              ),
              Container(
                // alignment: Alignment.topLeft,
                child: Image.asset(
                  "assets/images/Sendan2.png",
                  height: _isLandscape! ? AppHeight(30 * 2) : AppHeight(25),
                ),
                //  Image.network(
                //   greenlogo,
                //   height: _isLandscape! ? AppHeight(50) : AppHeight(25),
                // ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonTextView(
                label: "Permit No. :",
                fontWeight: FontWeight.bold,
                fontSize: _isLandscape! ? landScapeSize - 1 : mSize - 1,
                fontFamily: "Italic",

                color: Colors.red,
                //  margin: const EdgeInsets.only(bottom: 5, top: 10),
                maxLine: 1,
                overFlow: TextOverflow.ellipsis,
              ),
              CommonTextView(
                label: empProvider.empDDt!.data!.permitNumber.toString(),
                fontWeight: FontWeight.bold,
                fontSize: _isLandscape! ? landScapeSize - 2 : mSize - 1,
                fontFamily: "Italic",
                color: Colors.red,
                maxLine: 1,
                overFlow: TextOverflow.ellipsis,
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [

          //     CommonTextView(
          //       label: "Vehicle Authorization :",
          //       // fontWeight: FontWeight.bold,
          //       fontFamily: "Italic",

          //       fontSize: _isLandscape! ? landScapeSize-1 : mSize - 1,
          //       // margin: const EdgeInsets.only(left: 50),

          //       maxLine: 1,
          //       overFlow: TextOverflow.ellipsis,
          //     ),
          //     Expanded(
          //       child: CommonTextView(
          //         label: empProvider.empDDt!.data!.licenceType.toString(),
          //         alignment: Alignment.center,
          //         fontFamily: "Italic",

          //         // fontWeight: FontWeight.bold,
          //         fontSize: _isLandscape! ? landScapeSize-1 : mSize - 1,
          //         maxLine: 1,
          //         overFlow: TextOverflow.ellipsis,
          //       ),
          //     ),
          //   ],
          // ),
          Stack(
            children: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                //  crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CommonTextView(
                    label: "Vehicle Authorization",
                    // fontWeight: FontWeight.bold,
                    fontFamily: "Italic",
                    alignment: Alignment.topRight,

                    margin: const EdgeInsets.only(right: 10),
                    fontSize: _isLandscape! ? landScapeSize - 4 : mSize - 1,

                    maxLine: 1,
                    overFlow: TextOverflow.ellipsis,
                  ),
                  CommonTextView(
                    label: empProvider.empDDt!.data!.licenceType.toString(),
                    margin: const EdgeInsets.only(right: 10),
                    fontFamily: "Italic",
                    alignment: Alignment.topRight,
                    fontSize: _isLandscape! ? landScapeSize - 4 : mSize - 1,
                    maxLine: 1,
                    overFlow: TextOverflow.ellipsis,
                  ),
                  CommonTextView(
                    label: "Vehicle Type",
                    fontWeight: FontWeight.bold,
                    fontFamily: "Italic",
                    alignment: Alignment.topRight,
                    color: Colors.red,
                    margin: EdgeInsets.only(
                      right: 30,
                      top: _isLandscape! ? 20 : 8,
                    ),
                    fontSize: _isLandscape! ? landScapeSize - 3 : mSize - 1,
                    maxLine: 1,
                    overFlow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.check_box,
                          size: _isLandscape! ? 16 : 15,
                        ),
                      ),
                      CommonTextView(
                        label:
                            " ${empProvider.empDDt!.data!.manualVehicle.toString()}",
                        fontWeight: FontWeight.bold,
                        fontSize: _isLandscape! ? landScapeSize - 4 : mSize - 2,
                        maxLine: 1,
                        alignment: Alignment.topRight,
                        fontFamily: "Italic",
                        margin: const EdgeInsets.only(right: 10),
                        overFlow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: _isLandscape!
                        ? const EdgeInsets.symmetric(vertical: 10)
                        : const EdgeInsets.symmetric(vertical: 10),
                    height: _isLandscape! ? AppWidth(70) : AppWidth(75),
                    width: _isLandscape! ? AppWidth(70) : AppWidth(70),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          15.0), // Same radius as the second example
                      border: Border.all(color: Colors.grey, width: 0.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        profileImageUrl,
                        fit: BoxFit.cover,
                        width: _isLandscape! ? AppWidth(70) : AppWidth(64),
                        height: _isLandscape! ? AppWidth(70) : AppWidth(64),
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.person,
                              size: _isLandscape! ? AppWidth(35) : AppWidth(32),
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CommonTextView(
                              label: "Emp Name",
                              //  fontWeight: FontWeight.bold,
                              fontFamily: "Italic",

                              fontSize:
                                  _isLandscape! ? landScapeSize - 3 : mSize,
                              margin: EdgeInsets.only(
                                  left: _isLandscape! ? 30 : 15),
                              width: 85,
                              maxLine: 1,
                              overFlow: TextOverflow.ellipsis,
                            ),
                            CommonTextView(
                              label:
                                  ": ${empProvider.empDDt!.data!.empName.toString()}",
                              //fontWeight: FontWeight.bold,
                              fontFamily: "Italic",

                              fontSize:
                                  _isLandscape! ? landScapeSize - 3 : mSize,
                              maxLine: 1,
                              overFlow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CommonTextView(
                              label: "Emp No.",
                              //fontWeight: FontWeight.bold,
                              fontSize:
                                  _isLandscape! ? landScapeSize - 3 : mSize,
                              margin: EdgeInsets.only(
                                  left: _isLandscape! ? 30 : 15),
                              fontFamily: "Italic",

                              width: 85,
                              maxLine: 1,
                              overFlow: TextOverflow.ellipsis,
                            ),
                            CommonTextView(
                              label:
                                  ": ${empProvider.empDDt!.data!.empNo.toString()}",
                              fontSize:
                                  _isLandscape! ? landScapeSize - 3 : mSize,
                              maxLine: 1,
                              overFlow: TextOverflow.ellipsis,
                              fontFamily: "Italic",
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CommonTextView(
                              label: "Iqama No.",
                              margin: EdgeInsets.only(
                                  left: _isLandscape! ? 30 : 15),
                              fontSize:
                                  _isLandscape! ? landScapeSize - 3 : mSize,
                              width: 85,
                              maxLine: 1,
                              fontFamily: "Italic",
                              overFlow: TextOverflow.ellipsis,
                            ),
                            CommonTextView(
                              label:
                                  ": ${empProvider.empDDt!.data!.empIqamaNo.toString()}",
                              // fontWeight: FontWeight.bold,
                              fontSize:
                                  _isLandscape! ? landScapeSize - 3 : mSize,
                              maxLine: 1,
                              overFlow: TextOverflow.ellipsis,
                              fontFamily: "Italic",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Row(
          //   children: [
          //     GestureDetector(
          //       onTap: () {},
          //       child: const Icon(Icons.check_box),
          //     ),
          //     CommonTextView(
          //       label: " ${empProvider.empDDt!.data!.manualVehicle.toString()}",
          //       fontWeight: FontWeight.bold,
          //       fontSize: _isLandscape! ? landScapeSize - 1 : mSize,
          //       maxLine: 1,
          //       fontFamily: "Italic",
          //       margin: const EdgeInsets.only(left: 5),
          //       overFlow: TextOverflow.ellipsis,
          //     ),
          //   ],
          // ),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                Expanded(
                  child: CommonTextView(
                    label: "Issue Date :",
                    fontSize: _isLandscape! ? landScapeSize - 1 : mSize - 1,
                    fontFamily: "Italic",
                    maxLine: 1,
                    overFlow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: CommonTextView(
                    label:
                        " ${empProvider.empDDt!.data!.drivingIssDt.toString()}",
                    fontSize: _isLandscape! ? landScapeSize - 1 : mSize - 1,
                    fontFamily: "Italic",
                    maxLine: 1,
                    overFlow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: CommonTextView(
                    label: "Expired Date :",
                    fontSize: _isLandscape! ? landScapeSize - 1 : mSize - 1,
                    fontFamily: "Italic",
                    maxLine: 1,
                    overFlow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: CommonTextView(
                    label:
                        " ${empProvider.empDDt!.data!.drivingExpDt.toString()}",
                    fontSize: _isLandscape! ? landScapeSize - 1 : mSize - 1,
                    fontFamily: "Italic",
                    maxLine: 1,
                    overFlow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: CommonTextView(
                  label: "Violation No. :",
                  fontFamily: "Italic",
                  fontSize: _isLandscape! ? landScapeSize - 1 : mSize - 1,
                  maxLine: 1,
                  overFlow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildNumberedContainer(1, Colors.yellow),
                    SizedBox(width: AppWidth(2)),
                    _buildNumberedContainer(2, Colors.orange),
                    SizedBox(width: AppWidth(2)),
                    _buildNumberedContainer(3, Colors.grey),
                    SizedBox(width: AppWidth(2)),
                    _buildNumberedContainer(4, Colors.red),
                  ],
                ),
              ),
            ],
          ),
          // const Spacer(),
          Row(
            children: [
              CommonTextView(
                label: "ETD Representative :",
                fontSize: _isLandscape! ? landScapeSize - 1 : mSize - 1,
                fontFamily: "Italic",
                maxLine: 1,
                overFlow: TextOverflow.ellipsis,
              ),
              CommonTextView(
                label:
                    " ${empProvider.empDDt!.data!.etdEmpCode.toString()} - ${empProvider.empDDt!.data!.etdEmpDesc.toString()}",
                fontSize: _isLandscape! ? landScapeSize - 1 : mSize - 1,
                fontFamily: "Italic",
                maxLine: 1,
                overFlow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Row(
            children: [
              CommonTextView(
                label: "HSE Representative:",
                fontFamily: "Italic",
                fontSize: _isLandscape! ? landScapeSize - 1 : mSize - 1,
                maxLine: 1,
                overFlow: TextOverflow.ellipsis,
              ),
              CommonTextView(
                label:
                    " ${empProvider.empDDt!.data!.hseEmpCode.toString()} - ${empProvider.empDDt!.data!.hseEmpDesc.toString()}",
                fontSize: _isLandscape! ? landScapeSize - 2 : mSize - 1,
                maxLine: 1,
                overFlow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackContent(
    double mSize,
    landScapeSize,
  ) {
    // String companyLogoUrl = empProvider.empDDt!.data!.empComLogo.toString();
    // String greenlogo = empProvider.empDDt!.data!.greenLogo.toString();
    return Padding(
      padding: _isLandscape!
          ? const EdgeInsets.only(left: 10, right: 3, top: 3, bottom: 3)
          : const EdgeInsets.all(7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  "assets/images/Sendan3.png",
                  height: _isLandscape! ? AppHeight(40 * 2) : AppHeight(30),
                ),
                // Image.network(
                //   companyLogoUrl,
                //   height: _isLandscape! ? AppHeight(80) : AppHeight(30),
                // ),
              ),
              CommonTextView(
                label: "DRIVING PERMIT",
                fontWeight: FontWeight.bold,
                fontSize: _isLandscape! ? landScapeSize + 2 : mSize,
              ),
              Container(
                // alignment: Alignment.topLeft,
                child: Image.asset(
                  "assets/images/Sendan2.png",
                  height: _isLandscape! ? AppHeight(30 * 2) : AppHeight(25),
                ),
                //  Image.network(
                //   greenlogo,
                //   height: _isLandscape! ? AppHeight(50) : AppHeight(25),
                // ),
              ),
            ],
          ),
          SizedBox(
            height: AppHeight(10),
          ),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  QrImageView(
                      data: empProvider.getQrData(),
                      version: QrVersions.auto,
                      size: _isLandscape! ? AppWidth(40) : AppWidth(70),
                      backgroundColor: Colors.transparent)
                ],
              ),
              SizedBox(
                width: AppWidth(8),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                ),
                child: Column(
                  children: [
                    Container(
                      child: Center(
                          child: CommonTextView(
                        label: "Training Record", fontWeight: FontWeight.bold,
                        // margin: const EdgeInsets.only(bottom: 10),
                        color: Colors.red,
                        fontFamily: "Italic",

                        fontSize: _isLandscape! ? landScapeSize - 4 : mSize + 1,
                      )),
                    ),
                    DataTable(
                      dividerThickness: 1,
                      headingRowHeight: 0,
                      dataRowHeight: _isLandscape! ? 17 : 13,
                      columns: [
                        DataColumn(label: Container()),
                        DataColumn(
                          label: Container(),
                        ),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(
                            Center(
                              child: CommonTextView(
                                label: 'DDT',
                                fontSize: _isLandscape!
                                    ? landScapeSize - 4
                                    : mSize - 1,
                                fontFamily: "Italic",
                              ),
                            ),
                          ),
                          DataCell(
                            CommonTextView(
                              label:
                                  empProvider.empDDt!.data!.actualDt.toString(),
                              fontSize:
                                  _isLandscape! ? landScapeSize - 4 : mSize - 1,
                              fontFamily: "Italic",
                            ),
                          ),
                        ]),
                        DataRow(cells: [
                          // Cell 1: 'First Row Data Left'
                          DataCell(
                            CommonTextView(
                              label: 'MH',
                              fontFamily: "Italic",

                              // fontWeight: FontWeight.bold,
                              fontSize:
                                  _isLandscape! ? landScapeSize - 4 : mSize - 1,
                            ),
                          ),
                          // Cell 2: 'First Row Data Right'
                          DataCell(
                            CommonTextView(
                              label: '',
                              fontFamily: "Italic",

                              //fontWeight: FontWeight.bold,
                              fontSize:
                                  _isLandscape! ? landScapeSize - 4 : mSize - 1,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          CommonTextView(
            label:
                "EMERGENCY RESPONSE GUIDELINES  |आपातकालीन प्रतिक्रिया दिशानिर्देश  | \n إرشادات استجابة الطوارئ",
            fontWeight: FontWeight.bold,
            //
            fontFamily: "Italic",

            color: Colors.red,
            fontSize: _isLandscape! ? landScapeSize - 4 : mSize - 2,
          ),
          const SizedBox(
            height: 10,
          ),
          CommonTextView(
            label: "In case you get in a traffic accident please always...",
            fontWeight: FontWeight.bold,
            //margin: const EdgeInsets.only(bottom: 5),
            fontFamily: "Italic",

            fontSize: _isLandscape! ? landScapeSize - 3 : mSize - 2,
          ),
          CommonTextView(
            label: " * Make Sure of your safety and anyone with you.",
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontFamily: "Italic",
            fontSize: _isLandscape! ? landScapeSize - 3 : mSize - 2,
          ),
          CommonTextView(
            label: " * Take care when getting out of your vehicle.",
            fontWeight: FontWeight.bold,
            fontFamily: "Italic",
            color: Colors.red,
            fontSize: _isLandscape! ? landScapeSize - 3 : mSize - 2,
            margin: const EdgeInsets.only(bottom: 3),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonTextView(
                label:
                    "Please call on hotline number to report a vehicle accident :",
                fontWeight: FontWeight.bold,
                fontFamily: "Italic",
                fontSize: _isLandscape! ? landScapeSize - 4 : mSize - 2,
              ),
              CommonTextView(
                label: "0546542388",
                fontFamily: "Italic",
                fontWeight: FontWeight.bold,
                color: Colors.red,
                margin: const EdgeInsets.only(right: 5),
                fontSize: _isLandscape! ? landScapeSize - 4 : mSize - 2,
              ),
            ],
          ),
          CommonTextView(
            label: "0507996805",
            fontFamily: "Italic",
            fontWeight: FontWeight.bold,
            color: Colors.red,
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(right: 5),
            fontSize: _isLandscape! ? landScapeSize - 4 : mSize - 2,
          ),
          const Spacer(),
          CommonTextView(
            label: "Other Important Traffic Accident Contacts",
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontFamily: "Italic",
            fontSize: _isLandscape! ? landScapeSize - 2 : mSize,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CommonTextView(
                label: "Najm - 920000560",
                fontFamily: "Italic",
                fontSize: _isLandscape! ? landScapeSize - 4 : mSize - 2,
              ),
              CommonTextView(
                label: "Police - 991",
                fontFamily: "Italic",
                fontSize: _isLandscape! ? landScapeSize - 4 : mSize - 2,
              ),
              CommonTextView(
                label: "Fire - 998",
                fontFamily: "Italic",
                fontSize: _isLandscape! ? landScapeSize - 4 : mSize - 2,
              ),
              CommonTextView(
                label: "Ambulance - 997",
                fontFamily: "Italic",
                fontSize: _isLandscape! ? landScapeSize - 4 : mSize - 2,
              ),
            ],
          ),
          SizedBox(
            height: AppHeight(5),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedContainer(int number, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: _isLandscape! ? 40 : 30,
      height: _isLandscape! ? 40 : 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: CommonTextView(
          label: number.toString(),
          color: Colors.white,
          fontSize: _isLandscape!
              ? context.resources.dimension.appMediumText + 3
              : context.resources.dimension.appExtraSmallText + 2,
          fontFamily: 'Bold',
        ),
      ),
    );
  }

  void _handleDoubleTap() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      _isLandscape != true;
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      _isLandscape != false;
    }
  }

  void _handleClose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setState(() {
      _isLandscape = false;
    });
  }
}
