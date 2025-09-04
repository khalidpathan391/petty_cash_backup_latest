import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AppVersion extends StatelessWidget {
  static const String id = "app_version";
  final dynamic data;

  const AppVersion({super.key, required this.data});

  //ios
  final String appStoreUrl =
      "https://apps.apple.com/sa/app/crebri-erp/id6502387894";

  //android
  final String playStoreUrl =
      "https://play.google.com/store/apps/details?id=com.app.crebri_erp_app&hl=en";

  @override
  Widget build(BuildContext context) {
    Color themeColor = context.resources.color.themeColor;
    return Scaffold(
      backgroundColor: themeColor.withOpacity(.5),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.system_update,
                color: Colors.white,
                size: 100,
              ),
              const SizedBox(height: 20),
              Text(
                "UpdateAvailable".tr(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "UpdateDesc".tr(),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "${"latestVersion".tr()} : ${data.versionCode}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (Platform.isIOS) {
                        _launchURL(context, appStoreUrl);
                      } else {
                        _launchURL(context, playStoreUrl);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    child: Text(
                      "Update".tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  if (data.isMandatory == 0)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Ignore the update
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      child: Text(
                        "Ignore".tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      AppUtils.showToastRedBg(context, 'Could not launch $url');
      throw 'Could not launch $url';
    }
  }
}
