import 'package:cached_network_image/cached_network_image.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Profile_Settings_Pages/my_account_page.dart';
import 'package:petty_cash/view/widget/CommonInkWell.dart';
import 'package:petty_cash/view/widget/CustomAppBar.dart';
import 'package:petty_cash/view/widget/common_shimmer_view.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view_model/company/CompanyVM.dart';
import 'package:provider/provider.dart';

class CompanyPage extends StatefulWidget {
  @override
  _CompanyPageState createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage>
    implements DialogClickListener {
  CompanyVM companyVM = CompanyVM();

  @override
  void initState() {
    companyVM = Provider.of(context, listen: false);
    companyVM.callCompanyListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        onTap: () {
          Navigator.pushNamed(context, MyAccount.id);
        },
        isSpace: true,
      ),
      body: Consumer<CompanyVM>(builder: (context, lVM, widget) {
        return lVM.isLoading
            ? const CommonShimmerView(
                numberOfRow: 25,
                shimmerViewType: ShimmerViewType.SIDE_MENU,
              )
            : AppUtils.errorMessage.isNotEmpty
                ? Center(
                    child: AppUtils(context).getCommonErrorWidget(() {
                    lVM.callTryAgain();
                  }, ''))
                : ListView.builder(
                    itemCount: lVM.allCompDataList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return CommonInkWell(
                        onTap: () {
                          if (lVM.allCompDataList[index].compId !=
                              Global.empData!.companyId) {
                            companyVM.companyId =
                                lVM.allCompDataList[index].compId!;
                            AppUtils.withListener(this, '', type: 0)
                                .confirmationYesNoDialog(
                                    context,
                                    "confirmation".tr(),
                                    "company_change_confirmation".tr());
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: context.resources.color.themeColor
                                      .withOpacity(0.2),
                                  width: 1.0, // specify the width of the border
                                ),
                              ),
                              color: context.resources.color.themeColor
                                  .withOpacity(0.0),
                            ),
                            width: double.infinity,
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 5.5),
                                  padding: const EdgeInsets.only(
                                      left: 2.0, right: 2.0),
                                  width: 30.0,
                                  height: 15.0,
                                  decoration: BoxDecoration(
                                    color:
                                        context.resources.color.colorLightGrey,
                                    borderRadius: BorderRadius.circular(
                                        2.0), // Adjust the radius as needed
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: lVM
                                        .allCompDataList[index].compLogo
                                        .toString(),
                                    imageBuilder: (context, imageProvider) =>
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
                                    errorWidget: (context, url, error) =>
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
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0, top: 2.0),
                                      child: CommonTextView(
                                        label: lVM
                                            .allCompDataList[index].compName
                                            .toString(),
                                        fontSize: 14.0,
                                      ),
                                    )),
                                (lVM.allCompDataList[index].compId ==
                                        Global.empData!.companyId)
                                    ? Icon(
                                        Icons.check,
                                        color:
                                            context.resources.color.themeColor,
                                        size: 16,
                                      )
                                    : const SizedBox()
                              ],
                            )),
                      );
                    },
                  );
      }),
    );
  }

  @override
  void clickOnNo(int type, dynamic provider) {}

  @override
  void clickOnYes(int type, dynamic provider) {
    companyVM.callChangeCompany();
  }
}
