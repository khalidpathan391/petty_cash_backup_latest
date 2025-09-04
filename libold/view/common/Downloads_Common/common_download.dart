// ignore_for_file: unused_import

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/widget/common_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:petty_cash/view/widget/common_text.dart';

class CommonDownload {
  /*CREATE TABLE `task` (
  `id`  INTEGER PRIMARY KEY AUTOINCREMENT,
  `task_id` VARCHAR ( 256 ),
  `url` TEXT,
  `status`  INTEGER DEFAULT 0,
  `progress`  INTEGER DEFAULT 0,
  `file_name` TEXT,
  `saved_dir` TEXT,
  `resumable` TINYINT DEFAULT 0,
  `headers` TEXT,
  `show_notification` TINYINT DEFAULT 0,
  `open_file_from_notification` TINYINT DEFAULT 0,
  `time_created`  INTEGER DEFAULT 0
);*/
  BuildContext context;
  RefreshListener? listener;

  CommonDownload(this.context, this.listener);

  void downloadFile(String url) async {
    if (await checkFileIsExist(url)) {
      confirmationYesNoDialog(
          context,
          'Confirmation!',
          'This file may have been downloaded multiple times. To overwrite, remove all files with the same name, keeping only one.',
          url);
    } else {
      _download(url);
    }
  }

  _download(String url) async {
    // Request storage permission if needed (Android)
    bool storageAllowed = await AppUtils.storagePermission();
    if (!storageAllowed) {
      return;
    }
    // Get the download directory
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    if (directory != null) {
      String savedDir = directory.path;
      await FlutterDownloader.enqueue(
        url: url,
        savedDir: savedDir,
        fileName: getUniqueFileName(url),
        showNotification: true,
        allowCellular: true,
        openFileFromNotification: true, // Click to open after download
      );
    }
  }

  String getUniqueFileName(String url) {
    Uri uri = Uri.parse(url);
    String fileName = uri.pathSegments.last;
    String nameWithoutExtension = fileName.split('.').first;
    String extension = fileName.split('.').last;
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    String newFileName = '${nameWithoutExtension}_$timestamp.$extension';
    return newFileName;
  }

  void copyTextToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text copied to clipboard')),
    );
  }

  String getDateTimeFromTimeStamp(int timestamp, String format) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = DateFormat(format).format(dateTime);
    return formattedDate;
  }

  Future<bool> checkFileIsExist(String url) async {
    List<DownloadTask>? dataDownloadedList =
        await FlutterDownloader.loadTasksWithRawQuery(
            query: 'SELECT * FROM task WHERE url="$url"');
    if (dataDownloadedList != null && dataDownloadedList.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> deleteFile(String url) async {
    List<DownloadTask>? dataDownloadedList =
        await FlutterDownloader.loadTasksWithRawQuery(
            query: 'SELECT * FROM task WHERE url="$url"');
    if (dataDownloadedList != null && dataDownloadedList.isNotEmpty) {
      for (int i = 0; i < dataDownloadedList.length; i++) {
        FlutterDownloader.remove(
            taskId: dataDownloadedList[i].taskId, shouldDeleteContent: false);
      }
    }
  }

  void confirmationYesNoDialog(
      BuildContext context, String title, String msg, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0), // Set the corner radius
          ),
          title: CommonTextView(
            label: title,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          content: CommonTextView(
            label: msg,
            fontSize: 15,
            color: Colors.black,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          // Adjust content padding
          actionsPadding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
          // Adjust actions padding
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CommonButton(
                  text: 'Overwrite',
                  textColor: Colors.white,
                  color: context.resources.color.secondaryColor,
                  onPressed: () async {
                    await deleteFile(url);
                    _download(url);
                    Navigator.pop(context);
                    listener!.refresh();
                  },
                  fontSize: 15,
                ),
                const SizedBox(
                  width: 10,
                ),
                CommonButton(
                  text: 'Copy',
                  textColor: Colors.white,
                  color: context.resources.color.themeColor,
                  onPressed: () {
                    _download(url);
                    Navigator.pop(context);
                    listener!.refresh();
                  },
                  fontSize: 15,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static Widget getNoDataFound(BuildContext context, String s) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
      child: Card(
        child: SizedBox(
          height: 200,
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(
                  Icons.download,
                  size: 100,
                ),
              ),
              Text(
                s,
                style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Gilroy-Light',
                    color: context.resources.color.colorBlack,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

abstract class RefreshListener {
  void refresh();
}
