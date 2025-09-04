// ignore_for_file: unused_import, use_key_in_widget_constructors, library_private_types_in_public_api, unused_local_variable

import 'dart:isolate';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/resources/app_extension_context.dart';
import 'package:petty_cash/view/common/Downloads_Common/common_download.dart';
import 'package:petty_cash/view/common_annotated_region.dart';
import 'package:petty_cash/view/widget/common_text.dart';

class CommonDownloadView extends StatefulWidget {
  @override
  _CommonDownloadViewState createState() => _CommonDownloadViewState();
}

class _CommonDownloadViewState extends State<CommonDownloadView>
    implements RefreshListener {
  final ReceivePort _port = ReceivePort();
  Map<String, DownloadTask> taskIdToItemMap = {};
  int progress = 0;

  @override
  void initState() {
    //initialize all the video data here or in VM Constructor and call it up to you
    //Video
    //disposing any old video controller cannot have to many controllers or it crashes

    loadAllTask();
    super.initState();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      // DownloadTaskStatus status = data[1];
      int status = data[1];
      progress = data[2];
      setState(() {}); // Update UI with progress
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  // Callback for download progress
  // static void downloadCallback(
  //     String id, DownloadTaskStatus status, int progress) {
  //   final SendPort? send =
  //       IsolateNameServer.lookupPortByName('downloader_send_port');
  //   send?.send([id, status, progress]);
  // }

  int setVideo(int index) {
    int mainIndex = -1;
    if (dataDownloadedList![index].filename!.endsWith('.mp4')) {
      //checking for redundancy
      // bool redundancy = false;
      // for (int i = 0; i < Global.allVideoData.length; i++) {
      //   if (Global.allVideoData[i].url ==
      //       '${dataDownloadedList![index].savedDir}/${dataDownloadedList![index].filename}') {
      //     redundancy = true;
      //     break;
      //   }
      // }
      //if redundancy is not there then only add video path
      // if (!redundancy) {
      //   //Setting the video
      //   Global.allVideoData.add(VideoModel(
      //       url:
      //           '${dataDownloadedList![index].savedDir}/${dataDownloadedList![index].filename}'));
      // }
      //getting exact index of the item in Global.allVideoData
      // mainIndex = Global.allVideoData.indexWhere((video) =>
      //     video.url ==
      //     '${dataDownloadedList![index].savedDir}/${dataDownloadedList![index].filename}');
    }
    return mainIndex;
  }

  @override
  Widget build(BuildContext context) {
    return CommonAnnotatedRegion(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: context.resources.color.themeColor,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const CommonTextView(
              label: 'Downloads',
              fontSize: 22.0,
              color: Colors.white,
            )),
        body: (dataDownloadedList != null && dataDownloadedList!.isNotEmpty)
            ? ListView.builder(
                itemCount: dataDownloadedList!.length,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.only(bottom: 8.0),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  //Setting Video Item
                  int videoIndex = setVideo(index);
                  return Card(
                    margin:
                        const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 8.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Calling video if its a video
                              dataDownloadedList![index]
                                      .filename!
                                      .endsWith('.mp4')
                                  ? SizedBox()
                                  : Container(
                                      margin: const EdgeInsets.only(top: 3.0),
                                      height: 45,
                                      width: 45,
                                      child: CachedNetworkImage(
                                        imageUrl: dataDownloadedList![index]
                                            .url
                                            .toString(),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 35.0,
                                          height: 35.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        progressIndicatorBuilder:
                                            (context, url, progress) => Center(
                                          child: SizedBox(
                                            width: 10.0,
                                            height: 10.0,
                                            child: CircularProgressIndicator(
                                              value: progress.progress,
                                              color: context
                                                  .resources.color.themeColor,
                                              strokeWidth: 1,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.person,
                                          size: 45,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      dataDownloadedList![index]
                                          .filename
                                          .toString(),
                                      style: const TextStyle(
                                          fontFamily: 'Gilroy-Light',
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      dataDownloadedList![index].url.toString(),
                                      style: const TextStyle(
                                          fontFamily: 'Gilroy-Light',
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      dataDownloadedList![index]
                                          .savedDir
                                          .toString(),
                                      style: const TextStyle(
                                          fontFamily: 'Gilroy-Light',
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      dataDownloadedList![index]
                                          .status
                                          .name
                                          .toString(),
                                      style: const TextStyle(
                                          fontFamily: 'Gilroy-Light',
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.green),
                                    ),
                                    Text(
                                      CommonDownload(context, this)
                                          .getDateTimeFromTimeStamp(
                                              dataDownloadedList![index]
                                                  .timeCreated,
                                              'dd-MMM-yyyy HH:mm:ss'),
                                      style: const TextStyle(
                                          fontFamily: 'Gilroy-Light',
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4.0, bottom: 4.0),
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                            activeTrackColor: Colors.blue,
                                            inactiveTrackColor: Colors.grey,
                                            thumbShape:
                                                SliderComponentShape.noThumb,
                                            overlayShape:
                                                const RoundSliderOverlayShape(
                                                    overlayRadius: 0.0),
                                            trackShape:
                                                const RectangularSliderTrackShape()),
                                        child: Slider(
                                          value: dataDownloadedList![index]
                                              .progress
                                              .toDouble(),
                                          min: 0,
                                          max: 100,
                                          divisions: 100,
                                          label:
                                              '${dataDownloadedList![index].progress.round()}%',
                                          onChanged: null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            width: MediaQuery.of(context).size.width,
                            height: 0.5,
                            color: Colors.black.withOpacity(0.3),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: getWidget(dataDownloadedList![index])),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                height: 25.0,
                                width: 0.5,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.link,
                                      color: Colors.blueAccent,
                                    ),
                                    onPressed: () {
                                      CommonDownload(context, this)
                                          .copyTextToClipboard(
                                              dataDownloadedList![index].url,
                                              context);
                                    },
                                  )),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                height: 25.0,
                                width: 0.5,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.folder_copy_outlined,
                                      color: Colors.blueAccent,
                                    ),
                                    onPressed: () async {
                                      // String ss = dataDownloadedList![index].url;
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => VideoPlayerMain(ss)))
                                      //     .then((value) {});
                                      bool d = await FlutterDownloader.open(
                                          taskId: dataDownloadedList![index]
                                              .taskId);
                                    },
                                  )),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                height: 25.0,
                                width: 0.5,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.highlight_remove,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      // Global.fileDownloaderDao.deleteUsingUrl(
                                      //     dataDownloadedList![index].url);
                                      FlutterDownloader.remove(
                                          taskId:
                                              dataDownloadedList![index].taskId,
                                          shouldDeleteContent: true);
                                      dataDownloadedList!.removeAt(index);
                                      setState(() {});
                                      // loadAllTask();
                                    },
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: CommonDownload.getNoDataFound(
                    context, 'No Files Download')),
      ),
    );
  }

  List<DownloadTask>? dataDownloadedList = [];

  void loadAllTask() async {
    dataDownloadedList = await FlutterDownloader.loadTasksWithRawQuery(
        query: 'SELECT * FROM task ORDER BY time_created DESC');
    // dataDownloadedList = await FlutterDownloader.loadTasks();
    if (dataDownloadedList != null && dataDownloadedList!.isNotEmpty) {
      for (int i = 0; i < dataDownloadedList!.length; i++) {
        taskIdToItemMap[dataDownloadedList![i].taskId.toString()] =
            dataDownloadedList![i];
      }
    }
    setState(() {});
  }

  @override
  void refresh() {
    loadAllTask();
  }

  Widget getWidget(DownloadTask downloadTask) {
    switch (downloadTask.status) {
      case DownloadTaskStatus.undefined:
        return const Icon(Icons.error,
            color: Colors.grey, key: Key("undefined"));
      case DownloadTaskStatus.canceled:
        return const Icon(Icons.cancel,
            color: Colors.red, key: Key("canceled"));
      case DownloadTaskStatus.enqueued:
        return const Icon(Icons.schedule,
            color: Colors.blue, key: Key("enqueued"));
      case DownloadTaskStatus.running:
        // return const Icon(Icons.sync, color: Colors.orange, key: Key("running"));
        return CircularProgressIndicator(value: downloadTask.progress / 100);
      case DownloadTaskStatus.complete:
        return const Icon(Icons.check_circle,
            color: Colors.green, key: Key("complete"));
      case DownloadTaskStatus.failed:
        return const Icon(Icons.error_outline,
            color: Colors.red, key: Key("failed"));
      case DownloadTaskStatus.paused:
        return const Icon(Icons.pause_circle_filled,
            color: Colors.yellow, key: Key("paused"));
      default:
        /* return const Icon(Icons.error, color: Colors.black, key: Key("failedWidget"));*/
        return IconButton(
          icon: const Icon(Icons.download),
          onPressed: () {
            CommonDownload(context, this).downloadFile(downloadTask.url);
          },
        );
    }
  }
}
