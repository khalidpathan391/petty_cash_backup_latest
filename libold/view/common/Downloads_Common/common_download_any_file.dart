import 'dart:isolate';
import 'dart:ui';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/common/CustomLoaders/custom_refresh.dart';
import 'package:petty_cash/view/widget/common_empty_list%20copy.dart';

class CommonDownloadAnyFileList extends StatefulWidget {
  final List<String> urls; // List of URLs to download
  final Widget Function(int index, Widget customChild, Function deleteCallback)
      childBuilder;
  final bool isScrollable;
  final EdgeInsets? listPadding;
  final Future<bool> Function(int) deleteFunctionality;
  final Future<String> Function(List<String> urls) mandatoryQuery;
  final String pageDir;

  const CommonDownloadAnyFileList({
    Key? key,
    required this.urls, // Required URLs
    required this.childBuilder, // Initialize the child builder function
    this.isScrollable = true,
    this.listPadding,
    required this.deleteFunctionality,
    required this.mandatoryQuery,
    required this.pageDir,
  }) : super(key: key);

  @override
  CommonDownloadAnyFileState createState() => CommonDownloadAnyFileState();
}

class CommonDownloadAnyFileState extends State<CommonDownloadAnyFileList>
    with AutomaticKeepAliveClientMixin {
  final ReceivePort _port = ReceivePort();
  Map<String, int> progressMap = {}; // Store progress for each task
  Map<String, String> taskMap =
      {}; // Maps the custom taskId to the actual download taskId
  List<String> taskIds = [];

  @override
  void initState() {
    loadData();
    super.initState();
    if (IsolateNameServer.lookupPortByName('downloader_send_port') == null) {
      IsolateNameServer.registerPortWithName(
          _port.sendPort, 'downloader_send_port');
      _port.listen((dynamic data) {
        String id = data[0];
        // int status = data[1];
        int progress = data[2];

        if (mounted) {
          progressMap[id] = progress;
          if (progress == 100) {
            // Step 1: Find the key corresponding to the 'id' in taskMap
            String taskKey = taskMap.keys.firstWhere(
              (key) => taskMap[key] == id,
              orElse: () => '', // Return null if not found
            );
            // Step 2: Find the index of the found taskKey in taskIds
            if (taskKey.isNotEmpty) {
              int index = taskIds.indexOf(taskKey);
              if (index != -1) {
                // Step 3: Change the status of downloaded task
                urlStatus![index] = DownloadTaskStatus.complete;
              }
            }
          }
          // Update progress for specific taskId
          setState(() {});
        }
      });
      FlutterDownloader.registerCallback(downloadCallback);
    }
  }

  List<DownloadTask>? dataDownloadedList = [];
  List<DownloadTaskStatus>? urlStatus = [];

  bool isLoaded = false;
  void loadData() async {
    isLoaded = false;
    setState(() {});
    urlStatus = []; // Initialize the urlStatus list to hold statuses
    taskIds = [];

    /*// Convert the list of URLs into a comma-separated string with single quotes
    String urlList = widget.urls.map((url) => '"$url"').join(', ');

    // Construct the query
    String query = 'SELECT * FROM task WHERE url IN ($urlList)';*/

    //fetch the query as per page requirement
    String query = await widget.mandatoryQuery(widget.urls);

    // Load tasks with the constructed query
    dataDownloadedList =
        await FlutterDownloader.loadTasksWithRawQuery(query: query);

    // Create a map to quickly access statuses by URL and taskId
    Map<String, DownloadTaskStatus> urlToStatusMap = {};
    Map<String, String> urlToTaskMap = {};

    // Populate the map with the downloaded tasks
    if (dataDownloadedList != null && dataDownloadedList!.isNotEmpty) {
      for (var task in dataDownloadedList!) {
        urlToStatusMap[task.url] = task.status; // Map URL to its status
        urlToTaskMap[task.url] = task.taskId; //Map URL to its TaskId
      }
    }

    // Iterate over widget.urls and populate urlStatus based on the map
    for (int i = 0; i < widget.urls.length; i++) {
      String url = widget.urls[i];
      //Making urls Status and TaskId
      if (urlToStatusMap.containsKey(url)) {
        urlStatus!.add(urlToStatusMap[url]!); // Add status if exists in map
        taskIds.add(urlToTaskMap[url]!); // Add taskId if exists in map
        //Adding it to my task map so the listener can listen to it
        taskMap[taskIds[i]] = taskIds[i];
      } else {
        urlStatus!.add(
            DownloadTaskStatus.undefined); // Add default status if not found
        taskIds.add(DateTime.now().toString() +
            i.toString()); // Add default taskId if not found
      }
    }

    isLoaded = true;
    setState(() {});
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  // Function to handle downloading the file
  Future<void> _download(String url, String taskId, int index) async {
    // Request storage permission if needed (Android)
    bool storageAllowed = await AppUtils.storagePermission();
    if (!storageAllowed) {
      return;
    }

    // Get the download directory
    Directory? directory;
    if (Platform.isAndroid) {
      // directory = Directory("/storage/emulated/0/Download");
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    if (directory != null) {
      String newPath = '${directory.path}/${widget.pageDir}';
      Directory newDirectory = Directory(newPath);
      if (!await newDirectory.exists()) {
        await newDirectory.create(recursive: true);
        print("Directory created at: ${newDirectory.path}");
      } else {
        print("Directory already exists at: ${newDirectory.path}");
      }

      String? newTaskId = await FlutterDownloader.enqueue(
        url: url,
        //only make this true if u are storing outside the app and
        // if u do store then many default functionality will not work for this download
        // saveInPublicStorage: true,
        savedDir: newDirectory.path,
        fileName: getUniqueFileName(url),
        showNotification: true,
        allowCellular: true,
        openFileFromNotification: true, // Click to open after download
      );

      //Check if the relation between txn_type and module has been made or not
      //no duplicate record then add the relation between txnType and Module
      // int? recordExisting = await Global.moduleDao.checkDuplicateTxnType(Global.moduleCode,widget.pageDir);
      // if(recordExisting == null){
      //   //if Its a new item add it to the module table
      //   int? lastIdModule = await Global.moduleDao.getLastId();
      //   int idModule = 1;
      //   if (lastIdModule != null) {
      //     idModule = lastIdModule + 1;
      //   }
      //   ModuleTxnTypeTable  moduleTxnTypeTable = ModuleTxnTypeTable(idModule, widget.pageDir, Global.moduleCode);
      //   Global.moduleDao.insertModule(moduleTxnTypeTable).then((value) {
      //     print('Module relation created between ${widget.pageDir} and ${Global.moduleCode}');
      //     // AppUtils.showToastGreenBg(context, 'Successfully added to the local database');
      //   }).onError((error, stackTrace) {
      //     print('Module relation failed $error');
      //     // AppUtils.showToastRedBg(context, 'Something went wrong while adding data to local database');
      //   });
      // }

      //checking if item Exists in FileDownloaderData table
      // var isDuplicate = await Global.fileDownloaderDao.checkExistingItem(url);
      // if(isDuplicate != null) {
      //   // AppUtils.showToastRedBg(context, 'Item Already Exists');
      // }
      // else {

      //   //if Its a new item add it to the table
      //   int? lastId = await Global.fileDownloaderDao.getLastId();
      //   int id = 1;
      //   if (lastId != null) {
      //     id = lastId + 1;
      //   }
      //   int timeCreated  = DateTime.now().millisecondsSinceEpoch;
      //   int fileType = AppUtils.getFileType(url);
      //   /*
      //     int id;
      //     final String file_task_id;
      //     final String url;
      //     final String pageDir;//txn_type(LA)
      //     final int created_date;
      //   */
      //   FileDownloaderData fileDataToStore = FileDownloaderData(
      //     id,
      //     newTaskId!,//newTaskId
      //     url,
      //     widget.pageDir,
      //     fileType,
      //     timeCreated,
      //   );

      //   Global.fileDownloaderDao.insertFileData(fileDataToStore).then((value) {
      //     print('Successfully Item Added At Index : $id!');
      //     // AppUtils.showToastGreenBg(context, 'Successfully added to the local database');
      //   }).onError((error, stackTrace) {
      //     print('failed To Add Item at $error');
      //     // AppUtils.showToastRedBg(context, 'Something went wrong while adding data to local database');
      //   });

      // }

      setState(() {
        taskMap[taskId] =
            newTaskId!; // Store the actual download taskId in the map
        urlStatus![index] = DownloadTaskStatus.running; // to show the loader
      });
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

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isLoaded
        ? widget.urls.isEmpty
            ? const CommonEmptyList()
            : ListView.builder(
                itemCount: widget.urls.length,
                shrinkWrap: true,
                physics: widget.isScrollable
                    ? null
                    : const NeverScrollableScrollPhysics(),
                padding: widget.listPadding ?? EdgeInsets.zero,
                itemBuilder: (context, index) {
                  String url = widget.urls[index];
                  String taskId = taskIds[index];
                  Widget progressChild =
                      getWidget(url, taskId, urlStatus![index], index);
                  return widget.childBuilder(index, progressChild, () {
                    // => _deleteItem(index)
                  });
                },
              )
        : const CustomLoader(
            index: 2,
          );
  }

  // DownloadTaskStatus myQuery(String url) {
  //   if (dataDownloadedList != null && dataDownloadedList!.isNotEmpty) {
  //     DownloadTask task = dataDownloadedList!.firstWhere(
  //       (task) => task.url == url,
  //       orElse: () => throw Exception('Task with URL $url not found'),
  //     );
  //     return task.status;
  //   }
  //   return DownloadTaskStatus.undefined;
  // }

  Widget getWidget(
      String url, String taskId, DownloadTaskStatus status, int index) {
    switch (status) {
      case DownloadTaskStatus.undefined:
        return IconButton(
          icon: const Icon(Icons.download),
          onPressed: () {
            _download(url, taskId, index); // Download action
          },
        );

      case DownloadTaskStatus.canceled:
      case DownloadTaskStatus.failed:
        return IconButton(
          icon: const Icon(Icons.refresh), // Retry button for failed/canceled
          color: Colors.red,
          onPressed: () {
            AppUtils.yesNoDialog(
              context,
              'Are you Sure?',
              'Retry Download for this item!',
              onYes: () {
                retryDownload(url, taskId, index);
              },
            );
          },
        );

      case DownloadTaskStatus.enqueued:
        return IconButton(
          icon: const Icon(Icons.cancel),
          color: Colors.blue,
          onPressed: () {
            AppUtils.yesNoDialog(
              context,
              'Are you Sure?',
              'Cancel Download for this item!',
              onYes: () {
                cancelDownload(url, taskId, index);
              },
            );
          },
        );

      case DownloadTaskStatus.running:
        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.grey, width: 1.0), // Border for the box
            borderRadius: BorderRadius.circular(8), // Rounded corners
            color: Colors.white, // Background color
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Space out elements
            children: [
              // Smaller Circular Progress with percentage
              SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  alignment: Alignment
                      .center, // Align percentage in the center of the circle
                  children: [
                    // Circular Progress Indicator
                    CircularProgressIndicator(
                      value: (progressMap[taskMap[taskId]] ?? 0) / 100,
                      strokeWidth: 4, // Thinner progress bar
                      backgroundColor:
                          Colors.grey[300], // Background circle color
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.orange), // Progress circle color
                    ),
                    // Text showing percentage in the center
                    Positioned(
                      child: Text(
                        '${progressMap[taskMap[taskId]] ?? 0}%', // Show percentage
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // Pause Button
              IconButton(
                icon: const Icon(Icons.pause_circle_filled),
                color: Colors.orange,
                onPressed: () {
                  // Pause the download and change the status
                  pauseDownload(url, taskId, index);
                },
              ),

              // Cancel Button
              IconButton(
                icon: const Icon(Icons.cancel),
                color: Colors.red,
                onPressed: () {
                  // Cancel the download
                  cancelDownload(url, taskId, index);
                },
              ),
            ],
          ),
        );

      case DownloadTaskStatus.paused:
        return IconButton(
          icon: const Icon(
              Icons.play_circle_filled), // Play button to resume download
          color: Colors.yellow,
          onPressed: () {
            // Resume the download and change status back to running
            resumeDownload(url, taskId, index);
          },
        );

      case DownloadTaskStatus.complete:
        return IconButton(
          icon: const Icon(Icons.check_circle),
          color: Colors.green,
          onPressed: () {
            // Open the downloaded file
            openDownloadedFile(url, taskId);
          },
        );

      default:
        return const SizedBox();
    }
  }

  void retryDownload(String url, String taskId, int index) async {
    String? newTaskId = await FlutterDownloader.retry(taskId: taskMap[taskId]!);
    if (newTaskId == null) {
      //handle if this function fails //try once again
      // await FlutterDownloader.cancel(taskId: taskMap[taskId]!);
      //cancel functionality not working so have to hit the data base and make it canceled
      await FlutterDownloader.loadTasksWithRawQuery(
          query: '''UPDATE task SET status = 5 WHERE url = '$url';''');
      newTaskId = await FlutterDownloader.retry(taskId: taskMap[taskId]!);
      if (newTaskId != null) {
        taskMap[taskId] = newTaskId;
        urlStatus![index] = DownloadTaskStatus.running;
      }
    } else {
      taskMap[taskId] = newTaskId;
      urlStatus![index] = DownloadTaskStatus.running;
    }
    setState(() {});
  }

  void cancelDownload(String url, String taskId, int index) async {
    await FlutterDownloader.pause(taskId: taskMap[taskId]!);
    // await FlutterDownloader.cancel(taskId: taskMap[taskId]!);
    //cancel functionality not working so have to hit the data base and make it canceled
    await FlutterDownloader.loadTasksWithRawQuery(
        query: '''UPDATE task SET status = 5 WHERE url = '$url';''');
    urlStatus![index] = DownloadTaskStatus.canceled;
    setState(() {});
  }

  void pauseDownload(String url, String taskId, int index) async {
    await FlutterDownloader.pause(taskId: taskMap[taskId]!);
    urlStatus![index] = DownloadTaskStatus.paused;
    setState(() {});
  }

  void resumeDownload(String url, String taskId, int index) async {
    // Resume download logic
    String? newTaskId =
        await FlutterDownloader.resume(taskId: taskMap[taskId]!);
    if (newTaskId == null) {
      // await FlutterDownloader.cancel(taskId: taskMap[taskId]!);
      //cancel functionality if not working then have to hit the data base and make it canceled
      FlutterDownloader.loadTasksWithRawQuery(
          query: '''UPDATE task SET status = 5 WHERE url = '$url';''');
      urlStatus![index] = DownloadTaskStatus.canceled;
    } else {
      taskMap[taskId] = newTaskId;
      urlStatus![index] = DownloadTaskStatus.running;
    }
    setState(() {});
  }

  void openDownloadedFile(String url, String taskId) {
    FlutterDownloader.open(taskId: taskMap[taskId]!);
  }

  // void _deleteItem(int index) {
  //   //pausing any download
  //   if (urlStatus![index] == DownloadTaskStatus.running) {
  //     FlutterDownloader.pause(taskId: taskMap[taskIds[index]]!);
  //     urlStatus![index] = DownloadTaskStatus.paused;
  //     setState(() {});
  //   }
  //   //running any page delete functionality
  //   widget.deleteFunctionality(index).then((success) {
  //     if (success) {
  //       //if success then delete as per this page
  //       //if undefined means they are not in the table so need to remove anything in the table
  //       if (urlStatus![index] != DownloadTaskStatus.undefined) {
  //         FlutterDownloader.remove(
  //           taskId: taskMap[taskIds[index]]!,
  //           //if the task is downloaded then remove it
  //           shouldDeleteContent:
  //               urlStatus![index] == DownloadTaskStatus.complete,
  //         );
  //       }
  //       Global.fileDownloaderDao.deleteUsingUrl(widget.urls[index]);
  //       widget.urls.removeAt(index);
  //       urlStatus!.removeAt(index);
  //       setState(() {});
  //     }
  //   });
  // }
}
