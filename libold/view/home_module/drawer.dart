import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/view/widget/common_button.dart';
import 'package:petty_cash/view/widget/common_text.dart';

import 'package:petty_cash/view/widget/logout_bottom_sheet_widget.dart';

import 'package:petty_cash/view_model/auth_vm/lead_authvm.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color themeColor = context.resources.color.themeColor;

    return Consumer<LeadAuthVm>(
      builder: (context, authVm, child) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Drawer(
            child: Container(
              decoration: BoxDecoration(color: themeColor),
              child: ListView(
                children: <Widget>[
                  const SizedBox(height: 50),
                  // FadeInLeft(
                  //   child: ListTile(
                  //     leading: CommonText(
                  //       label: Global.userData != null
                  //           ? Global.userData!.userName.toString()
                  //           : "UserName",
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize:
                  //           context.resources.dimension.appExtraBigText - 5,
                  //     ),
                  //   ),
                  // ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.home,
                    label: 'Home',
                    onTap: () => Navigator.pop(context),
                  ),

                  // _buildDrawerItem(
                  //   context: context,
                  //   icon: Icons.work,
                  //   label: 'Add Lead',
                  //   onTap: () => Navigator.pushNamed(context, 'add_lead'),
                  // ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.work,
                    label: 'Manager User',
                    onTap: () => Navigator.pushNamed(context, 'manage_user'),
                  ),

                  _buildDrawerItem(
                    context: context,
                    icon: Icons.work,
                    label: 'Dashboard ',
                    onTap: () => Navigator.pushNamed(context, 'd'),
                  ),
                  FadeInUp(
                    child: ListTile(
                      leading: const Icon(Icons.feedback, color: Colors.white),
                      title: CommonTextView(
                        label: 'About',
                        color: Colors.white,
                        fontSize: context.resources.dimension.appMediumText,
                      ),
                      onTap: () {
                        _showAboutDialog(context);
                      },
                    ),
                  ),
                  _buildDrawerItem(
                      context: context,
                      icon: Icons.logout,
                      label: 'Log Out',
                      onTap: () async {
                        _showLogoutBottomSheet(context);
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const LogoutBottomSheetWidget();
      },
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return FadeInUp(
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: CommonTextView(
          label: label,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: context.resources.dimension.appMediumText,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: CommonTextView(
          label: 'ABOUT THE ORGANIZATION',
          color: Colors.teal,
          fontWeight: FontWeight.bold,
          fontSize: context.resources.dimension.appMediumText,
          textAlign: TextAlign.center,
        ),
        content: CommonTextView(
          label: 'Khalid',
          color: Colors.black,
          fontSize: context.resources.dimension.appMediumText,
        ),
        actions: <Widget>[
          CommonButton(
            text: "Okay",
            onPressed: () => Navigator.of(ctx).pop(),
            color: Colors.teal,
            textColor: Colors.white,
            margin: const EdgeInsets.all(10),
          ),
        ],
      ),
    );
  }
}
