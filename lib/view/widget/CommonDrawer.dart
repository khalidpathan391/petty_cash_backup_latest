// ignore_for_file: unused_import, unnecessary_import, prefer_const_constructors, sort_child_properties_last, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petty_cash/data/models/HomePage/MenuResponse.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/widget/CommonInkWell.dart';
import 'package:petty_cash/view/widget/common_shimmer_view.dart';
import 'package:petty_cash/view/widget/common_text.dart';
import 'package:petty_cash/view/widget/erp_text_field.dart';
import 'package:petty_cash/view_model/HomePage/HomeMainVM.dart';
import 'package:provider/provider.dart';

class CommonDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final HomeMainVM menuList;
  final Function(Menu) onMenuItemClick;

  const CommonDrawer({
    Key? key,
    required this.scaffoldKey,
    required this.menuList,
    required this.onMenuItemClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: double.infinity,
        child: Consumer<HomeMainVM>(
          builder: (context, cdVm, _) {
            return Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  color: context.resources.color.themeColor,
                  child: Row(
                    children: [
                      Expanded(
                        child: CommonTextView(
                          label: 'Menu List',
                          padding: EdgeInsets.only(left: 10.0),
                          color: context.resources.color.colorWhite,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (scaffoldKey.currentState!.isDrawerOpen) {
                            scaffoldKey.currentState!.openEndDrawer();
                          }
                        },
                        icon: Icon(
                          Icons.close,
                          color: context.resources.color.colorWhite,
                        ),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(bottom: 5.0),
                ),
                CommonTextFormField(
                  label: 'Search Here...',
                  controller: cdVm.searchController,
                  onChanged: cdVm.filterMenuList,
                  height: 40.0,
                  margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Expanded(
                  child: cdVm.isMenuApiCalling
                      ? const CommonShimmerView(
                          numberOfRow: 30,
                          shimmerViewType: ShimmerViewType.SIDE_MENU,
                        )
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: cdVm.filteredMenuList.length,
                          itemBuilder: (context, index) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CommonInkWell(
                                    onTap: () {
                                      if (cdVm.filteredMenuList[index].child
                                          .isNotEmpty) {
                                        if (cdVm.filteredMenuList[index]
                                            .isShowing) {
                                          cdVm.filteredMenuList[index]
                                              .isShowing = false;
                                        } else {
                                          cdVm.filteredMenuList[index]
                                              .isShowing = true;
                                        }
                                        cdVm.refreshMenu();
                                      } else {
                                        if (cdVm.filteredMenuList[index]
                                                .displayMobileApp ==
                                            0) {
                                          if (scaffoldKey
                                              .currentState!.isDrawerOpen) {
                                            scaffoldKey.currentState!
                                                .openEndDrawer();
                                          }
                                          onMenuItemClick(
                                              cdVm.filteredMenuList[index]);
                                        } else {
                                          AppUtils.showToastRedBg(
                                              context, "Page not developed");
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 12,
                                          bottom: 12),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.red.withOpacity(0.2),
                                            width: 1.0,
                                          ),
                                        ),
                                        color: context
                                            .resources.color.themeColor
                                            .withOpacity(0.7),
                                      ),
                                      child: Row(
                                        children: [
                                          cdVm.filteredMenuList[index].menuIcon
                                                  .isNotEmpty
                                              ? SvgPicture.network(
                                                  'https://erp.sendan.com.sa:8080${cdVm.filteredMenuList[index].menuIcon}',
                                                  width: 16,
                                                  height: 16,
                                                )
                                              : const Icon(
                                                  Icons.bookmark_outline,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: CommonTextView(
                                              label: cdVm
                                                      .filteredMenuList[index]
                                                      .title +
                                                  ((cdVm.filteredMenuList[index]
                                                          .txnCode.isNotEmpty)
                                                      ? " - ${cdVm.filteredMenuList[index].txnCode}"
                                                      : ''),
                                              fontSize: context.resources
                                                      .dimension.appBigText +
                                                  1,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Visibility(
                                              visible: cdVm
                                                  .filteredMenuList[index]
                                                  .child
                                                  .isNotEmpty,
                                              child: Icon(
                                                cdVm.filteredMenuList[index]
                                                        .isShowing
                                                    ? Icons.remove
                                                    : Icons.add,
                                                size: 20,
                                                color: Colors.black,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                      visible: cdVm.filteredMenuList[index]
                                              .child.isNotEmpty &&
                                          cdVm.filteredMenuList[index]
                                              .isShowing,
                                      child: buildSubMenuList(
                                          cdVm.filteredMenuList[index].child,
                                          cdVm))
                                ]);
                          },
                        ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildSubMenuList(List<Menu> subMenu, HomeMainVM cdVm) {
    if (subMenu.isEmpty) {
      return SizedBox();
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: subMenu.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonInkWell(
                onTap: () {
                  if (subMenu[index].child.isNotEmpty) {
                    if (subMenu[index].isShowing) {
                      subMenu[index].isShowing = false;
                    } else {
                      subMenu[index].isShowing = true;
                    }
                    cdVm.refreshMenu();
                  } else {
                    if (subMenu[index].displayMobileApp == 0) {
                      if (scaffoldKey.currentState!.isDrawerOpen) {
                        scaffoldKey.currentState!.openEndDrawer();
                      }
                      onMenuItemClick(subMenu[index]);
                    } else {
                      AppUtils.showToastRedBg(context, "Page not developed");
                    }
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                      left: 14.0, right: 7.0, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.red.withOpacity(0.2),
                        width: 1.0, // specify the width of the border
                      ),
                    ),
                    color: context.resources.color.themeColor.withOpacity(0.4),
                  ),
                  child: Row(
                    children: [
                      subMenu[index].menuIcon.isNotEmpty
                          ? SvgPicture.network(
                              'https://erp.sendan.com.sa:8080${subMenu[index].menuIcon}',
                              width: 14,
                              height: 14,
                            )
                          : Icon(
                              Icons.bookmark_outline,
                              size: 14,
                              color: Colors.white,
                            ),
                      Expanded(
                        flex: 1,
                        child: CommonTextView(
                          label: subMenu[index].title +
                              ((subMenu[index].txnCode.isNotEmpty)
                                  ? " - ${subMenu[index].txnCode}"
                                  : ''),
                          fontSize:
                              context.resources.dimension.appMediumText + 1,
                          color: Colors.black.withOpacity(0.8),
                          margin: const EdgeInsets.only(left: 5.0),
                        ),
                      ),
                      Visibility(
                          visible: subMenu[index].child.isNotEmpty,
                          child: Icon(
                            subMenu[index].isShowing ? Icons.remove : Icons.add,
                            size: 18,
                            color: Colors.black,
                          ))
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: subMenu[index].child.isNotEmpty &&
                      subMenu[index].isShowing,
                  child: buildSubSubMenuList(subMenu[index].child, cdVm))
            ]);
      },
    );
  }

  Widget buildSubSubMenuList(List<Menu> subSubMenu, HomeMainVM cdVm) {
    if (subSubMenu.isEmpty) {
      return const SizedBox();
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: subSubMenu.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonInkWell(
                onTap: () {
                  if (subSubMenu[index].child.isNotEmpty) {
                    if (subSubMenu[index].isShowing) {
                      subSubMenu[index].isShowing = false;
                    } else {
                      subSubMenu[index].isShowing = true;
                    }
                    cdVm.refreshMenu();
                  } else {
                    if (subSubMenu[index].displayMobileApp == 0) {
                      if (scaffoldKey.currentState!.isDrawerOpen) {
                        scaffoldKey.currentState!.openEndDrawer();
                      }
                      onMenuItemClick(subSubMenu[index]);
                    } else {
                      AppUtils.showToastRedBg(context, "Page not developed");
                    }
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                      left: 20, top: 7, bottom: 7, right: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.red.withOpacity(0.2),
                        width: 1.0, // specify the width of the border
                      ),
                    ),
                    color: context.resources.color.themeColor.withOpacity(0.2),
                  ),
                  child: Row(
                    children: [
                      subSubMenu[index].menuIcon.isNotEmpty
                          ? SvgPicture.network(
                              'https://erp.sendan.com.sa:8080${subSubMenu[index].menuIcon}',
                              width: 14,
                              height: 14,
                            )
                          : Icon(
                              Icons.file_copy_outlined,
                              size: 12,
                              color: Colors.white,
                            ),
                      Expanded(
                        flex: 1,
                        child: CommonTextView(
                          label: subSubMenu[index].title +
                              ((subSubMenu[index].txnCode.isNotEmpty)
                                  ? " - ${subSubMenu[index].txnCode}"
                                  : ''),
                          fontSize:
                              context.resources.dimension.appSmallText + 3,
                          color: Colors.black.withOpacity(0.8),
                          margin: const EdgeInsets.only(left: 5.0),
                        ),
                      ),
                      Visibility(
                          visible: subSubMenu[index].child.isNotEmpty,
                          child: Icon(
                            subSubMenu[index].isShowing
                                ? Icons.remove
                                : Icons.add,
                            size: 15,
                            color: Colors.black,
                          ))
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: subSubMenu[index].child.isNotEmpty &&
                      subSubMenu[index].isShowing,
                  child: buildSubSubSubMenuList(subSubMenu[index].child, cdVm))
            ]);
      },
    );
  }

  Widget buildSubSubSubMenuList(List<Menu> subSubSubMenu, HomeMainVM cdVm) {
    if (subSubSubMenu.isEmpty) {
      return const SizedBox();
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: subSubSubMenu.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  if (subSubSubMenu[index].child.isNotEmpty) {
                    if (subSubSubMenu[index].isShowing) {
                      subSubSubMenu[index].isShowing = false;
                    } else {
                      subSubSubMenu[index].isShowing = true;
                    }
                    cdVm.refreshMenu();
                  } else {
                    if (subSubSubMenu[index].displayMobileApp == 0) {
                      if (scaffoldKey.currentState!.isDrawerOpen) {
                        scaffoldKey.currentState!.openEndDrawer();
                      }
                      onMenuItemClick(subSubSubMenu[index]);
                    } else {
                      AppUtils.showToastRedBg(context, "Page not developed");
                    }
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                      bottom: 7, top: 7.0, left: 25.0, right: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.red.withOpacity(0.3),
                        width: 1.0, // specify the width of the border
                      ),
                    ),
                    color: context.resources.color.themeColor.withOpacity(0.1),
                  ),
                  child: Row(
                    children: [
                      subSubSubMenu[index].menuIcon.isNotEmpty
                          ? SvgPicture.network(
                              'https://erp.sendan.com.sa:8080${subSubSubMenu[index].menuIcon}',
                              width: 14,
                              height: 14,
                            )
                          : const Icon(
                              Icons.file_copy_outlined,
                              size: 12,
                              color: Colors.white,
                            ),
                      Expanded(
                        flex: 1,
                        child: CommonTextView(
                          label: subSubSubMenu[index].title +
                              ((subSubSubMenu[index].txnCode.isNotEmpty)
                                  ? " - ${subSubSubMenu[index].txnCode}"
                                  : ''),
                          fontSize: context.resources.dimension.appSmallText,
                          color: Colors.black.withOpacity(0.8),
                          margin: const EdgeInsets.only(left: 5.0),
                        ),
                      ),
                      Visibility(
                          visible: subSubSubMenu[index].child.isNotEmpty,
                          child: Icon(
                            subSubSubMenu[index].isShowing
                                ? Icons.remove
                                : Icons.add,
                            size: 12,
                            color: Colors.black,
                          ))
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: subSubSubMenu[index].child.isNotEmpty &&
                      subSubSubMenu[index].isShowing,
                  child: buildSubSubSubSubMenuList(
                      subSubSubMenu[index].child, cdVm))
            ]);
      },
    );
  }

  Widget buildSubSubSubSubMenuList(List<Menu> subSubSubMenu, HomeMainVM cdVm) {
    if (subSubSubMenu.isEmpty) {
      return const SizedBox();
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: subSubSubMenu.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  if (subSubSubMenu[index].child.isNotEmpty) {
                    if (subSubSubMenu[index].isShowing) {
                      subSubSubMenu[index].isShowing = false;
                    } else {
                      subSubSubMenu[index].isShowing = true;
                    }
                    cdVm.refreshMenu();
                  } else {
                    if (subSubSubMenu[index].displayMobileApp == 0) {
                      if (scaffoldKey.currentState!.isDrawerOpen) {
                        scaffoldKey.currentState!.openEndDrawer();
                      }
                      onMenuItemClick(subSubSubMenu[index]);
                    } else {
                      AppUtils.showToastRedBg(context, "Page not developed");
                    }
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.only(bottom: 7, top: 7.0, left: 30.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.red.withOpacity(0.3),
                        width: 1.0, // specify the width of the border
                      ),
                    ),
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  child: Row(
                    children: [
                      subSubSubMenu[index].menuIcon.isNotEmpty
                          ? SvgPicture.network(
                              'https://erp.sendan.com.sa:8080${subSubSubMenu[index].menuIcon}',
                              width: 14,
                              height: 14,
                            )
                          : const Icon(
                              Icons.file_copy_outlined,
                              size: 12,
                              color: Colors.white,
                            ),
                      CommonTextView(
                        label: subSubSubMenu[index].title +
                            ((subSubSubMenu[index].txnCode.isNotEmpty)
                                ? " - ${subSubSubMenu[index].txnCode}"
                                : ''),
                        fontSize: context.resources.dimension.appSmallText,
                        color: Colors.black.withOpacity(0.8),
                        margin: const EdgeInsets.only(left: 5.0),
                      )
                    ],
                  ),
                ),
              )
              //buildSubSubMenuList(subMenu[index].child)
            ]);
      },
    );
  }
}
