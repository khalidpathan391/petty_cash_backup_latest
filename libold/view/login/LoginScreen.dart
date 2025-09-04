import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/base/BaseGestureTouchSafeArea.dart';
import 'package:petty_cash/view/login/CompanyIdActivationPage.dart';
import 'package:petty_cash/view/login/common/CommonAppBar.dart';
import 'package:petty_cash/view/widget/CommonInkWell.dart';
import 'package:petty_cash/view/widget/animated_button.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';
import 'package:petty_cash/view_model/Authentication/AuthVM.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";
  final bool shouldRemember;

  const LoginScreen({super.key, this.shouldRemember = true});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthVM authVM = AuthVM();
  @override
  void initState() {
    authVM = Provider.of(context, listen: false);
    if (widget.shouldRemember) {
      //in some cases don't need to remember
      authVM.setIsRememberValue();
    }
    if (authVM.userNameController.text.isNotEmpty &&
        authVM.passwordController.text.length > 5 &&
        authVM.allCompDataList.isNotEmpty) {
      authVM.isdisable = false;
    } else {
      authVM.isdisable = true;
    }
    super.initState();
    // meUserNameController.addListener(() {
    //   callApi();
    //   _updateButtonState();
    // });
    // mePasswordController.addListener(() {
    //   _updateButtonState();
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void callApi() {
  //   if ((meUserNameController.text.length == 6)) {
  //     String userName = meUserNameController.text.toString().trim();
  //     Map data = {
  //       'emp_code': userName,
  //     };
  //     authVM.callCompanyListApi(context, data);
  //   } else {
  //     authVM.clearData();
  //   }
  // }
  //
  // void _updateButtonState() {
  //   if (meUserNameController.text.isNotEmpty &&
  //       mePasswordController.text.isNotEmpty &&
  //       authVM.allCompDataList.isNotEmpty) {
  //     authVM.setdisable(false);
  //   } else {
  //     authVM.setdisable(true);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Global.empData != null ? false : true,
      onPopInvoked: (didPop) {
        AppUtils.popDialog(context, didPop,
            content: "exitornot".tr(),
            title: "Confirmation!".tr(),
            isExit: true);
      },
      child: Scaffold(
        backgroundColor: context.resources.color.colorWhite,
        appBar: CommonAppBar(context, Global.empData != null ? 0 : 1),
        body: BaseGestureTouchSafeArea(
          child: SingleChildScrollView(
            child: Consumer<AuthVM>(builder: (context, lVM, widget) {
              return Padding(
                padding: EdgeInsets.only(
                  right: AppWidth(40),
                  left: AppWidth(40),
                  top: AppHeight(50),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CommonTextView(
                        label: 'appName'.tr(),
                        fontSize: context.resources.dimension.appExtraBigText,
                        onTap: () {},
                        margin: EdgeInsets.only(bottom: AppHeight(10)),
                      ),
                    ),
                    Center(
                      child: CommonTextView(
                        label: 'To the future vision'.tr(),
                        fontSize: context.resources.dimension.appBigText,
                        margin: EdgeInsets.only(bottom: AppHeight(48)),
                      ),
                    ),
                    CommonTextView(
                      label: 'Sign In'.tr(),
                      fontSize: appTextSize(19),
                      fontFamily: 'Bold',
                      margin: EdgeInsets.only(
                          bottom: AppHeight(24),
                          left: AppWidth(10),
                          right: AppWidth(10)),
                    ),
                    CommonTextFormField(
                      label: 'User ID'.tr(),
                      controller: authVM.userNameController,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      enabled: !authVM.isUserNameControllerDisable,
                      onChanged: (value) {
                        authVM.callCompList(value);
                      },
                      margin: EdgeInsets.only(bottom: AppHeight(11)),
                    ),
                    CommonTextFormField(
                      label: 'Password'.tr(),
                      controller: authVM.passwordController,
                      // onChanged: (value) => viewModel.updatePassword(value),
                      obscureText: true,
                      isBorderUnderLine: false,
                      suffixIcon: true,
                      margin: EdgeInsets.only(bottom: AppHeight(11)),
                    ),
                    lVM.allCompDataList.isNotEmpty
                        ? CommonInkWell(
                            onTap: () {
                              showCompList(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: AppHeight(11)),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        right:
                                            Global.isArabic ? 0 : AppWidth(10),
                                        left:
                                            Global.isArabic ? AppWidth(10) : 0),
                                    padding: const EdgeInsets.only(
                                        left: 2.0, right: 2.0),
                                    decoration: BoxDecoration(
                                      color: context
                                          .resources.color.colorLightGrey,
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: lVM.singleCompData!.compLogo
                                          .toString(),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height: AppHeight(30),
                                        width: AppWidth(30),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fitWidth),
                                        ),
                                      ),
                                      progressIndicatorBuilder:
                                          (context, url, progress) => SizedBox(
                                        height: AppHeight(30),
                                        width: AppWidth(30),
                                        child: const Icon(
                                          Icons.photo,
                                          size: 15,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          SizedBox(
                                              height: AppHeight(30),
                                              width: AppWidth(30),
                                              child: const Icon(
                                                Icons.photo,
                                                size: 15,
                                              )),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: CommonTextView(
                                      label: lVM.singleCompData!.compName
                                          .toString(),
                                      fontSize: context
                                          .resources.dimension.appBigText,
                                      margin: EdgeInsets.only(
                                          right: Global.isArabic
                                              ? 0
                                              : AppWidth(10),
                                          left: Global.isArabic
                                              ? AppWidth(10)
                                              : 0),
                                      overFlow: TextOverflow.ellipsis,
                                      maxLine: 1,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: SvgPicture.asset(
                                        'assets/images/erp_app_icon/correct.svg',
                                        height: AppHeight(15),
                                        width: AppWidth(15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    /*CommonInkWell(
                      onTap: () {
                        if (authVM.userNameController.text.toString().isEmpty) {
                          AppUtils.showToastRedBg(context, 'plzEnterUserName'.tr());
                        } else if (authVM.userNameController.text.toString().length<6) {
                          AppUtils.showToastRedBg(
                              context, 'User id should be 6 digits'.tr());
                        }else {
                          lVM.callCompanyApiOnLabelClick();
                          showCompList(context);
                      }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: AppHeight(11)),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: Global.isArabic?0:AppWidth(10),left: Global.isArabic?AppWidth(10):0),
                              padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                              decoration: BoxDecoration(color: context.resources.color.colorLightGrey, borderRadius: BorderRadius.circular(2.0),),
                              child: CachedNetworkImage(
                                imageUrl: lVM.singleCompData!=null?lVM.singleCompData!.compLogo.toString():'',
                                imageBuilder: (context, imageProvider) => Container(height: AppHeight(30), width: AppWidth(30), decoration: BoxDecoration(shape: BoxShape.rectangle, image: DecorationImage(image: imageProvider, fit: BoxFit.fitWidth),),),
                                progressIndicatorBuilder: (context, url, progress) => SizedBox(height: AppHeight(30), width: AppWidth(30), child: const Icon(Icons.photo, size: 15,),),
                                errorWidget: (context, url, error) => SizedBox(height: AppHeight(30), width: AppWidth(30), child: const Icon(Icons.photo, size: 15,)),
                              ),
                            ),
                            Expanded(flex: 1,
                              child: CommonTextView(
                                label: lVM.singleCompData!=null?lVM.singleCompData!.compName.toString():'Select Company Name',
                                fontSize: context.resources.dimension.appBigText,
                                margin: EdgeInsets.only(right: Global.isArabic?0:AppWidth(10),left: Global.isArabic?AppWidth(10):0),
                                overFlow: TextOverflow.ellipsis,
                                maxLine: 1,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.keyboard_arrow_down_outlined,color: context.resources.color.themeColor,size: 25,),
                            ),
                          ],
                        ),
                      ),
                    ),*/
                    GestureDetector(
                      onTap: () {
                        lVM.isRemember = !lVM.isRemember;
                        lVM.setIsRemember(lVM.isRemember);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: AppHeight(20)),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  right: Global.isArabic
                                      ? AppWidth(5)
                                      : AppWidth(10),
                                  left: Global.isArabic
                                      ? AppWidth(10)
                                      : AppWidth(5)),
                              height: 25,
                              width: 25,
                              child: Icon(
                                lVM.isRemember
                                    ? Icons.check_box_outlined
                                    : Icons.check_box_outline_blank,
                                color: context.resources.color.themeColor,
                              ),
                            ),
                            CommonTextView(
                              label: 'Remember Me'.tr(),
                              fontSize: context.resources.dimension.appBigText,
                              margin: EdgeInsets.only(
                                  right: Global.isArabic
                                      ? AppWidth(5)
                                      : AppWidth(10),
                                  left: Global.isArabic
                                      ? AppWidth(10)
                                      : AppWidth(5)),
                              color: context.resources.color.defaultMediumGrey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: AppHeight(20)),
                        child: AnimatedButton(
                            text: 'login'.tr(),
                            disable: lVM.isdisable ? true : false,
                            onPressed: () {
                              authVM.callLoginApi(context);
                            }),
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: Center(
                        child: CommonTextView(
                          label: 'Forgot your password?'.tr(),
                          // padding: const EdgeInsets.all(8.0),
                          fontSize: context.resources.dimension.appBigText,
                          color: context.resources.color.themeColor,
                          fontFamily: 'Bold',
                          onTap: () {
                            // Navigator.pushNamed(context, HomeScreen.id);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: lVM.allCompDataList.isNotEmpty
                          ? AppHeight(90)
                          : AppHeight(120),
                    ),
                    Center(
                      child: CommonTextView(
                        label: 'tryAnother'.tr(),
                        fontSize: context.resources.dimension.appBigText,
                        color: context.resources.color.themeColor,
                        fontFamily: 'Bold',
                        onTap: () {
                          Navigator.pushNamed(
                              context, CompanyIdActivationPage.id);
                        },
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // void showCompList() {
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (BuildContext context) {
  //         return FractionallySizedBox(
  //           heightFactor: 0.5,
  //           child: StatefulBuilder(
  //               builder: (BuildContext context, StateSetter myState) {
  //             return Scaffold(
  //               appBar: AppBar(
  //                 centerTitle: true,
  //                 backgroundColor: context.resources.color.themeColor,
  //                 title: CommonTextView(label: 'Company List', color: context.resources.color.colorWhite,),
  //                 actions: [IconButton(icon: Icon(Icons.close, size: 25.0, color: context.resources.color.colorWhite,), onPressed: () {Navigator.pop(context);},)],
  //                 leading: const SizedBox(),
  //               ),
  //               body: Column(
  //                 children: [
  //                   Expanded(
  //                     flex: 1,
  //                     child: ListView.builder(
  //                       itemCount: authVM.allCompDataList.length,
  //                       scrollDirection: Axis.vertical,
  //                       shrinkWrap: true,
  //                       itemBuilder: (context, index) {
  //                         return CommonInkWell(
  //                           onTap: () {
  //                             Navigator.pop(context);
  //                             authVM.setCompanyData(authVM.allCompDataList[index]);
  //                           },
  //                           child: Container(
  //                               width: double.infinity,
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Row(
  //                                 children: [
  //                                   Container(
  //                                     margin: const EdgeInsets.only(left: 5.5),
  //                                     padding: const EdgeInsets.only(left: 2.0, right: 2.0),
  //                                     width: 30.0,
  //                                     height: 15.0,
  //                                     decoration: BoxDecoration(
  //                                       color: context.resources.color.colorLightGrey,
  //                                       borderRadius: BorderRadius.circular(2.0), // Adjust the radius as needed
  //                                     ),
  //                                     child: CachedNetworkImage(
  //                                       imageUrl: authVM.allCompDataList[index].compLogo.toString(),
  //                                       imageBuilder: (context, imageProvider) => Container(
  //                                             width: 30.0,
  //                                             height: 15.0,
  //                                             decoration: BoxDecoration(
  //                                               shape: BoxShape.rectangle,
  //                                               image: DecorationImage(image: imageProvider, fit: BoxFit.fitWidth),
  //                                             ),
  //                                           ),
  //                                       progressIndicatorBuilder: (context, url, progress) => const SizedBox(
  //                                             width: 30.0,
  //                                             height: 15.0,
  //                                             child: Icon(Icons.photo, size: 15,),
  //                                       ),
  //                                       errorWidget: (context, url, error) =>
  //                                           const SizedBox(
  //                                               width: 30.0,
  //                                               height: 15.0,
  //                                               child: Icon(Icons.photo, size: 15,)),
  //                                     ),
  //                                   ),
  //                                   Expanded(
  //                                       flex: 1,
  //                                       child: Padding(
  //                                         padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0),
  //                                         child: CommonTextView(label: authVM.allCompDataList[index].compName.toString(), fontSize: 14.0,),
  //                                       )),
  //                                 ],
  //                               )),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }),
  //         );
  //       });
  // }

  void showCompList(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        // isDismissible: false,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {},
            child: FractionallySizedBox(
              heightFactor: 0.47,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter myState) {
                return ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  child: Consumer<AuthVM>(
                    builder: (context, authVM, child) {
                      return Scaffold(
                        appBar: AppBar(
                          centerTitle: true,
                          backgroundColor: context.resources.color.themeColor,
                          title: CommonTextView(
                            label: 'CompanyList'.tr(),
                            color: context.resources.color.colorWhite,
                          ),
                          actions: [
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 25.0,
                                color: context.resources.color.colorWhite,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                          leading: const SizedBox(),
                        ),
                        body: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ListView.builder(
                                itemCount: authVM.allCompDataList.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return CommonInkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      authVM.setCompanyData(
                                          authVM.allCompDataList[index]);
                                    },
                                    child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5.5),
                                              padding: const EdgeInsets.only(
                                                  left: 2.0, right: 2.0),
                                              width: 30.0,
                                              height: 15.0,
                                              decoration: BoxDecoration(
                                                color: context.resources.color
                                                    .colorLightGrey,
                                                borderRadius: BorderRadius.circular(
                                                    2.0), // Adjust the radius as needed
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: authVM
                                                    .allCompDataList[index]
                                                    .compLogo
                                                    .toString(),
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  width: 30.0,
                                                  height: 15.0,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fitWidth),
                                                  ),
                                                ),
                                                progressIndicatorBuilder:
                                                    (context, url, progress) =>
                                                        const SizedBox(
                                                  width: 30.0,
                                                  height: 15.0,
                                                  child: Icon(
                                                    Icons.photo,
                                                    size: 15,
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const SizedBox(
                                                            width: 30.0,
                                                            height: 15.0,
                                                            child: Icon(
                                                              Icons.photo,
                                                              size: 15,
                                                            )),
                                              ),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0,
                                                          right: 5.0,
                                                          top: 2.0),
                                                  child: CommonTextView(
                                                    label: authVM
                                                        .allCompDataList[index]
                                                        .compName
                                                        .toString(),
                                                    fontSize: 14.0,
                                                  ),
                                                )),
                                          ],
                                        )),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          );
        });
  }
}
