// ignore_for_file: unused_local_variable, depend_on_referenced_packages, unused_import

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:petty_cash/data/models/common/common_transaction_models.dart';
import 'package:petty_cash/data/repository/general_rep.dart';
import 'package:petty_cash/globalSize.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/common/Downloads_Common/common_download.dart';
import 'package:petty_cash/view/common/Downloads_Common/common_download_any_file.dart';
import 'package:petty_cash/view/widget/common_text.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

import '../CustomLoaders/custom_refresh.dart';
// import 'package:file_saver/file_saver.dart';

class HeaderAttachmentWidget extends StatefulWidget {
  final VoidCallback onAttachment;
  final List<HeaderAttchLst> listData;
  final String pageDir;

  const HeaderAttachmentWidget({
    super.key,
    required this.themeColor,
    required this.onAttachment,
    required this.listData,
    required this.pageDir,
  });

  final Color themeColor;

  @override
  State<HeaderAttachmentWidget> createState() => _HeaderAttachmentWidgetState();
}

class _HeaderAttachmentWidgetState extends State<HeaderAttachmentWidget> {
  List<String> urlList = [];
  @override
  void initState() {
    super.initState();
  }

  //Not used
  void deleteLineId(int index) {}
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppHeight(40),
      padding: EdgeInsets.symmetric(horizontal: AppWidth(15)),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: CommonTextView(
              label: 'Attachments'.tr(),
              overFlow: TextOverflow.ellipsis,
              maxLine: 1,
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              children: [
                InkWell(
                  onTap: widget.onAttachment,
                  child: Icon(
                    Icons.attachment,
                    color: widget.themeColor,
                  ),
                ),
                if (widget.listData.isNotEmpty)
                  InkWell(
                    onTap: () {
                      urlList.clear();
                      String myUrl = '';
                      for (int i = 0; i < widget.listData.length; i++) {
                        myUrl =
                            '${ApiUrl.baseUrl}${widget.listData[i].docAttachUrl!.substring(1, widget.listData[i].docAttachUrl!.length)}';
                        urlList.add(myUrl);
                      }
                      showAttachmentBottomSheet(context, widget.listData,
                          urlList, widget.pageDir, deleteLineId);
                    },
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppWidth(10)),
                        child: Icon(
                          Icons.remove_red_eye,
                          color: widget.themeColor,
                        )),
                  ),
                if (widget.listData.isNotEmpty)
                  CommonTextView(
                    label: widget.listData.length.toString(),
                    color: widget.themeColor,
                    fontFamily: 'BoldItalic',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AttachmentBottomSheet extends StatelessWidget implements RefreshListener {
  final List<HeaderAttchLst> listData;
  final List<String> myUrlList;
  final String pageDir;
  final Function(int)? deleteLineAttachmentId;
  AttachmentBottomSheet(
      {Key? key,
      required this.listData,
      required this.myUrlList,
      required this.pageDir,
      this.deleteLineAttachmentId})
      : super(key: key);

  int getFileType(String url) {
    // url.endsWith('.mp4');
    // Extract the file extension from the URL
    String fileExtension = url.split('.').last.toLowerCase();

    // Use switch case to determine the file type
    switch (fileExtension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'heic':
        return 1; // Image type
      case 'mp4':
      case 'mov':
      case 'avi':
      case 'mkv':
        return 2; // Video type
      default:
        return 0; // Default type (non-image, non-video)
    }
  }

  final _myRepo = GeneralRepository();

  Future<bool> deleteAttachments(
      BuildContext context, String attachId, int index, dynamic myState) async {
    AppUtils.customLoader(context);
    bool isSuccess = await _myRepo.postApi(
        ApiUrl.baseUrl! + ApiUrl.commonDeleteAttachment,
        {'attach_id': attachId}).then((value) {
      if (value['error_code'] == 200) {
        AppUtils.showToastGreenBg(context, value['error_description']);
        listData.removeAt(index);
        //delete attachment_id for line items
        deleteLineAttachmentId?.call(index);
        Navigator.pop(context);
        return true;
      } else {
        AppUtils.showToastRedBg(context, value['error_description']);
        Navigator.pop(context);
      }
      return false;
    }).onError((error, stackTrace) {
      AppUtils.showToastRedBg(context, 'error: $error');
      Navigator.pop(context);
      return false;
    });
    // .whenComplete(()=>myState(() {}),);
    return isSuccess;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter myState) {
      return Container(
        padding: const EdgeInsets.all(16),
        // height: 400,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attachments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: CommonDownloadAnyFileList(
                urls: myUrlList,
                pageDir: pageDir,
                //don't call setState in delete functionality as its being called in deleteCallBack Already
                deleteFunctionality: (index) => deleteAttachments(context,
                    listData[index].docAttachId.toString(), index, myState),
                mandatoryQuery: (List<String> urlAll) async {
                  // Convert the list of URLs into a comma-separated string with single quotes
                  String urlList = urlAll.map((url) => '"$url"').join(', ');
                  // Construct the query
                  String query = 'SELECT * FROM task WHERE url IN ($urlList)';
                  return query;
                },
                childBuilder: (index, progressChild, deleteCallBack) {
                  final item = listData[index];
                  String url =
                      '${ApiUrl.baseUrl}${item.docAttachUrl!.substring(1, item.docAttachUrl!.length)}';
                  listData[index].type = getFileType(url);
                  listData[index].url = url;
                  int videoIndex = -1;
                  // if (listData[index].type == 2) {
                  //   videoIndex = setVideo(index, url);
                  // }
                  return GestureDetector(
                    // On Tap Action
                    onTap: () async {
                      //   if (listData[index].type == 1) {
                      //     // Show image in full screen
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => FullScreenImagePage(
                      //           imageUrl: url,
                      //           documentType: item.docType ?? 'Unknown',
                      //           documentTitle: item.docTitle ?? 'Untitled',
                      //         ),
                      //       ),
                      //     );
                      //   } else {
                      //     final Uri uri = Uri.parse(url);
                      //     if (!await launchUrl(uri)) {
                      //       throw Exception('Could not launch $url');
                      //     }
                      //   }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Media Preview (Image/Video/File Icon)
                          SizedBox(
                            width: AppWidthP(25),
                            child: item.type == 1
                                ? CachedNetworkImage(
                                    imageUrl: url,
                                    width: AppWidthP(25),
                                    // fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const CustomLoader(
                                      index: 2,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error,
                                      size: 50,
                                    ),
                                  )
                                : item.type == 2
                                    ? SizedBox()
                                    // VideoItem(
                                    //     index: videoIndex,
                                    //     loadHeight: 50,
                                    //     width: AppWidthP(25),
                                    //     type: 0, // For network
                                    //     doDispose: false,
                                    //   )
                                    : const Icon(
                                        Icons.insert_drive_file,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                          ),
                          const SizedBox(
                              width: 16), // Space between image and text

                          // Document Details (Title and Subtitle)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.docTitle ?? 'No Title',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.docType ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.url,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // Buttons (Download and Delete)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              progressChild,
                              // IconButton(
                              //   icon: const Icon(Icons.download, color: Colors.blue),
                              //   onPressed: () {
                              //     CommonDownload(context, this).downloadFile(url);
                              //   },
                              // ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  AppUtils.yesNoDialog(
                                      context,
                                      'Delete Attachment',
                                      'Are you sure you want to delete this attachment?',
                                      onYes: () {
                                    deleteCallBack();
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.link,
                                    color: Colors.blueAccent),
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: item.url));
                                  AppUtils.showToastGreenBg(
                                      context, 'Text copied to clipboard');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: listData.length,
            //     itemBuilder: (context, index) {
            //       final item = listData[index];
            //       String url = '${ApiUrl.baseUrl}${item.docAttachUrl!.substring(1, item.docAttachUrl!.length)}';
            //       listData[index].type = getFileType(url);
            //       listData[index].url = url;
            //       int videoIndex = -1;
            //       if(listData[index].type == 2) { videoIndex = setVideo(index, url); }
            //
            //       return GestureDetector(
            //         // On Tap Action
            //         onTap: () async {
            //           if (listData[index].type == 1) {
            //             // Show image in full screen
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) => FullScreenImagePage(
            //                   imageUrl: url,
            //                   documentType: item.docType ?? 'Unknown',
            //                   documentTitle: item.docTitle ?? 'Untitled',
            //                 ),
            //               ),
            //             );
            //           } else {
            //             final Uri uri = Uri.parse(url);
            //             if (!await launchUrl(uri)) {
            //               throw Exception('Could not launch $url');
            //             }
            //           }
            //         },
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            //           decoration: BoxDecoration(
            //             border: Border(
            //               bottom: BorderSide(color: Colors.grey.shade300),
            //             ),
            //           ),
            //           child: Row(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               // Media Preview (Image/Video/File Icon)
            //               SizedBox(
            //                 width: AppWidthP(25),
            //                 child: item.type == 1 ? CachedNetworkImage(
            //                   imageUrl: url,
            //                   width: AppWidthP(25),
            //                   // fit: BoxFit.cover,
            //                   placeholder: (context, url) => const CustomLoader(index: 2,),
            //                   errorWidget: (context, url, error) => const Icon(
            //                     Icons.error,
            //                     size: 50,
            //                   ),
            //                 ) : item.type == 2 ? VideoItem(
            //                   index: videoIndex,
            //                   loadHeight: 50,
            //                   width: AppWidthP(25),
            //                   type: 0, // For network
            //                   doDispose: false,
            //                 ) : const Icon(
            //                   Icons.insert_drive_file,
            //                   size: 50,
            //                   color: Colors.grey,
            //                 ),
            //               ),
            //               const SizedBox(width: 16), // Space between image and text
            //
            //               // Document Details (Title and Subtitle)
            //               Expanded(
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     item.docTitle ?? 'No Title',
            //                     style: const TextStyle(
            //                       fontSize: 16,
            //                       fontWeight: FontWeight.bold,
            //                       color: Colors.black87,
            //                     ),
            //                     overflow: TextOverflow.ellipsis,
            //                   ),
            //                   const SizedBox(height: 4),
            //                   Text(
            //                     item.docType ?? '',
            //                     style: const TextStyle(
            //                       fontSize: 14,
            //                       color: Colors.grey,
            //                     ),
            //                     overflow: TextOverflow.ellipsis,
            //                   ),
            //                   const SizedBox(height: 4),
            //                   Text(
            //                     item.url ?? '',
            //                     style: const TextStyle(
            //                       fontSize: 11,
            //                       color: Colors.grey,
            //                     ),
            //                     // overflow: TextOverflow.ellipsis,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //
            //               // Buttons (Download and Delete)
            //               Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   IconButton(
            //                     icon: const Icon(Icons.download, color: Colors.blue),
            //                     onPressed: () {
            //                       CommonDownload(context, this).downloadFile(url);
            //                     },
            //                   ),
            //                   IconButton(
            //                     icon: const Icon(Icons.delete, color: Colors.red),
            //                     onPressed: () {
            //                       AppUtils.yesNoDialog(
            //                           context,
            //                           'Delete Attachment',
            //                           'Are you sure you want to delete this attachment?',
            //                           onYes: (){
            //                             deleteAttachments(context,item.docAttachId.toString(),index,myState);
            //                           });
            //                     },
            //                   ),
            //                   IconButton(
            //                     icon: const Icon(Icons.link, color: Colors.blueAccent),
            //                     onPressed: () {
            //                       Clipboard.setData(ClipboardData(text: item.url));
            //                       AppUtils.showToastGreenBg(context, 'Text copied to clipboard');
            //                     },
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //       );
            //       //   ListTile(
            //       //   leading: isImage && !isVideo
            //       //       ? CachedNetworkImage(
            //       //           imageUrl: url,
            //       //           width: AppWidthP(25),
            //       //           placeholder: (context, url) =>
            //       //               const CircularProgressIndicator(),
            //       //           errorWidget: (context, url, error) =>
            //       //               const Icon(Icons.error),
            //       //         ):
            //       //   isVideo ? VideoItem(
            //       //     index: videoIndex,
            //       //     loadHeight: 50,
            //       //     width: AppWidthP(25),
            //       //     type:0,//for network
            //       //     doDispose: false,
            //       //   )
            //       //       : const Icon(Icons.insert_drive_file, size: 50, color: Colors.grey),
            //       //   title: Text(item.docTitle ?? 'No Title'),
            //       //   subtitle: Text(item.docType ?? ''),
            //       //   trailing: IconButton(
            //       //     icon: Icon(Icons.download),
            //       //     onPressed: () {
            //       //       CommonDownload(context, this).downloadFile(url);
            //       //       // downloadFile(
            //       //       //   context,
            //       //       //   url,
            //       //       //   '${item.docTitle}.jpg',
            //       //       // );
            //       //     },
            //       //   ),
            //       //   onTap: () async {
            //       //     if (isImage) {
            //       //       //if image show in full screen
            //       //       Navigator.push(
            //       //         context,
            //       //         MaterialPageRoute(
            //       //           builder: (context) => FullScreenImagePage(
            //       //             imageUrl: url,
            //       //             documentType: item.docType ?? 'Unknown',
            //       //             documentTitle: item.docTitle ?? 'Untitled',
            //       //           ),
            //       //         ),
            //       //       );
            //       //     } else {
            //       //       final Uri uri = Uri.parse(url);
            //       //       if (!await launchUrl(uri)) {
            //       //         throw Exception('Could not launch $url');
            //       //       }
            //       //     }
            //       //   },
            //       // );
            //     },
            //   ),
            // ),
          ],
        ),
      );
    });
  }

  @override
  void refresh() {}
}

// To display the bottom popup
void showAttachmentBottomSheet(
    BuildContext context,
    List<HeaderAttchLst> listData,
    List<String> myUrlList,
    String pageDir,
    Function(int) deleteLineAttachmentId) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return AttachmentBottomSheet(
        listData: listData,
        myUrlList: myUrlList,
        pageDir: pageDir,
        deleteLineAttachmentId: deleteLineAttachmentId,
      );
    },
  );
}

/*Future<void> downloadFile(BuildContext context,String url, String fileName) async {
  try {
    Dio dio = Dio();

    // Notify the user that the download has started
    AppUtils.showToastRedBg(context,"Downloading...");

    // Download the file as bytes
    Response response = await dio.get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
      onReceiveProgress: (received, total) {
        if (total != -1) {
          // Print progress in the console or show a progress bar
          print('${(received / total * 100).toStringAsFixed(0)}%');
        }
      }
    );

    // Convert the response data to Uint8List (required by file_saver)
    Uint8List fileBytes = Uint8List.fromList(response.data);

    // Call FileSaver to save the file in the selected location
    String? path = await FileSaver.instance.saveFile(
      name: fileName,// File name with extension
      bytes: fileBytes,
      ext: 'pdf',// File bytes
      mimeType: MimeType.pdf,
      // filePath:fileName.split('.').last, // File extension
    );

    if (path != null) {
      // Notify the user of successful download and save
      AppUtils.showToastGreenBg(context,"Download complete: $path");
    } else {
      // Notify the user if saving was canceled
      AppUtils.showToastRedBg(context,"Download canceled");
    }
  } catch (e) {
    // Handle any exceptions during the download and save process
    AppUtils.showToastRedBg(context,"Download failed: $e");
    print(e);
  }
}*/
// Future<void> downloadFile(BuildContext context,String url, String fileName) async {
//   try {
//     // Open a file picker for the user to select where to save the file
//     String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
//
//     if (selectedDirectory != null) {
//       String savePath = '$selectedDirectory/$fileName';
//
//       Dio dio = Dio();
//
//       // Show a toast that the download has started
//       AppUtils.showToastRedBg(context,"Downloading...");
//
//       // Download the file
//       await dio.download(url, savePath, onReceiveProgress: (received, total) {
//         if (total != -1) {
//           // Print progress in the console or show a progress bar
//           print('${(received / total * 100).toStringAsFixed(0)}%');
//         }
//       });
//
//       // Notify the user that the download is complete
//       AppUtils.showToastRedBg(context,"Download complete: $savePath");
//     } else {
//       // User canceled the directory selection
//       AppUtils.showToastRedBg(context,"Download canceled");
//     }
//   } catch (e) {
//     AppUtils.showToastRedBg(context,"Download failed: $e");
//     print(e);
//   }
// }

/*
Future<void> downloadFile(BuildContext context,String url, String fileName) async {
  try {
    // Open a file picker for the user to select where to save the file
    String? savePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Select the location to save the file',
      fileName: fileName,
    );
    if (savePath != null) {
      Dio dio = Dio();

      // Show a toast that the download has started
      AppUtils.showToastRedBg(context,"Downloading...");

      // Download the file
      await dio.download(url, savePath, onReceiveProgress: (received, total) {
        if (total != -1) {
          // Print progress in the console or show a progress bar
          print('${(received / total * 100).toStringAsFixed(0)}%');
        }
      });

      // Notify the user that the download is complete
      AppUtils.showToastRedBg(context,"Download complete: $savePath");
    } else {
      AppUtils.showToastRedBg(context,"Download canceled");
    }

  } catch (e) {
    AppUtils.showToastRedBg(context,"Download failed: $e");
    print(e);
  }
}
*/
Future<void> downloadFile(
    BuildContext context, String url, String fileName) async {
  Dio dio = Dio();
  try {
    // Step 1: Request storage permission (for Android)
    if (!await AppUtils.storagePermission()) {
      return;
    }
    // if (Platform.isAndroid) {
    //   if (await requestPermission()) {
    //     print('Storage permission granted.');
    //   } else {
    //     print('Storage permission denied.');
    //     return;
    //   }
    // }

    // Step 2: Get the directory to save the file
    // Directory? directory = await getDownloadDirectory()
    Directory? downloadDirectory = await getDownloadDirectory();
    if (downloadDirectory == null) {
      print('Could not access the directory.');
      return;
    }

    // String filePath = "${downloadDirectory.path}/$fileName";
    // //check if file already exists
    // File file = File(filePath);
    // String uniqueFileName = fileName;
    // int counter = 1;
    // bool whileTrue = await file.exists();
    // while(whileTrue){
    //   // Extract the base name and extension of the file
    //   String baseName = fileName.substring(0, fileName.lastIndexOf('.'));
    //   String extension = fileName.substring(fileName.lastIndexOf('.'));
    //
    //   // Append a number to the base name to make it unique
    //   uniqueFileName = "$baseName($counter)$extension";
    //   file = File("$downloadDirectory.path/$uniqueFileName");
    //   whileTrue = await file.exists();
    //   counter++;
    // }

    // while (file.existsSync()) {
    //   // Extract the base name and extension of the file
    //   String baseName = fileName.substring(0, fileName.lastIndexOf('.'));
    //   String extension = fileName.substring(fileName.lastIndexOf('.'));
    //
    //   // Append a number to the base name to make it unique
    //   uniqueFileName = "$baseName($counter)$extension";
    //   file = File("$downloadDirectory.path/$uniqueFileName");
    //   counter++;
    // }
    String uniqueFileName =
        await getUniqueFileNameWithTimestamp(downloadDirectory.path, fileName);

    // Full path of the file to be saved
    String filePath = "${downloadDirectory.path}/$uniqueFileName";

    // Step 3: Start downloading the file
    await dio.download(
      url,
      filePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print(
              "Download progress: ${(received / total * 100).toStringAsFixed(0)}%");
        }
      },
    );
    print(
        'File downloaded to: $filePath--------------------------------------------------------->');
  } catch (e) {
    print('Error downloading file: $e');
  }
}

// Get the download directory mandatory
Future<Directory?> getDownloadDirectory() async {
  // Directory _directory = Directory("dir");
  if (Platform.isAndroid) {
    // For Android, use external storage
    // return await getExternalStorageDirectory();
    return Directory("/storage/emulated/0/Download");
  } else if (Platform.isIOS) {
    // For iOS, use application documents directory
    return await getApplicationDocumentsDirectory();
  } else {
    return null;
  }
}
// Request storage permission for Android
// Future<bool> requestPermission() async {
//   if (await Permission.storage.isGranted) {
//     return true;
//   } else {
//     var result = await Permission.storage.request();
//     return result == PermissionStatus.granted;
//   }
// }

// Recursively check if the file exists and generate a unique filename
Future<String> getUniqueFileName(String directoryPath, String fileName,
    {int counter = 1}) async {
  // Construct the full file path
  String filePath = "$directoryPath/$fileName";
  File file = File(filePath);

  // Check if the file exists
  if (await file.exists()) {
    // If it exists, extract the base name and extension
    String baseName = fileName.substring(0, fileName.lastIndexOf('.'));
    String extension = fileName.substring(fileName.lastIndexOf('.'));

    // Append the counter to the base name to make it unique
    String uniqueFileName = "$baseName($counter)$extension";

    // Recursively call the function with an incremented counter
    return getUniqueFileName(directoryPath, uniqueFileName,
        counter: counter + 1);
  } else {
    // If the file does not exist, return the filename
    return fileName;
  }
}

Future<String> getUniqueFileNameWithTimestamp(
    String directoryPath, String fileName) async {
  // Extract the base name and extension of the file
  String baseName = fileName.substring(0, fileName.lastIndexOf('.'));
  String extension = fileName.substring(fileName.lastIndexOf('.'));

  // Get the current timestamp in a readable format (e.g., yyyyMMddHHmmss)
  String timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

  // Append the timestamp to the base name to make it unique
  String uniqueFileName = "$baseName-$timestamp$extension";

  return uniqueFileName;
}
