// ignore_for_file: constant_identifier_names, library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Profile_Settings_Pages/digital_documents.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Profile_Settings_Pages/my_account_details.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Profile_Settings_Pages/my_account_page.dart';
import 'package:petty_cash/view/bottom_navigation_pages/Profile_Settings_Pages/user_profile.dart';
import 'package:petty_cash/view/po_transaction/po_transaction.dart';
import 'package:petty_cash/view/widget/CustomAppBar.dart';
import 'package:petty_cash/view/widget/logout_bottom_sheet_widget.dart';
import 'package:petty_cash/view_model/Authentication/AuthVM.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserStatus {
  Available,
  Busy,
  DoNotDisturb,
  BeRightBack,
  AppearAway,
  AppearOffline,
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

AuthVM lVM = AuthVM();

class _ProfilePageState extends State<ProfilePage> {
  UserStatus status = UserStatus.Available;
  final LocalAuthentication auth = LocalAuthentication();
  bool _isBiometricAvailable = false;
  bool _isBiometricEnabled = false;

  final Map<UserStatus, String> _statusText = {
    UserStatus.Available: 'Available',
    UserStatus.Busy: 'Busy',
    UserStatus.DoNotDisturb: 'Do not disturb',
    UserStatus.BeRightBack: 'Be right back',
    UserStatus.AppearAway: 'Appear away',
    UserStatus.AppearOffline: 'Appear offline',
  };

  final Map<String, IconData> _listTileData = {
    'Available': Icons.person,
    'My Account Details': Icons.settings,
    'User Profile': Icons.account_balance,
    'Digital Documents': Icons.document_scanner_rounded,
    'Change Password': Icons.lock,
    'Register MPIN': Icons.app_registration,
    'Setting And Privacy': Icons.settings,
    'Help & Support': Icons.support,
    'Feedback': Icons.feedback,
    'Activate Biometrics': Icons.fingerprint,
    'Sign Out': Icons.logout,
  };

  @override
  void initState() {
    lVM = Provider.of(context, listen: false);
    _checkBiometricAvailability();
    _loadBiometricStatus();
    _checkBiometricAvailability();
    super.initState();
  }

  Future<void> _checkBiometricAvailability() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    setState(() {
      _isBiometricAvailable = canCheckBiometrics;
    });
  }

  Future<void> _loadBiometricStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBiometricEnabled = prefs.getBool('isBiometricEnabled') ?? false;
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _clearSharedPreferences();
    }
  }

  Future<void> _clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("Shared Preferences Cleared!");
  }

  Future<void> _saveBiometricStatus(bool isEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isBiometricEnabled', isEnabled);
  }

  void _showStatusOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusOption(UserStatus.Available),
              _buildStatusOption(UserStatus.Busy),
              _buildStatusOption(UserStatus.DoNotDisturb),
              _buildStatusOption(UserStatus.BeRightBack),
              _buildStatusOption(UserStatus.AppearAway),
              _buildStatusOption(UserStatus.AppearOffline),
            ],
          ),
        );
      },
    );
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to activate biometrics',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        setState(() {
          _isBiometricEnabled = true;
        });
        _saveBiometricStatus(true);
        AppUtils.showToastGreenBg(
            context, "Biometric authentication activated successfully.");

        bool hasFingerprint =
            availableBiometrics.contains(BiometricType.fingerprint);

        if (hasFingerprint) {
          _showBiometricSuggestion(
              "Fingerprint recognition is available. Would you like to enable it?");
        }
      } else {
        AppUtils.showToastRedBg(context, "Biometric authentication failed.");
      }
    } catch (e) {
      print("Error during biometric authentication: $e");
      AppUtils.showToastRedBg(
          context, "Error during biometric authentication.");
    }
  }

  void _showBiometricSuggestion(String message) {
    AppUtils.yesNoDialog(
      context,
      "Additional Biometric Option",
      message,
      onYes: () {
        Navigator.of(context).pop();
      },
    );
  }

  void _showDeactivateBiometricsDialog() {
    AppUtils.yesNoDialog(
      context,
      "Deactivate Biometrics",
      "Are you sure you want to deactivate biometric authentication?",
      onYes: () {
        setState(() {
          _isBiometricEnabled = false;
        });
        _saveBiometricStatus(false);
        AppUtils.showToastGreenBg(
          context,
          "Biometric authentication deactivated successfully.",
        );
      },
    );
  }

  Widget _buildStatusOption(UserStatus option) {
    String text = _statusText[option] ?? '';
    Color indicatorColor = _getStatusIndicatorColor(option);

    return ListTile(
      title: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            margin: EdgeInsets.only(right: AppWidth(8)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: indicatorColor,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: option == status ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
      onTap: () {
        setState(() {
          status = option;
        });
        Navigator.pop(context);
      },
    );
  }

  Color _getStatusIndicatorColor(UserStatus option) {
    switch (option) {
      case UserStatus.Available:
        return Colors.green;
      case UserStatus.Busy:
        return Colors.red;
      case UserStatus.DoNotDisturb:
        return Colors.orange;
      case UserStatus.BeRightBack:
        return Colors.yellow;
      case UserStatus.AppearAway:
        return Colors.blue;
      case UserStatus.AppearOffline:
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onTap: () {
          Navigator.pushNamed(context, MyAccount.id);
        },
        isSpace: true,
      ),
      body: ListView(
        children: _listTileData.keys.map((String text) {
          if (text == 'Available') {
            return ListTile(
              leading: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    left: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: status == UserStatus.Available
                            ? Colors.green
                            : status == UserStatus.Busy
                                ? Colors.red
                                : Colors.orange,
                      ),
                    ),
                  ),
                  Icon(
                    _listTileData[text],
                    color: Colors.black,
                  ),
                ],
              ),
              title: InkWell(
                onTap: () {
                  _showStatusOptions(context);
                },
                child: Text(
                  _statusText[status] ?? '',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            );
          } else if (text == 'Activate Biometrics') {
            return ListTile(
              leading: Icon(_listTileData[text]),
              title: Text(
                _isBiometricEnabled
                    ? "Deactivate Biometrics"
                    : "Activate Biometrics",
              ),
              onTap: () async {
                if (_isBiometricAvailable) {
                  if (_isBiometricEnabled) {
                    _showDeactivateBiometricsDialog();
                  } else {
                    await _authenticateWithBiometrics();
                  }
                } else {
                  AppUtils.showToastRedBg(
                    context,
                    "Biometric authentication not available on this device.",
                  );
                }
              },
            );
          } else {
            return ListTile(
              leading: Icon(_listTileData[text]),
              title: Text(text),
              onTap: () {
                if (text == 'Sign Out') {
                  didChangeAppLifecycleState(AppLifecycleState.paused);
                  _showLogoutBottomSheet(context);
                  // AppUtils.yesNoDialog(
                  //   context,
                  //   'confirmation'.tr(),
                  //   'log_off_confirmation'.tr(),
                  //   onYes: () {
                  //     didChangeAppLifecycleState(AppLifecycleState.paused);
                  //     lVM.logout(context);
                  //   },
                  // );
                } else if (text == 'My Account Details') {
                  Navigator.pushNamed(context, MyAccountDetails.id);
                } else if (text == 'User Profile') {
                  Navigator.pushNamed(context, UserProfile.id);
                } else if (text == 'Digital Documents') {
                  // Navigate to the Digital Documents page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DigitalDocuments(),
                    ),
                  );
                } else if (text == 'Register MPIN') {
                  Navigator.pushNamed(context, PoTransaction.id);
                } else if (text == 'Change Password' ||
                    // text == 'Register MPIN' ||
                    text == 'Setting And Privacy' ||
                    text == 'Feedback' ||
                    text == 'Help & Support') {
                  AppUtils.showToastGreenBg(
                      context, " This Page in Under Development.");
                }
              },
            );
          }
        }).toList(),
      ),
    );
  }

  void _showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const LogoutBottomSheetWidget(),
    );
  }
}
