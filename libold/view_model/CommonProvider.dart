// ignore_for_file: unused_field

import 'package:flutter/material.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:petty_cash/data/models/common/common_searching_model.dart';

import 'package:petty_cash/data/repository/general_rep.dart';
import 'package:petty_cash/global.dart';
import 'package:petty_cash/resources/api_url.dart';
import 'package:petty_cash/utils/app_utils.dart';
import 'package:petty_cash/view/hse_common_pagination_search_list.dart';

class CommonVM extends ChangeNotifier {
  final _myRepo = GeneralRepository();
  late PagingController<int, SearchList> pagingController;
  int pageIndex = 0;
  bool isPullToRefresh = false;

  CommonVM() {
    pageIndex = 0;
    pagingController = PagingController(firstPageKey: 0);
    // getDashBoardTabApi();
    pagingController.addPageRequestListener((pageKey) {
      // set pageIndex as pageKey if they are in case diff.
      pageIndex = pageKey;
      // callDashBoardApi();
    });
  }

  Map<String, String> getHseCommonSearchData(int key, int type, int ca) {
    String search = '';
    Map<String, String> data = {};
    if (type == 1) {
      switch (key) {
        case 1:
          search = 'PROJECT';
          break;
        case 2:
          search = 'DIVISION';
          break;
        case 3:
          search = 'DEPARTMENT';
          break;
        case 4:
          search = 'LOCATION'; //Doc Location and location has same searching
          break;
        case 5:
          search = 'EMPLOYEE';
          break;
        case 6:
          search = 'OWNING_DEPARTMENT';
          break;
        case 7:
          search = 'ITEM';
          break;
      }
      data = {
        'company_id': Global.empData!.companyId.toString(),
        'search_type': search,
        'search_keyword':
            '', //for create the view for new transactions,0 for other things
        'next_page_no': pageIndex.toString(),
      };
    } else if (type == 2) {
      data = {
        'company_id': Global.empData!.companyId.toString(),
        'search': '',
      };
    } else if (type == 3) {
      int a = ca;
      data = {
        'company_id': Global.empData!.companyId.toString(),
        'search': '',
        'type': a.toString(), //1 is action 2 is Category
      };
    }
    return data;
  }

  HseSorCommonSearchingModel? commonSearchData;

  Future<void> callCommonSearchApi(
      BuildContext context, int key, int type, int ca) async {
    // commonSearchData = HseSorCommonSearchingModel.fromJson({});//clearing
    if (key == 5) {
      Navigator.pushNamed(context, HsePaginationSearching.id);
    }
    setLoading(true);
    String url = '';
    if (type == 1) {
      url = ApiUrl.baseUrl! + ApiUrl.hseCommonSearch;
    }
    if (type == 2) {
      url = ApiUrl.baseUrl! + ApiUrl.hseReferenceDocSearch;
    }
    if (type == 3) {
      url = ApiUrl.baseUrl! + ApiUrl.hseActionNCategorySearch;
    }
    _myRepo.postApi(url, getHseCommonSearchData(key, type, ca)).then((value) {
      pagingController.refresh();
      commonSearchData = HseSorCommonSearchingModel.fromJson(value);
      if (commonSearchData!.errorCode == 200) {
        if (AppUtils.errorMessage.isEmpty) {
          if (commonSearchData!.data!.searchList!.length < 15) {
            pagingController
                .appendLastPage(commonSearchData!.data!.searchList!);
          } else {
            var nextPageKey =
                pageIndex + commonSearchData!.data!.searchList!.length;
            if (nextPageKey == commonSearchData!.data!.totalRecords) {
              pagingController
                  .appendLastPage(commonSearchData!.data!.searchList!);
            } else {
              pagingController.appendPage(
                  commonSearchData!.data!.searchList!, nextPageKey);
            }
          }
        }
      } else {
        AppUtils.showToastRedBg(
            context, commonSearchData!.errorDescription.toString());
        // AppUtils.errorMessage = commonSearchData!.errorDescription.toString();
      }
    }).onError((error, stackTrace) {
      if (AppUtils.errorMessage.isEmpty) {
        AppUtils.errorMessage = error.toString();
      }
      pagingController.error = error;
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  // Used in CommonTextForm Field
  bool isLoading = true;

  void setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  bool _obscureText = true;
  bool get obscureText => _obscureText;
  void setObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  // Used in Animated Button
  bool animateContainer = true;
  bool _isAnimatedLoading = false;

  bool get isAnimatedLoading => _isAnimatedLoading;

  void setAnimatedLoading(bool val) {
    _isAnimatedLoading = val;
    notifyListeners();
  }

  void setContainer(bool val) {
    setAnimatedLoading(animateContainer);
    animateContainer = !val;
    notifyListeners();
  }

  TextEditingController pageSearchController = TextEditingController();
  int page = 0;
  void setPage(String val) {
    if (val.isNotEmpty) {
      page = int.parse(val);
      notifyListeners();
    }
  }

  //Common Video Functions

  List<String> allUrl = [
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
  ];

  // void videoInitialize(int index, int type) {
  //   //initialize the data before you have invoked this function
  //   if (Global.allVideoData[index].videoController == null) {
  //     //to avoid reinitialization
  //     if (type == 2) {
  //       Global.allVideoData[index].videoController = VideoPlayerController.file(
  //         File(Global.allVideoData[index].url),
  //         videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
  //       );
  //     } else if (type == 1) {
  //       Global.allVideoData[index].videoController =
  //           VideoPlayerController.asset(
  //         Global.allVideoData[index].url,
  //         videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
  //       );
  //     } else {
  //       Global.allVideoData[index].videoController =
  //           VideoPlayerController.networkUrl(
  //         Uri.parse(Global.allVideoData[index].url),
  //         videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
  //       );
  //     }

  //     Global.allVideoData[index].initializeVideoPlayerFuture =
  //         Global.allVideoData[index].videoController!.initialize().then((_) {
  //       Global.allVideoData[index].isBuffering = false;

  //       Global.allVideoData[index].videoController!.addListener(() {
  //         Global.allVideoData[index].isBuffering =
  //             Global.allVideoData[index].videoController!.value.isBuffering;
  //         if (Global.allVideoData[index].videoController!.value.position ==
  //             Global.allVideoData[index].videoController!.value.duration) {
  //           Global.allVideoData[index].isVideoEnded = true;
  //         }
  //         notifyListeners();
  //       });

  //       notifyListeners();
  //     });
  //   }
  // }

  // void onPlayNPause(int index) {
  //   if (Global.allVideoData[index].videoController!.value.isPlaying) {
  //     Global.allVideoData[index].videoController!.pause();
  //   } else {
  //     if (Global.allVideoData[index].isVideoEnded) {
  //       Global.allVideoData[index].videoController!.seekTo(Duration.zero);
  //       Global.allVideoData[index].isVideoEnded = false;
  //     }
  //     Global.allVideoData[index].videoController!.play();
  //     //Only 1 video will play at a time
  //     for (int i = 0; i < Global.allVideoData.length; i++) {
  //       //pausing rest of the video
  //       if (i != index) {
  //         Global.allVideoData[i].videoController!.pause();
  //       }
  //     }
  //   }
  //   notifyListeners();
  // }

  // void onFullScreen(BuildContext context, int index, int type, bool doDispose) {
  //   for (int i = 0; i < Global.allVideoData.length; i++) {
  //     //pausing all of the video
  //     if (Global.allVideoData[i].videoController != null) {
  //       Global.allVideoData[i].videoController!.pause();
  //     }
  //   }
  //   // Global.allVideoData[index].videoController!.pause();
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => CustomVideoPlayer(
  //         url: Global.allVideoData[index].url,
  //         isAnotherScreen: true,
  //         initialPosition:
  //             Global.allVideoData[index].videoController!.value.position,
  //         type: type,
  //         videoIconColor: Global.allVideoData[index].defaultVideoIconColor,
  //         index: index,
  //         doDispose: doDispose,
  //       ),
  //     ),
  //   ).then((value) {
  //     if (Global.isVideoTrue) {
  //       Global.allVideoData[index].videoController!.seekTo(Global.videoTime!);
  //       Global.isVideoTrue = false;
  //     }
  //     // Future.delayed(const Duration(milliseconds: 500), () {videoModel.videoController!.play();});
  //   });
  // }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }

  // void onInvertColor(int index) {
  //   if (Global.allVideoData[index].defaultVideoIconColor == Colors.white) {
  //     Global.allVideoData[index].defaultVideoIconColor = Colors.black;
  //   } else {
  //     Global.allVideoData[index].defaultVideoIconColor = Colors.white;
  //   }
  //   notifyListeners();
  // }

  // void setHideIcons(int index) {
  //   Global.allVideoData[index].isHideIcons =
  //       !Global.allVideoData[index].isHideIcons;
  //   notifyListeners();
  // }

  // void onSwipeUp(BuildContext context, int index, int type, bool doDispose) {
  //   onFullScreen(context, index, type, doDispose);
  // }
}
